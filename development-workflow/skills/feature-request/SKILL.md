---
name: feature-request
description: Use when asked to make a feature request.
---

# Feature Request

## Overview

Render a request you are handed as an intake ticket: who wants what, why, and
how anyone will know it landed. This skill is the document's format. It is not
an instruction to explore, design, or file.

Output is tracker-agnostic markdown — Linear, Jira, GitHub Issues, or a paste.
The title renders as the document's first line; whoever files it copies that
line into the tracker's title field.

Follow the guidelines in the `technical-writing` skill.

## The template

```markdown
# <one-line title — the outcome wanted, not the implementation>

## User story

As a <role>, I want <capability>, so that <benefit>.

## Acceptance criteria

- **Given** <context>, **when** <action>, **then** <observable outcome>.

## Technical notes

<anything already known that the story and criteria don't carry — the whole
section drops when there is nothing>
```

The story and its criteria are the document. There is no separate Problem,
Motivation, or Proposed outcome section: `so that` carries the motivation and
`I want` carries the outcome, more briefly and in a shape every tracker's
readers already recognize.

## Filling the slots

### Title

The title names what becomes possible, not the mechanism someone imagined. A
title that names a mechanism decides the design before anyone has weighed it.

### User story

Three clauses, none of them filler. Hold the story to INVEST:

- **Independent** — it ships without waiting on another story nobody has filed.
  Fails as "I want to filter comments by reviewer" when comments carry no
  reviewer and no card adds one. A prerequisite already filed is a known fact,
  and goes in Technical notes.
- **Negotiable** — `I want` is a capability stated as behavior, not
  construction. "See which comments I have already answered" is a capability;
  "add a `resolved` column" is a design, and belongs in Technical notes if it
  belongs anywhere.
- **Valuable** — `As a` names a real role someone in the conversation
  identified, and `so that` carries the whole motivation. "As a user" names
  nobody and constrains nothing. A `so that` that merely restates the `I want`
  in other words is the signal that nobody has established why this matters.
- **Estimable** — enough is known that someone could size it. Fails as "I want
  comments imported from our other review tool" when nobody has named the tool.
- **Small** — one outcome. Fails as "I want to see which comments I have
  answered and be notified when a new one arrives": two outcomes, each with its
  own criteria.
- **Testable** — its outcome can be confirmed by looking at the shipped thing,
  which is what the acceptance criteria state. Fails as "I want the review flow
  to feel faster."

#### When the story fails

- **Independent, Small** — the story's shape is wrong. Raise it with the user
  alongside the draft, and leave the card clean. The fix is a split or another
  card, and which one is the user's call.
- **Valuable, Estimable, Testable** — something is not yet known. The slot it
  belongs to says so rather than dressing it up, the way zero criteria renders.
  Never Technical notes, which is omitted rather than gap-marked.
- **Negotiable** — the design moves to Technical notes.

The check is advisory. The draft always renders.

### Acceptance criteria

Each criterion is a statement someone can confirm or deny by looking at the
shipped thing. Given/When/Then is the form, since it forces the context and the
trigger to be named rather than assumed. "Works well" is not a criterion.

Zero criteria is a legitimate state for a very early request. It renders as a
line saying the outcome is not yet pinned down — never as invented ones, since
an invented criterion is indistinguishable from an agreed one once it is on the
card.

### Technical notes

Not the point of the document, but write down what you have. Intake is the story
and its criteria; technical detail is not what the document is for. Still, when
something is already worked out, it goes here rather than being lost. Three
sections is a deliberate floor, and this is the slot that keeps the floor from
costing context.

Its bound is the material itself, not a length: the slot records what is in hand
and never goes to produce more.

Unlike the other two sections, it is omitted rather than gap-marked. An absent
section reads as "nothing known yet", which is the accurate state for most
intake.
