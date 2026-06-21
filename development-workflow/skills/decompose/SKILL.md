---
name: decompose
description: Use when a change, feature, or issue feels too big to build or ship in one go and you want to split it into smaller pieces that can each ship on their own.
disable-model-invocation: true
---

# Decompose

## Overview

Split one oversized change into the smallest set of pieces — _slices_ — that can each ship on their own. Find an honest split, or say plainly that none exists.

A good split is rare, not automatic. Most of the value is in the rules below and in the willingness to refuse. Hold every candidate slice to the two rules; if no split clears them, recommend shipping the change whole.

## Input

- **change** (required) — the thing to split: a feature, issue, ticket, or described body of work, verbatim where possible.

Read the codebase — enough to find real seams and to sanity-check each slice against the rules.

## The rules

Every slice must pass **both** rules. A candidate that fails either is not a slice — the cut is wrong.

1. **Observable value** — once the slice ships, a user can observe something they couldn't before. A slice whose effect no user can observe isn't a deliverable.
2. **Independently deployable** — the slice can ship to production by itself without leaving the system broken or half-finished: no stranded migrations, no dangling references, no dead UI, no behavior that only works once a later slice lands, no newly-reachable sensitive data ahead of the controls that govern it. Shipping it and stopping there must leave a coherent system. A capability's security controls — authentication, authorization, input validation, output encoding, and audit logging — ship in the **same** slice as the capability they protect; "harden it later" is not a valid cut.

### Dependencies

Zero dependencies between slices is the goal — fully independent slices are the best split, and the fewer dependencies the better. Where a dependency is unavoidable, it must point **backward**, to a slice that ships earlier; never forward, never in a cycle. Two slices that each need the other are not two slices — they are one.

### Anti-pattern: splitting by layer

Cutting along technical layers (a database slice, an API slice, a UI slice) almost always fails the value rule: no single layer is observable on its own, and none ships without the others. Prefer thin **vertical** slices that cut through the layers — each a small end-to-end capability.

## The result

Return these fields.

- **verdict** — `Decompose` · `Do Not Decompose`
- **reason** _(when `Do Not Decompose`)_ — which rule the attempted cuts fail, and the recommendation to ship the change whole.
- **slices** _(when `Decompose`)_ — two or more slices in ship order (dependency order: independent slices first, dependents after what they need). Each slice carries:
  - **title** — a one-line name for the slice.
  - **value** — what becomes observable once it ships (this is what satisfies rule 1).
  - **deployable because** — why it can ship alone without leaving the system broken (this is what satisfies rule 2).
  - **depends on** — the earlier slices it needs, or `None`.

Together the slices must add up to the original change: no part of it left unassigned, and no slice doing work outside it.

## Common Mistakes

| Mistake                                                 | Fix                                                                                              |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| Always returning a split                                | If no split clears both rules, return `Do Not Decompose` and recommend shipping the change whole |
| Splitting by technical layer (DB / API / UI)            | Cut vertical slices that are each observable and shippable end-to-end                            |
| A slice that only works once a later slice ships        | Fails rule 2 — fold it into the slice it depends on, or re-cut                                   |
| Forward or circular dependencies between slices         | Dependencies point backward only; mutually dependent pieces are one slice                        |
| Splitting past the floor for its own sake               | Stop once each slice is worth shipping alone; smaller is not better                              |
| Slices that don't add up to the whole (gaps or overlap) | The union of slices must equal the original change exactly                                       |
| Deep-diving one slice's implementation here             | Keep grounding light.                                                                            |
