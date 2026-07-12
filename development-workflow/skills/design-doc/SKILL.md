---
name: design-doc
description: Use when the user requests a Google-style design doc.
---

# Design Doc

## Overview

Write up an already-agreed design as a Google-style design doc, at design altitude, from the conversation context. Render it inline by default; never choose where it is stored.

## Input

The agreed design, drawn from the conversation. This skill does no questioning of its own — it reads what has already been settled and writes it up.

If the design isn't settled enough to fill the load-bearing sections — Design, Goals & Non-Goals — say so plainly and name what's still missing, rather than emitting a shell of "None"s. A near-empty doc is a signal the design isn't ready to write up, not a deliverable.

## Altitude

Design altitude: what to build and the shape of how — components, data flow, key decisions, and the alternatives weighed. Stop short of file-level technicals. Name each open point whose answer could change the design explicitly in Open Questions rather than leaving it implicit, so a downstream reader that lacks the original conversation sees the gap and settles it there, instead of inheriting silence.

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

What each anchor holds, at design altitude:

- **Context & Scope** — the problem and what the change touches.
- **Goals & Non-Goals** — what success means; the boundaries. Non-Goals covers only real scope boundaries a reasonable reader might otherwise assume to be in scope.
- **Design** — the target system; its substructure adapts to the topic and is the only section whose shape varies.
- **Alternatives Considered** — the only place alternatives appear; only genuine options a reader would weigh, and why each was not chosen.
- **Cross-cutting Concerns** — For each subsection, when the concern applies, explain _how_ the design addresses it — the impact and the mitigation. a short paragraph is the norm. When it doesn't apply, dismiss it falsifiably: state the assumption that makes it moot ("not applicable because no untrusted input crosses a boundary here").
- **Open Questions** — open points whose answer could change the design (its shape, scope, or feasibility). Two reasons a point is open: a decision the conversation deferred, or a load-bearing point you had to infer to keep the design coherent — flag the latter as an assumption to confirm. A purely local implementation choice with no design ripple is the implementer's call and does not belong here.

## Governing rules

1. **Emit inline; never pick a storage location.** Render the doc inline in chat as the deliverable — nothing written, no default destination. When the user asks to save it, write to the location they provide (confirm one if they don't), then report where it landed. Never choose a location unilaterally.
2. **Emit every section in the Template.** Render every section shown in the Template above, in that order. When a section has nothing to say, pick the right empty-state by intent: a section that is simply absent collapses to a one-line "None"; a Cross-cutting concern that doesn't apply uses the falsifiable "not applicable because…" (never "None"); an unresolved or inferred point goes to Open Questions. Never pad, never silently omit.
3. **Written as if fresh.** The doc is a standalone artifact, not a record of the conversation — describe the target system and its alternatives as though authored by someone never in the room. No conversational framing, no narration of how the decision was reached, no tangents.
4. **Never invent.** Build the doc only from what the conversation settled. Don't guess or manufacture a goal, alternative, decision, or cross-cutting analysis to fill a section — if the material isn't there, collapse the anchor to "None" or name the gap in Open Questions. When you must infer a load-bearing point (a component boundary, a data store, a scope call) to keep the design coherent, surface it in Open Questions as an assumption to confirm, not as settled fact. Reading cleanly never justifies inventing what was never decided.
