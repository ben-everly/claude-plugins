---
name: design-doc
description: Use when the user requests a Google-style design doc.
---

# Design Doc

## Overview

Write up an already-agreed design as a Google-style design doc, at design altitude, from the conversation context. Render it inline by default; never choose where it is stored.

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

What each anchor holds. No section descends to file-level technicals. Where it's not stated, assume the section is written at design altitude.

- **Context & Scope** — objective background facts, plus one sentence naming what is being built. Two to three short paragraphs; rationale, goals, and mechanics live in their own sections, not here.
- **Goals & Non-Goals**
  - **Goals** — properties of the system or its callers, at the contract level. Each is a standing property: true continuously once this ships, so it can be checked at any point. Anything that happens once and is then permanently done is a task, not a goal. Typically 3–5 bullets.
  - **Non-Goals** — outcomes deliberately excluded. Include one only when a competent reader, having read Context and Goals, would _actively assume_ it is in scope and then plan, build, or review wrongly. State the boundary and stop. Typically 2–5 bullets.
- **Design** — the target system: components, data flow, and the key decisions. Its substructure adapts to the topic and is the only section whose shape varies.
- **Alternatives Considered** — the only place alternatives appear; other mechanisms that achieve the same goals, and why each was not chosen. Anything that would force an edit to the goals list is a scope change, not an alternative — it belongs in Non-Goals or its own doc.
- **Cross-cutting Concerns** — for each subsection, when the concern applies, explain _how_ the design addresses it — the impact and the mitigation. A short paragraph is the norm. When it doesn't apply, dismiss it falsifiably: state the assumption that makes it moot ("not applicable because no untrusted input crosses a boundary here").
- **Open Questions** — open points whose answer could change the design (its shape, scope, or feasibility). Two reasons a point is open: a decision the conversation deferred, or a load-bearing point you had to infer to keep the design coherent — flag the latter as an assumption to confirm. A purely local implementation choice with no design ripple is the implementer's call and does not belong here.

## Governing rules

1. **Write up only a settled design.** When the conversation hasn't settled the load-bearing sections — Design, Goals & Non-Goals — say so plainly and name what's missing, rather than emitting a shell of "None"s. A near-empty doc is a signal the design isn't ready to write up, not a deliverable.
2. **Emit inline; never pick a storage location.** Render the doc inline in chat as the deliverable — nothing written, no default destination. When the user asks to save it, write to the location they provide (confirm one if they don't), then report where it landed. Never choose a location unilaterally.
3. **Emit every section in the Template.** Render every section shown in the Template above, in that order. When a section has nothing to say, pick the right empty-state by intent: a section that is simply absent collapses to a one-line "None"; a Cross-cutting concern that doesn't apply uses the falsifiable "not applicable because…" (never "None"); an unresolved or inferred point goes to Open Questions. Never pad, never silently omit.
4. **Written as if fresh.** The doc is a standalone artifact, not a record of the conversation — describe the target system and its alternatives as though authored by someone never in the room. No conversational framing, no narration of how the decision was reached, no tangents.
5. **Never invent.** Build the doc only from what the conversation settled. Don't guess or manufacture a goal, alternative, decision, or cross-cutting analysis to fill a section — if the material isn't there, collapse the anchor to "None" or name the gap in Open Questions. When you must infer a load-bearing point (a component boundary, a data store, a scope call) to keep the design coherent, surface it in Open Questions as an assumption to confirm, not as settled fact. Reading cleanly never justifies inventing what was never decided.
6. **No parking lots.** The doc names no tickets, PRs, or sibling docs to park a topic in. An adjacent topic is a separate ticket, but that ticket's existence is not this doc's content — when something is out of scope, say what it is and stop. "See SIDE-123" or "covered by the auth redesign doc" makes every doc a node in a web and sends the reader chasing the boundary instead of reading it.
