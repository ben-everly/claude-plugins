---
name: convergent-thinking
description:
    Narrows a set of candidate options down through explicit, stated criteria.
disable-model-invocation: true
---

# Convergent Thinking

## Overview

Your goal is to narrow a set of candidate options down to one — or to an honest
shortlist — through explicit, stated criteria rather than a gut pick.

The value is that the reasoning is inspectable: which criteria mattered, how
each option scored against them, and exactly where a different weighting would
flip the choice. **The recommendation is derived, not chosen.** Every rule below
exists to keep it that way, because the failure this technique guards against is
picking a favorite first and back-filling criteria that make it win.

The only required input is candidate options. Optionally, goals and constraints
can be input too. Both are drawn from the conversation or stated at invocation.

## Normalizing the set

Before any criteria work, make the options comparable:

- **Collapse near-duplicates** by merging or dropping them.
- **Merge composable options.** Candidates are not automatically rivals — where
  several combine into one coherent choice, name the combination and score it as
  a single option rather than pitting its parts against each other.
- **Separate hard constraints from criteria.** A constraint is pass/fail and
  eliminates options outright ("must work offline"); a criterion ranks the
  survivors. Apply constraints first. Letting a must-have enter as a heavily
  weighted criterion is the easiest way to disguise a pick as a calculation.

## Criteria

Criteria are proposed, never invented freely. Draw them in priority order, and
**tag each one with its source** — the provenance is what makes a rigged
criterion visible, and it is not optional:

1. **Stated** — constraints and goals already voiced in the conversation or the
   problem statement. Harvested, not authored. Exhaust these first.
2. **Axes of variance** — the dimensions on which the candidates actually
   differ. A criterion on which every option scores the same carries no signal;
   drop it.
3. **Standard for the domain** — cost, time, reversibility, blast radius, who
   maintains it afterward. Defensible but generic; offer them as proposals and
   challenge them first.
4. **Authored** — anything traceable to neither the problem nor a real
   difference between options. Last resort, and flagged as such.

Weight each criterion high, medium, or low (×3, ×2, ×1). Present the criteria
and weights as an explicitly labeled proposal _before_ scoring, so a wrong set
is visible and cheap to correct — but do not block waiting for approval.
Criteria are frozen once scoring begins; revising them afterward is permitted
only as a stated revision that re-runs the result, never a quiet adjustment.

## Scoring

- **Score column-wise, one criterion at a time**, ranking all options within it
  (1..n, ties allowed) before moving to the next. Never walk a single option
  through every criterion — holistic per-option scoring drags a halo, and an
  option that "feels right" then wins every column.
- **Cite the basis of every score:** found (with its source), stated by the
  user, or bounded estimate.
- **Never guess a point value for an unknown.** Score the range instead — the
  best and worst plausible position that option could hold on that criterion.

The winner is the lowest weighted rank sum. It is arithmetic, not a vote.

## Sensitivity and investigation

Compute the outcome across the bounds of every unknown.

- If the same option wins at **every** combination of extremes, the unknowns
  cannot change the answer. Investigate nothing.
- Otherwise the unknowns the decision hinges on are now identified.
  **Investigate those**, cheapest source first — files and code where they
  exist, the web, available tools, and the user for facts only they hold
  (budget, deadline, org constraints). Exhaust what you can find yourself before
  asking; if questions remain, ask once with all of them batched.
- Re-score and repeat until the result is stable or the remaining unknowns are
  genuinely unresolvable.

Investigation is demand-driven: never research a cell that cannot move the
decision. Keep its depth proportional to what is riding on the outcome — a
low-stakes decision does not earn a research project.

## Checks against a rigged result

- **One option winning every criterion is a smell**, not a clean sweep. It
  usually means the criteria were reverse-engineered from a favorite, or several
  are measuring the same thing. Look for the missing criterion where a different
  option wins.
- **A high weight on an authored criterion that only the winner satisfies** is
  the precise shape of a back-filled justification. Re-check its provenance
  before trusting the result.

## Ending

Close in exactly one of three states:

- **A recommendation** — the winner is stable across the sensitivity check.
- **A shortlist** — a one-step weight change flips the top two. Say so plainly;
  a close call reported as a confident pick is the failure this technique exists
  to prevent.
- **Not ready** — a hinge unknown could not be resolved. Name the specific thing
  to find out and the cheapest way to find it.

Where the derived result disagrees with your own judgment, state that as a
labeled dissent — an argument that a particular criterion is mis-weighted, which
the user can check — never as a silent override of the arithmetic.

## Output

Present the scored table with its weights, provenance tags, and score bases,
followed by the sensitivity result. The rendering is the only latitude; the
provenance and the cited bases are not, since they are what make the decision
inspectable rather than merely confident.

Save nothing. The skill stops at the presented result: it offers no follow-up
step and makes no claim about re-invocation.
