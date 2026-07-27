---
name: implement
description: Use when implementing a single, well-scoped change that has already been decided on.
---

# Implement

## Overview

Carry out one agreed-upon change end-to-end: write it (test-first when possible), verify it, review it, and commit it. The change must already be decided — `implement` executes the change; it does not choose what to do.

Do one change per invocation.

## Workflow

**Before starting**, check the working tree (`git status`). If it isn't clean — any staged or unstaged changes that aren't part of this task — stop and ask the user how to proceed (commit, stash, or explicitly implement on top of the existing changes).

A review-gated loop:

1. **Scope** — implement _only_ the agreed change: no out-of-scope changes or refactors.
2. **TDD whenever possible** — when the change is testable, invoke the `tdd` skill and drive the change test-first. Skip TDD only when there is nothing meaningful to test (a doc, comment, or config tweak) — and say so.
3. **Verify** — run targeted verification (the relevant test, a type check, a grep). Not the full suite unless the change is broad.
4. **Review** — invoke the `inline-review` skill on the diff of the change just made. Read the reported findings and, using your own judgment, apply whichever corrective changes are warranted.
    - If a corrective change was made, go back to step 1 for it (test-first when testable), then re-verify and re-review.
    - If no corrective change was made — whether the review was clean or nothing in it was judged worth fixing — continue.
5. **Commit** — invoke the `/commit` command (which applies the `conventional-commits` skill).
6. **Report** — state the specific commands/checks/tests that were run, or "Changes unverified" if nothing automated applies.
