---
name: finish-branch
description: Use when finishing a completed local branch — pushing it, opening the PR/MR against the right target, and moving the related ticket to review. Runs only when explicitly invoked as /finish-branch.
disable-model-invocation: true
---

# Finish Branch

## Overview

A user-invoked workflow that closes the branch lifecycle: it takes work that is already done and
committed on a local branch and turns it into an open PR/MR against the correct target, with the
related tracker ticket moved to a review state. It composes the `pr-authoring` skill for the PR/MR
body and orchestrates a fixed four-step sequence.

Scope is the transition from "work is done and committed on a local branch" to "a PR/MR is open and
the ticket reflects that." This skill does **not** run tests or any verification (the caller owns
that), clean up branches or worktrees, name branches, manage review feedback, or merge. It never
runs unprompted.

Before starting, check the working tree with `git status`. If it is dirty, ask the user whether to
commit first before continuing.

Work through the four steps in order.

## 1. Resolve the merge target

Determine the branch the PR/MR will target. This is the skill's one hard precondition — proceed only
when the target can be named confidently:

- If the repo documents a branching convention that dictates the target (e.g. in `CONTRIBUTING`/
  `README`, or an established release/hotfix pattern) → follow it.
- Otherwise → target the repo's default branch, as reported by the remote (not an assumption).
- If the current branch *is* the default branch, or the target is otherwise unclear → stop and ask
  the user.

If no target can be resolved, do nothing and notify the user.

## 2. Check for an existing PR/MR

Check whether the branch already has an open PR/MR.

- **One exists** → do not open another. Report it and ask whether the user wants to update it. On
  confirmation, push the branch and re-invoke `pr-authoring` to refresh the body. (This is the
  update path; skip steps 3 and 4.)
- **None exists** → continue to step 3.

## 3. Push and open the PR/MR

Produce the body by invoking the `pr-authoring` skill; do not author it here.

Push the branch and open a **ready (non-draft)** PR/MR against the target resolved in step 1, using
whatever host tooling the repo uses (`gh`, `glab`, etc.) — state the intent to push and open, and
leave the host-specific mechanics to your own judgment.

Never force-push implicitly: if the push is rejected because the branch has diverged from its remote,
stop and ask the user rather than forcing.

Once the PR/MR is open, print its URL.

## 4. Move the tracker ticket (best-effort)

Identify the related ticket — from the branch name or the conversation context — and move it to the
tracker's review state. Keep this generic across trackers; do not bake in tracker-specific logic.

If the ticket (from either source) or its target state cannot be identified confidently, do nothing
and notify the user rather than guessing.
