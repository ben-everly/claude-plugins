---
name: execute-plan
description: Use when you have a written implementation-plan-format plan and want it executed task by task in one pass, each task run by a fresh subagent.
---

# Execute Plan

## Overview

Execute an `implementation-plan`-format plan end-to-end in a single pass. Walk the plan's tasks in dependency order and dispatch a fresh subagent per task to run the `implement` skill. This is a thin orchestrator: it coordinates, curates each task's context, and picks each task's model — it delegates all implementation, testing, review, and committing to `implement`, and it does not question or redesign the plan.

v1 is single-pass. Nothing is persisted; the run's state lives in this context for its duration. An interruption is the user's to resolve (see **Interruptions**).

## Input

A path to an `implementation-plan`-format plan (Overview / Context / Tasks, each task with Files / Change / Consumes / Produces / Done when).

## Preconditions

Check both at the start. If either fails, stop and ask the user how to proceed.

1. **Feature branch, clean tree.** The working tree is on a feature branch — not the repository's default branch — and `git status` shows no staged or unstaged changes. This skill *asserts* the branch as a workspace-isolation guard; it does not create one.
2. **Readable plan.** The given path resolves to a readable file.

## Per-task loop

Create a todo per task (the live progress view). Walk the tasks in the plan's given dependency order. For each task:

1. **Curate the brief** from exactly three sources — never the whole plan:
   - the plan's **Context** section,
   - the task's own slice (its Files / Change / Consumes / Produces / Done when),
   - the **declared** `Produces` — as written in the plan — of the earlier tasks this task lists under `Consumes`.

   v1 forwards *declared* `Produces`, not the interfaces actually built. Any drift between the two is caught by the consuming task's own review inside `implement`, not here.
2. **Pick the model.** Infer the task's complexity from its brief and dispatch on the cheapest model sufficient for it. Choose the model *explicitly* so the subagent does not inherit this orchestrator's (expensive) model. Use judgment for the complexity→model mapping rather than a fixed table.
3. **Dispatch a fresh subagent** to run the `implement` skill on the curated brief. `implement` carries the per-task quality gate internally (TDD → verify → `/code-review low` → commit), so add no second reviewer here.
4. **Confirm success by observing git state** — do not take the subagent's word for it. The task succeeded only if the working tree is clean *and* `HEAD` has advanced past the commit the task started from. If the subagent reports blocked, the tree is dirty, or `HEAD` did not advance, **stop and ask the user**. Do not auto-retry on a stronger model and do not split the task.
5. **Advance** to the next task.

When the last task completes, report done.

## Interruptions

Because v1 persists no state, an interruption (context loss, abort, a stop-and-ask that ends the session) is the user's to resolve: already-committed tasks stand, the interrupted task's partial work is left in the tree, and the user settles the branch and re-runs the remaining tasks.
