---
name: commit-steps
description:
  Use when a settled change should be laid out as an ordered list of commits a
  reviewer can read one at a time.
---

# Commit Steps

## Overview

Cut the design settled in the conversation into an ordered list of small
commits, each a step a reviewer can read on its own. This skill does no design
questioning; it cuts what was settled.

## Cutting commits

Each commit is one logical change that leaves the tree green where testable.

- **Two lines or less.** If a commit takes more than one or two lines to
  describe, it is not cut small enough — cut it again.
- **Mechanical changes stand apart.** A rename, move, or reformat gets its own
  commit, separate from the behavior change it enables.
- **Tests travel with their behavior.** A test lands in the same commit as the
  behavior it covers.
- **Green wins.** Pieces that cannot be split without a red tree — say, a
  function's signature and every call site — stay one commit, however many files
  it touches. Never split for size alone at the cost of a red tree.

## Ordering

List commits in dependency order: each depends only on earlier commits — never
forward, never in a cycle.

## Output

```markdown
1. **<imperative title>** — <one or two lines: what this commit does>
```

When a commit relies on an earlier one in a way its lines don't make obvious,
name it in those lines — e.g. "…using the `Config` from 2".

## Boundary

Produce the list and stop — no handoff menu, no naming a downstream skill.
