---
name: implementation-plan
description: Use when the user requests a commit-by-commit implementation plan a fresh context can execute without losing intent. Expects the design to have no unresolved gaps.
---

# Implementation Plan

## Overview

Read the design already settled in the conversation and write it up as a structured implementation plan. It consumes conversation context directly. As a building block, it owns document format and content quality and nothing else.

## Input

The settled design, drawn from the conversation. This skill does no design questioning of its own — it reads what was settled and writes it up.

## The content rule

Any choice a competent implementer could reasonably pick differently than intended gets spelled out; everything else is left free.

This keeps the plan lossless without lowering it to a line-by-line script. For example: if the design assumes events publish to a specific one of two existing queues, the plan must name which — a capable implementer could reasonably pick the other. The name of a local loop variable is left free: no intent rides on it.

## Readiness guard

Before writing, apply the content rule above as the trigger: if any choice it would require spelling out is still unresolved in the conversation, name that gap and stop rather than emitting a plan that silently hands off an unmade decision. An incomplete plan is a signal the design isn't ready to write up, not a deliverable.

This is the guard's only condition. It does not judge whether the design is "too big" — that is upstream judgment, not this skill's concern.

## Plan structure

A plan is divided into tasks, each sized to one logical, independently committable change. This skill carries a bare template plus a section guide.

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
- **Context** — stable orientation true before the plan starts and throughout: key existing files and what they do, patterns/conventions to follow, settled design decisions bearing on the work. Anything shared across tasks lives here, so each task reads on its own.
- **Tasks** — the work, divided so one task is one logical, independently committable change. Tasks are listed in **dependency order**: every `Consumes: from Task N` references an *earlier* task, a lower N. Dependencies point **backward only** — never forward, never in a cycle — so build order is verifiable by eye. Each task is also **self-contained**: an implementer reading only that task plus **Context** loses nothing, and a task understandable only by reading other task bodies is not yet lossless.
  - **Files** — the comprehensive list of paths the task touches: created, modified, or deleted, including tests.
  - **Change** — prose describing the behavior this commit adds or modifies, including how edge and error cases are handled, with explicit call-outs of tricky parts. Reach for a literal snippet only where it is clearer than prose — an exact signature, a subtle algorithm, a specific data shape — and stay in prose otherwise.
  - **Consumes** — preconditions that must already hold, each tagged by source: *from Task N* for an earlier task's output (the seam to match), or *existing* for code already in the repo. Every *from Task N* must name something that task's `Produces` actually exposes — check this as you write, so the seam cannot silently mismatch. Omit when the task consumes nothing.
  - **Produces** — what the task exposes for later tasks to consume, including contract-level error outputs (thrown exceptions, error returns) a later task depends on.
  - **Done when** — the completion gate: the behavior in **Change** is covered by passing tests, plus any condition not expressible as a unit test (integration wired up, observable end state). Keep it explicit and checkable; avoid vague criteria like "works correctly."

## Cutting tasks

A clean task boundary is one coherent change committable on its own that, where the change is testable, leaves the tree green.

When a unit of behavior genuinely cannot be a single self-contained commit — for example, a schema migration and the code depending on it — it is **still one task**, and **Done when** names the multi-step end state rather than forcing an artificial split.

## Output

The plan is the deliverable. If the user or a calling skill wants it written to a file, write to the location they give — confirm one if they don't — and report the path. This skill chooses no location or filename scheme of its own.

## Boundary

This skill produces the plan document and stops.

Reporting its output — the plan, and the file path when one was written — describes the skill's own output, not execution guidance. It offers no "which approach?" handoff menu and names no downstream skill; stringing skills into a workflow, if ever wanted, is a separate skill.
