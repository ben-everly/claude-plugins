---
name: prioritize
description: Use when prioritizing tickets or deciding which to work first.
argument-hint: "[tickets] [tiers=K] [settled: ticket ids]"
---

# Prioritize

## Overview

Rank tickets within their groups by Weighted Shortest Job First (WSJF), split
each group into tiers, and show the evidence behind every placement. Confirm
with the user before writing the ranking to a tracker.

A **group** is the narrowest container a ticket arrives with: a milestone, a
project, or an epic. Tickets rank only against their own group, because value is
only inferable relative to a shared goal. Within a group, a ticket's value is
how vital it is to the group's goal.

## Input

- **tickets** (required) — the tickets to rank, from any source. Each is its
  text plus any estimate, container, and relations (blocks, blocked by, depends
  on) that arrive with it. With no tickets given, use the tickets under
  discussion. With none under discussion, ask for them before starting.
- **tiers=K** (optional) — the most tiers per group. Default 3.
- **settled** (optional) — tickets the caller marks settled. A settled ticket is
  scored from its text alone; its code is not read.

Stop and ask when `K` is not a positive integer.

## Confidence

Every inference takes the confidence of the strongest evidence behind it, and
shows that evidence:

| Confidence | Evidence                                                                                                                                    |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| High       | A tracker relation or dependency; an external commitment (a deadline, a release, a blocked team); or a goal the ticket's text names.        |
| Medium     | Indirect signals: the same code area as the group's tickets, linked customer requests, a time-critical ticket in the group, group progress. |
| Low        | Only this skill's own read.                                                                                                                 |

A Low inference sets nothing. Show the lean and its reason, and mark the call as
the user's.

## Steps

### 1. Group the tickets

Put each ticket in the group of the container it arrives with. Tickets with no
container wait for step 3.

**Done when** every ticket with a container is in its container's group.

### 2. Read the code

For each unsettled ticket, locate the code it touches: enough to see what it
changes, what calls it, and which other tickets touch the same code. Stop before
designing the implementation.

**Done when** every claim in steps 3, 4, 5, and 7 about an unsettled ticket can
cite a file, a count, or a line of the ticket.

### 3. Infer groups for ungrouped tickets

Infer a group only for a ticket that arrives without a container. A ticket that
arrives with a container stays in it.

For each ungrouped ticket, in order:

1. **Match an existing container.** The candidates are the containers present in
   the input. A ticket matches the container whose tickets share its goal. Add
   it to that group.
2. **Else cluster.** Tickets that match no container but share a goal with each
   other form a new group, named for that goal.
3. **Else leave it.** A ticket that shares a goal with nothing stays alone as
   the user's call.

Mark every group formed or joined this way as _inferred_, with a confidence per
[Confidence](#confidence). At Low confidence, the ticket joins no group and is
not ranked.

An inferred group ranks like any other from step 4 on. Because its goal is
inferred, a value score in it is only as sound as that inference.

**Done when** every ticket is in exactly one group or listed as Low-confidence
with its lean, and every inferred group has a confidence and its evidence.

### 4. Size each ticket

Map an existing estimate by rank onto 1, 2, 3, 5, 8, 13. Fibonacci sizes keep
their value; T-shirt sizes XS, S, M, L, XL map to 1, 2, 3, 5, 8.

Rough-size an unestimated ticket against the project's estimation calibration: a
file the user or the project instructions name, else `.claude/estimation.md` in
the repository. With neither, use the base scope table below. Flag every rough
size as unestimated.

| Size | Base scope                                                          |
| ---- | ------------------------------------------------------------------- |
| 1    | Edits existing content and adds no behavior.                        |
| 2    | Changes behavior within one file and its tests.                     |
| 3    | Changes several files in one module, or adds one modeled component. |
| 5    | Changes several modules, or adds a mechanism other work builds on.  |
| 8    | Changes most modules, or adds a new subsystem.                      |
| 13   | Larger than one subsystem; the ticket likely needs splitting.       |

**Done when** every ticket has a size and every rough size is flagged.

### 5. Score the cost of delay

Score three parts on the scale 1, 2, 3, 5, 8, 13, using these anchors:

| Pts | Value (vital to group goal) | Time criticality                          | Risk reduction / enablement |
| --- | --------------------------- | ----------------------------------------- | --------------------------- |
| 13  | Goal fails without it       | Exploitable vuln, data loss, prod outage  | Unblocks most of the group  |
| 8   | On the goal's core path     | Stated deadline, blocks a release or team | Unblocks several tickets    |
| 5   | Important, has a workaround | Cost stated to rise soon                  | Unblocks one ticket         |
| 3   | Improves the goal           | —                                         | Removes a named risk        |
| 2   | Minor improvement           | —                                         | —                           |
| 1   | Polish                      | No evidence (default)                     | Enables nothing             |

Time criticality is 1 unless evidence raises it. Mark any time criticality above
1 as inferred, and cite the line that evidences it.

**Done when** every ticket has all three parts and every time criticality above
1 cites its line.

### 6. Compute WSJF

Cost of delay (CoD) = value + time criticality + risk reduction. WSJF = CoD ÷
size, rounded to two decimals.

**Done when** every ticket has a CoD and a WSJF.

### 7. Order each group

Sort the group by WSJF, highest first. Equal WSJF puts the smaller ticket first.

Then apply dependencies. A ticket another depends on ranks ahead of the
dependent regardless of score: move it to just ahead of its earliest dependent.
A dependency is a tracker relation, or one inferred from the work, such as a
ticket that creates something another ticket reorders. Cite the relation or the
lines behind an inferred one.

Give each placement a confidence per [Confidence](#confidence).

**Done when** every group is ordered, every placement has a confidence, and no
ticket ranks behind a ticket that depends on it.

### 8. Cut tiers

Mark every ticket with time criticality 13 _critical_. Critical tickets keep
their rank but take no tier.

For each group, pipe its remaining tickets to the bundled script, one
`id<TAB>wsjf` line each:

```sh
bash <skill base dir>/scripts/jenks.sh K < scores.tsv
```

It prints `id<TAB>tier` lines, tier 1 highest. It cuts Jenks natural breaks on
log(WSJF), uses at most as many tiers as there are distinct scores, and gives
equal scores the same tier. Take every tier from its output. On exit 2, the
script names the bad line on stderr; fix the input and rerun.

**Done when** every ticket has a tier or is critical.

### 9. Mark close calls and tier breaks

A **close call** is a pair of adjacent tickets whose order would swap if one
part of either ticket moved one step on the scale. Name the part and the step.

A **tier break** is a pair of adjacent tickets in different tiers.

**Done when** every adjacent pair in each group has been checked for both.

## Output

Report each group in turn: its name, then a ranked table, then its close calls
and tier breaks. Label an inferred group `(inferred)` and give its confidence
and evidence under the name. Each table row holds:

- **Rank** — the position in the group, 1 first.
- **Ticket** — its id or title.
- **V / TC / RR** — value, time criticality, and risk reduction. Mark an
  inferred time criticality with `*`.
- **Size** — with `(unest.)` when rough-sized.
- **WSJF**
- **Tier** — a number, or `critical`.
- **Confidence** — High, Medium, or Low. A Low row is a lean.
- **Rationale** — one line naming the evidence that placed it.

Below the table, list each cited line behind a `*` and each dependency move.
After the last group, list each ticket left ungrouped at Low confidence with its
lean and reason.

Applying the ranking is the caller's call.

```
Group: Checkout v2 (milestone)

| Rank | Ticket                          | V   | TC  | RR  | Size       | WSJF  | Tier     | Confidence | Rationale                                         |
| ---- | ------------------------------- | --- | --- | --- | ---------- | ----- | -------- | ---------- | ------------------------------------------------- |
| 1    | PAY-21 Card numbers in logs     | 8   | 13* | 1   | 2          | 11.00 | critical | High       | Logs full PANs (`charge.ts:88`); exploitable leak |
| 2    | PAY-18 Retry failed charges     | 8   | 8*  | 1   | 3          | 5.67  | 1        | High       | Stated deadline before the Nov 27 sale            |
| 3    | PAY-20 Split payment form state | 3   | 1   | 5   | 8 (unest.) | 1.13  | 3        | High       | Blocks PAY-12 (tracker relation)                  |
| 4    | PAY-12 Saved-card storage       | 13  | 1   | 1   | 3          | 5.00  | 1        | High       | Milestone goal names saved cards                  |
| 5    | PAY-15 Card brand icons         | 2   | 1   | 1   | 1          | 4.00  | 2        | Low        | Lean: polish on the form; your call               |

* PAY-21 TC: "Full card numbers appear in the charge debug log."
* PAY-18 TC: "Must ship before the Nov 27 sale."
Dependency: PAY-20 moved ahead of PAY-12, which it blocks.

Close calls
- PAY-12 / PAY-15: PAY-15 value 2 → 3 ties them at 5.00, and the smaller
  PAY-15 then ranks first.

Tier breaks
- PAY-18 (1) / PAY-20 (3)
- PAY-20 (3) / PAY-12 (1) — PAY-20 is out of tier order as a dependency.
- PAY-12 (1) / PAY-15 (2)

Group: Log hygiene (inferred, Medium)
Evidence: PAY-30 and PAY-31 both change `logger.ts` and neither has a container.

| Rank | Ticket                      | V   | TC  | RR  | Size | WSJF | Tier | Confidence | Rationale                                    |
| ---- | --------------------------- | --- | --- | --- | ---- | ---- | ---- | ---------- | -------------------------------------------- |
| 1    | PAY-30 Redact tokens in logs | 8   | 1   | 3   | 2    | 6.00 | 1    | Medium     | Same file as PAY-31; goal inferred from both |
| 2    | PAY-31 Structured log format | 5   | 1   | 1   | 3    | 2.33 | 2    | Medium     | Same file as PAY-30; goal inferred from both |

Unranked (Low confidence, your call)
- PAY-40 Dark mode toggle: leans toward Checkout v2; only its own text
  suggests the fit.
```
