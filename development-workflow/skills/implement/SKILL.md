---
name: implement
description: Use when implementing a single, well-scoped change that has already been decided on — a bug fix, a feature slice, or a small refactor.
---

# Implement

## Overview

Carry out one agreed-upon change end-to-end: write it (test-first when possible), verify it, review it, and commit it. The change must already be decided — `implement` executes the change; it does not choose what to do.

Do one change per invocation.

## Workflow

**Before starting**, check the working tree (`git status`). If it isn't clean — any staged or unstaged changes that aren't part of this task — stop and ask the user how to proceed (commit, stash, or explicitly implement on top of the existing changes).

A review-gated loop:

1. **Scope** — implement _only_ the agreed change. No adjacent cleanup, no opportunistic refactors.
2. **TDD whenever possible** — when the change is testable, invoke the `tdd` skill and drive the change test-first. Skip TDD only when there is nothing meaningful to test (a doc, comment, or config tweak) — and say so.
3. **Verify** — run targeted verification (the relevant test, a type check, a grep). Not the full suite unless the change is broad.
4. **Review** — invoke the `/code-review` command on the diff.
    - If it surfaces findings that need fixing, go back to step 1 for the corrective change (test-first when testable), then re-verify and re-review.
    - If the review is clean, continue.
5. **Commit** — invoke the `/commit` command (which applies the `conventional-commits` skill).
6. **Report** — state what verified the change: `Verified by: <command/check, or "manual review only" if nothing automated applies>`.
