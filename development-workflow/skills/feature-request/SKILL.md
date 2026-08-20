---
name: feature-request
description: Use when asked to make a feature request.
---

# Feature Request

## Overview

Render a request you are handed as an intake ticket: who wants what, why, and how anyone will know it landed. This skill is the document's format. It is not an instruction to explore, design, or file.

Output is tracker-agnostic markdown — Linear, Jira, GitHub Issues, or a paste. The title renders as the document's first line; whoever files it copies that line into the tracker's title field.

## The template

```markdown
# <one-line title — the outcome wanted, not the implementation>

## User story

As a <role>, I want <capability>, so that <benefit>.

## Acceptance criteria

- **Given** <context>, **when** <action>, **then** <observable outcome>.

## Technical notes

<anything already known that the story and criteria don't carry — the whole section drops when there is nothing>
```

The story and its criteria are the document. There is no separate Problem, Motivation, or Proposed outcome section: `so that` carries the motivation and `I want` carries the outcome, more briefly and in a shape every tracker's readers already recognize.

## Filling the slots

### Title

The title names what becomes possible, not the mechanism someone imagined. A title that names a mechanism decides the design before anyone has weighed it.

### User story

Three clauses, none of them filler.

- **`As a`** — a real role someone in the conversation identified. Not "as a user", which names nobody and constrains nothing.
- **`I want`** — a capability stated as behavior, not construction. "See which comments I have already answered" is a capability; "add a `resolved` column" is a design, and belongs in Technical notes if it belongs anywhere.
- **`so that`** — the whole motivation. A `so that` that merely restates the `I want` in other words is the signal that nobody has established why this matters; say that in the slot rather than dressing it up.

### Acceptance criteria

Each criterion is a statement someone can confirm or deny by looking at the shipped thing. Given/When/Then is the form, since it forces the context and the trigger to be named rather than assumed. "Works well" is not a criterion.

Zero criteria is a legitimate state for a very early request. It renders as a line saying the outcome is not yet pinned down — never as invented ones, since an invented criterion is indistinguishable from an agreed one once it is on the card.

### Technical notes

Not the point of the document, but write down what you have. Intake is the story and its criteria; technical detail is not what the document is for. Still, when something is already worked out, it goes here rather than being lost. Three sections is a deliberate floor, and this is the slot that keeps the floor from costing context.

Its bound is the material itself, not a length: the slot records what is in hand and never goes to produce more.

Unlike the other two sections, it is omitted rather than gap-marked. An absent section reads as "nothing known yet", which is the accurate state for most intake.
