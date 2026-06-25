---
name: implementation-plan
description: Use when a design has settled in the conversation and you want it turned into a commit-by-commit implementation plan a fresh context can execute without losing intent.
---

# Implementation Plan

## Overview

Read the design already settled in the conversation and write it up as a structured implementation plan. This skill is independent of `design-doc` — it consumes conversation context directly, not that skill's output. As a building block, it owns document format and content quality and nothing else.

## Input

The settled design, drawn from the conversation. This skill does no design questioning of its own — it reads what was settled and writes it up.

## The content rule

Any choice a competent implementer could reasonably pick differently than intended gets spelled out; everything else is left free.

This keeps the plan lossless without lowering it to a line-by-line script. Decisions that have a single obvious right answer need no annotation; decisions where a capable person might go a different direction than the design intends must be made explicit.

## Readiness guard

Before writing, the skill applies the content rule as its trigger — if any choice a competent implementer could reasonably pick differently than intended is still unresolved in the conversation, it names that gap and stops rather than emitting a plan that silently hands off an unmade decision. This mirrors `design-doc`'s empty-state behavior: an incomplete plan is a signal the design isn't ready to write up, not a deliverable.

This is the guard's only condition. It does not judge whether the design is "too big" — that is upstream judgment, not this skill's concern.

## Plan structure

A plan is divided into tasks, each sized to one logical, independently committable change. This skill carries a bare template plus a section guide, mirroring the approach `design-doc` uses for its own template.

```markdown
# <plan title>

## Overview

## Context

## Tasks

### Task N: <imperative title>

- **Files:**
- **Change:**
- **Consumes:**
- **Produces:**
- **Done when:**
```

## Section guide

What each section holds:

- **Overview** — one paragraph: what this plan builds and the end state.
- **Context** — stable orientation true before the plan starts and throughout: key existing files and what they do, patterns/conventions to follow, settled design decisions bearing on the work. A fact you'd otherwise repeat across several task bodies belongs here; it is where any fact shared across tasks lives, so each task can be read on its own.
- **Tasks** — the work, divided so one task is one logical, independently committable change. Tasks are listed in **dependency order**: every `Consumes: from Task N` must reference an *earlier* task (a lower N) — dependencies point **backward only, never forward, never in a cycle** — so build order is verifiable by eye. Each task must be **self-contained**: an implementer reading only that task plus **Context** loses nothing; a task understandable only by reading other task bodies is not yet lossless.
  - **Files** — the comprehensive list of paths the task touches: created, modified, or deleted, including tests.
  - **Change** — prose describing the behavior this commit adds or modifies, including how edge and error cases are handled, with explicit call-outs of tricky parts. Reach for a literal snippet only where it is clearer than prose — an exact signature, a subtle algorithm, a specific data shape — and stay in prose otherwise.
  - **Consumes** — preconditions that must already hold, each tagged by source: *from Task N* for an earlier task's output (the seam to match), or *existing* for code already in the repo. Every *from Task N* must name something that task's `Produces` actually exposes — check this as you write, so the seam cannot silently mismatch. Omit when the task consumes nothing.
  - **Produces** — what the task exposes for later tasks to consume, including contract-level error outputs (thrown exceptions, error returns) a later task depends on.
  - **Done when** — the completion gate: the behavior in **Change** is covered by passing tests, plus any condition not expressible as a unit test (integration wired up, observable end state). Keep it explicit and checkable; avoid vague criteria like "works correctly."

## Cutting tasks

A clean task boundary is one coherent change committable on its own that, where the change is testable, leaves the tree green.

When a unit of behavior genuinely cannot be a single self-contained commit — for example, a schema migration and the code depending on it — it is **still one task**, and **Done when** names the multi-step end state rather than forcing an artificial split.

A task is finer-grained than a `decompose` slice: a slice is an independently shippable unit of observable value and typically spans several tasks. This distinction is orientation only — `decompose` is not a prerequisite for this skill.

## Artifact

The plan is persisted to a file. An inline-only render cannot be consumed by a fresh context — the reader that executes the plan may be a different session, days later, with none of the conversation history. A file is the artifact.

**Default location:** `~/.claude/projects/<slugified-project-path>/development-workflow/plans/`

This follows Claude Code's per-project convention. The slugified path is the absolute working-directory path with each `/` and `.` replaced by `-`, so any session launched from that directory resolves the identical path without coordination. For example, `/home/user/dev/my.app` becomes `-home-user-dev-my-app`.

The default location lives outside the repository — a disposable plan cannot be committed by accident — and, unlike a temp directory, it survives reboots and session boundaries for a handoff that may happen later.

**User-configurable override:** when the user specifies a different location, write there instead. This override is the only external input to the write path (see security note below).

**Filename:** `<YYYY-MM-DD>-<title-slug>.md`

The date prefix makes collisions structurally impossible and sorts plans chronologically; the slug keeps them identifiable. Plans are never overwritten or reused — each invocation writes a new file.

**No lifecycle is enforced.** Plans may live indefinitely. They are simply expected never to be reused.

**Security — override confinement (the tricky part):** the user-configurable override is the only external input to the write; it must be resolved and confined to the intended plans root before writing. Reject or clamp any path that escapes the root, for example via `..` traversal. The default path is a deterministic slug of the working directory with no external input and cannot be steered.

## Boundary

This skill produces the plan document and stops.

After writing, it reports the absolute path of the plan file as its deliverable. Reporting the artifact's location is describing the skill's own output, not execution guidance — it names no downstream skill.

The skill carries no execution guidance and offers no "which approach?" handoff menu. Stringing skills into a workflow, if ever wanted, is a separate skill.
