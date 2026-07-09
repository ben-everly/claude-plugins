---
name: execute-plan
description: Use when you have a written implementation-plan and want it executed task by task in one pass, each task run by a fresh subagent.
---

# Execute Plan

## Overview

Execute an `implementation-plan` end-to-end in a single pass. Walk the plan's tasks in dependency order and dispatch a fresh subagent per task to run the `implement` skill. This is a thin orchestrator: it coordinates, curates each task's context, and picks each task's model — it delegates all implementation, testing, review, and committing to `implement`, and it does not question or redesign the plan.

## Input

An `/implementation-plan`

## Preconditions

Check both at the start. If either fails, stop and ask the user how to proceed.

1. **Feature branch, clean tree.** The working tree is on a feature branch — not the repository's default branch — and `git status` shows no staged or unstaged changes. This skill _asserts_ the branch as a workspace-isolation guard; it does not create one.
2. **Readable plan.**

## Per-task loop

Create a todo per task (the live progress view). Walk the tasks in the plan's given dependency order. For each task:

1. **Curate the brief** from exactly three sources — never the whole plan:
    - the plan's **Context** section,
    - the task's own slice (its Files / Change / Consumes / Produces / Done when),
    - the **declared** `Produces` — as written in the plan — of the earlier tasks this task lists under `Consumes`.

    v1 forwards _declared_ `Produces`, not the interfaces actually built. Any drift between the two is caught by the consuming task's own review inside `implement`, not here.

2. **Pick the model.** Infer the task's complexity from its brief and dispatch on the cheapest model sufficient for it. Choose the model _explicitly_ so the subagent does not inherit this orchestrator's (expensive) model. Use judgment for the complexity→model mapping rather than a fixed table.
3. **Dispatch a fresh subagent** to run the `/implement` skill on the curated brief. `implement` carries the per-task quality gate internally, so add no second reviewer here.
4. **Confirm success by observing git state** — do not take the subagent's word for it. The task succeeded only if the working tree is clean _and_ `HEAD` has advanced past the commit the task started from. If the subagent reports blocked, the tree is dirty, or `HEAD` did not advance, **stop and ask the user**. Do not auto-retry on a stronger model and do not split the task.
5. **Advance** to the next task.

When the last task completes, report done.
