---
name: estimate
description:
  Use when a ticket, issue, or described change needs an estimate or size.
argument-hint: "[ticket id, URL, or description] [scheme]"
---

# Estimate

## Overview

Size one piece of work so the same work gets the same size on every run, and
show the reasoning that produced it. Consistency comes from three fixed things:
the rubric below, one calibration file, and evidence behind every adjustment.

The calibration is the only comparison set. Size from the work, the codebase,
and the calibration alone.

## Input

Arguments are the work to estimate, optionally followed by a scheme:

- **work** (required) — a ticket id or URL, or the change described in text.
  With no arguments, it is the work under discussion. With none under
  discussion, ask for it before starting.
- **scheme** (optional) — a scheme and its range, such as `T-shirt, XS–XL` or
  `Fibonacci, 1–13`, or up to seven comma-separated values. When omitted, the
  default in [Schemes](#schemes) applies.

Stop and ask when an argument is invalid:

- A ticket that cannot be read: ask for its text.
- An unknown scheme, a range whose ends are not in one column of the Schemes
  table, or a custom list of more than seven values: name the valid schemes.

## Steps

### 1. Load the calibration

Use exactly one calibration, the first of these that exists:

1. A file named by the user or the project instructions.
2. `.claude/estimation.md` in the repository.
3. `references/calibration.md`, bundled with this skill.

A user file replaces the bundled one whole. Where it omits a section, that
section is absent, not filled from the bundled file.

The calibration supplies the default scheme, the points for each adjustment
tier, and example work for each size and tier.

**Done when** one calibration is loaded and you can name its source.

### 2. Read the codebase

Locate the code the work touches: enough to name files, count call sites, and
see the test coverage in the area. Stop before designing the implementation.

**Done when** every claim you make in steps 3 and 4 can cite a file, a count, or
a line of the work.

### 3. Size the base

The base is the scope of the work as written plus its gaps.

A **gap** is work the change needs that the work does not mention. Check each:
tests; data migration or backfill; permissions; error, empty, and loading
states; docs and user-facing text; config, deploy, and feature flags; logging
and monitoring; backward compatibility.

Each concern counts once: as a gap when the change needs it however things turn
out, or as an adjustment when it may or may not happen.

Pick the level whose definition fits, counting the files and modules the gaps
add. A **module** is the codebase's own unit of grouping: a package, plugin,
service, or top-level directory. The definitions hold for any kind of change,
code or prose.

| Points | Base scope                                                                                 |
| ------ | ------------------------------------------------------------------------------------------ |
| 1      | Edits existing content (a value, a message, a sentence) and adds no behavior.              |
| 2      | Adds or changes behavior within one file and its tests, following a pattern already there. |
| 3      | Changes several files in one module, or adds one component modeled on an existing one.     |
| 5      | Changes several modules, or adds a pattern or mechanism other work will build on.          |
| 8      | Changes most modules, or adds a new subsystem.                                             |

Confirm the level against the calibration's examples for it and its neighbors.
When the work fits two levels, take the larger. Record any close call between
neighboring levels as a boundary call in the output.

**Done when** every gap category is checked and the base has a level.

### 4. Score the adjustments

A **risk** is known work that may cost more than it looks. Check each: heavy
coupling; an existing behavior that other code depends on, altered with no test
that would catch a regression; an external dependency or integration; a change
to production data; concurrency or performance sensitivity; security-sensitive
code; technology the codebase does not use yet. Score any other risk the same
way, as an `other risk`, when the code or the work evidences it.

An **unknown** is an open question whose answer changes the scope. Check each
thing the work says to change against the code: where the code doesn't match the
work's description, the mismatch is an unknown.

Score each risk and unknown into one tier, then take that tier's points from the
calibration:

| Tier      | Test                                                                  |
| --------- | --------------------------------------------------------------------- |
| none      | Conceivable, with no evidence in the code or the work.                |
| contained | Evidenced, and at its worst the extra work fits the planned approach. |
| rework    | Evidenced, and at its worst it forces rework or a different approach. |

Evidence is a file, a count, or a line of the work.

**Done when** every risk category is checked and every open question in the work
is scored.

### 5. Total and map

Add the adjustment points to the base, then round the total to the nearest
rank's points. A total exactly halfway between two ranks rounds down. Past rank
7 the points continue 34, 55.

The result is **unsizable** when either rule holds. Report each one that does:

- **Too uncertain** — the adjustments total more than the base points. Name the
  spike that would answer the unknowns, or list the open questions.
- **Too big** — the total rounds to a rank above the scheme's range. Recommend
  splitting the work.

Otherwise, read the size from the rounded rank. A total that rounds below the
range takes its bottom rank.

## Schemes

| Rank | Points | T-shirt | Fibonacci | Powers of 2 | Linear |
| ---- | ------ | ------- | --------- | ----------- | ------ |
| 1    | 1      | XS      | 1         | 1           | 1      |
| 2    | 2      | S       | 2         | 2           | 2      |
| 3    | 3      | M       | 3         | 4           | 3      |
| 4    | 5      | L       | 5         | 8           | 4      |
| 5    | 8      | XL      | 8         | 16          | 5      |
| 6    | 13     | XXL     | 13        | 32          | 6      |
| 7    | 21     | XXXL    | 21        | 64          | 7      |

A scheme is a column and a range within it, such as `T-shirt, XS–XL`. Only the
ranks inside the range are ever reported. A custom scheme is an ordered list of
up to seven values, read as ranks 1 onward.

The scheme comes from the input, else the calibration, else `T-shirt, XS–XL`.

## Output

Report these parts, in order. Every size in the output, including the base and
each _Would change the size_ entry, uses the chosen scheme.

1. **Size** — the size and its points, or `Unsizable` with every reason that
   holds.
2. **Calibration** — its source.
3. **Base** — its level, the scope it covers with the files it touches, each gap
   counted with its evidence, and any boundary call: the two levels and why the
   work landed where it did.
4. **Adjustments** — one line per scored risk or unknown: points, type (`risk`,
   `other risk`, or `unknown`), tier, what it is, its evidence, and its worst
   case. List a `none` item only when the work or the codebase raised it.
5. **Total** — the arithmetic, the rounding, and the mapped size.
6. **Would change the size** — each item whose resolution moves the size to
   another rank, as `<condition> → <size>`. Omit the section when nothing would.

When unsizable, the total line states each failed rule, and a **Next step**
replaces _Would change the size_.

```
Size: L (5 pts)
Calibration: references/calibration.md (bundled)

Base: M (3)
- Rename the `editor` role to `contributor` in the role enum and policy checks
  (`src/auth/roles.ts`, `src/auth/policies/`).
- Gaps counted: backfill of stored role values (`users.role` column); tests
  for the renamed policy checks.
- Boundary: S or M. The rename follows the existing enum, but with the gaps
  it changes several files in one module, so M.

Adjustments
+1 risk (contained): heavy coupling. `Role.Editor` is referenced at 14 call
  sites (grep); a missed one fails a permission check and is fixed in place.
+2 unknown (rework): the work doesn't say whether API clients may still send
  `editor`. If they may, the API needs a versioned alias and a deprecation
  window instead of a straight rename.
+0 risk (none): downtime during the backfill. The table holds ~2k rows
  (`migrations/0042_users.sql`); nothing points to a slow migration.

Total: 3 + 3 = 6, nearest 5 → L

Would change the size
- API clients never send `editor` → M (3)
```
