---
name: design-doc
description: Use when the user requests a Google-style design doc.
---

# Design Doc

## Overview

Write up an already-agreed design as a Google-style design doc, at design altitude, from the conversation context. This skill is the document's format.

If the design isn't settled enough to fill the load-bearing sections — Design, Goals & Non-Goals — say so plainly and name what's still missing.

## Template

The doc renders these sections, in this order:

```markdown
# <one-line title>

## Context & Scope

## Goals & Non-Goals

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

Every section renders, in the Template's order; one with nothing to say collapses to a one-line "None". No section descends to file-level technicals — where it's not stated, assume design altitude. When a topic is out of scope, name it and stop: the doc parks nothing in a ticket, PR, or sibling doc, since "see SIDE-123" sends the reader chasing the boundary instead of reading it.

What each anchor holds:

- **Context & Scope** — objective background facts, plus one sentence naming what is being built. Two to three short paragraphs; rationale, goals, and mechanics live in their own sections, not here.
- **Goals & Non-Goals**
  - **Goals** — properties of the system or its callers, at the contract level. Each is a standing property: true continuously once this ships, so it can be checked at any point. Anything that happens once and is then permanently done is a task, not a goal. Typically 3–5 bullets.
  - **Non-Goals** — outcomes deliberately excluded. Include one only when a competent reader, having read Context and Goals, would _actively assume_ it is in scope and then plan, build, or review wrongly. State the boundary and stop. Typically 2–5 bullets.
- **Design** — the target system: components, data flow, and the key decisions. Its substructure adapts to the topic and is the only section whose shape varies.
- **Alternatives Considered** — the only place alternatives appear; other mechanisms that achieve the same goals, and why each was not chosen. Anything that would force an edit to the goals list is a scope change, not an alternative — it belongs in Non-Goals or its own doc.
- **Cross-cutting Concerns** — for each subsection, when the concern applies, explain _how_ the design addresses it — the impact and the mitigation. A short paragraph is the norm. When it doesn't apply, dismiss it falsifiably: state the assumption that makes it moot ("not applicable because no untrusted input crosses a boundary here").
- **Open Questions** — open points whose answer could change the design (its shape, scope, or feasibility). Two reasons a point is open: a decision the conversation deferred, or a load-bearing point you had to infer to keep the design coherent — flag the latter as an assumption to confirm. A purely local implementation choice with no design ripple is the implementer's call and does not belong here.
