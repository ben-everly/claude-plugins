---
name: design-doc
description: Use when the user requests a Google-style design doc.
---

# Design Doc

## Overview

Write up an already-agreed design as a Google-style design doc, at design
altitude, from the conversation context. This skill is the document's format.

Follow the guidelines in the `technical-writing` skill.

If the design isn't settled enough to fill the load-bearing sections — Design,
Goals & Non-Goals — say so plainly and name what's still missing.

## Template

The doc renders these sections, in this order:

```markdown
# <one-line title>

## Context & Scope

## Goals & Non-Goals

### Goals

### Non-Goals

## Design

## Alternatives Considered

## Cross-cutting Concerns

### Security

### Privacy

### Observability

### Operations

## Open Questions
```

## Section guide

Every section renders, in the Template's order; one with nothing to say
collapses to a one-line "None". Where it's not stated, assume design altitude.
When a topic is out of scope, name the boundary and stop — never outsource it to
a ticket, PR, or sibling doc, since "see SIDE-123" sends the reader chasing the
boundary instead of reading it. Linking material the reader doesn't need in
order to follow the design — a prototype, a full schema — is fine.

What each anchor holds:

- **Context & Scope** — objective background facts, plus one sentence naming
  what is being built. At most three short paragraphs; keep it concise.
  Rationale, goals, and mechanics live in their own sections, not here.
- **Goals & Non-Goals**
  - **Goals** — properties of the system or its callers, at the contract level.
    Each is a standing property: true continuously once this ships, so it can be
    checked at any point. Anything that happens once and is then permanently
    done is a task, not a goal. Typically 3–5 bullets.
  - **Non-Goals** — outcomes deliberately excluded. Include one only when a
    competent reader, having read Context and Goals, would _actively assume_ it
    is in scope and then plan, build, or review wrongly. Each must be something
    that could reasonably have been a goal — a negated goal like "the system
    shouldn't crash" is not a non-goal. State the boundary and stop. Typically
    2–5 bullets.
- **Design** — the solution, and why it best satisfies the Goals given the
  Context: the key decisions and the trade-offs behind them. Open with an
  overview, then go into the details. This is the only section whose shape
  varies — there is no one right way to describe a design. Use mermaid diagrams
  anywhere one could clarify. Sketch an API or data shape only where it carries
  a trade-off; include code or pseudo-code only for a novel algorithm. Weigh
  each of the following and include it only when it carries weight for this
  topic:
  - **System context** — the system as one box in the larger technical
    landscape: who calls it, what it depends on. Usually a diagram.
  - **APIs** — the surface callers see and what it guarantees them.
  - **Data storage** — what gets persisted, in what rough shape, and what that
    choice costs.
  - **Degree of constraint** — how much freedom the design had: a greenfield
    space, or a solution largely pinned down by existing systems. Tells the
    reader how much to read into each decision.
- **Alternatives Considered** — other mechanisms that reasonably achieve similar
  outcomes, and why each was not chosen. This is the only section where
  alternatives should appear.
- **Cross-cutting Concerns** — for each subsection, when the concern applies,
  explain _how_ the design addresses it — the impact and the mitigation. A short
  paragraph is the norm. When it doesn't apply, dismiss it falsifiably: state
  the assumption that makes it moot ("not applicable because no untrusted input
  crosses a boundary here").
- **Open Questions** — open points whose answer could change the design (its
  shape, scope, or feasibility). Two reasons a point is open: a decision the
  conversation deferred, or a load-bearing point you had to infer to keep the
  design coherent — flag the latter as an assumption to confirm. A purely local
  implementation choice with no design ripple is the implementer's call and does
  not belong here.
