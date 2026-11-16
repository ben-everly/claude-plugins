---
name: review-followup
description:
  Use when working through review feedback systematically — phrasings like "go
  through the review feedback," "address the PR comments," "let's work through
  the review," "follow up on those review issues." Triggers on systematic
  walkthrough of multiple review items, not single-fix requests.
---

# Review Follow-up

## Overview

Launch every issue's investigation up front, then walk through review feedback
one issue at a time: present the finding report, implement on the user's signal,
confirm satisfaction, then advance. Replies to the review go out together once
every issue is done.

## Workflow

### 1. Gather the issues

Invoke the `gather-review-issues` skill to locate the review and produce the
normalized, numbered issue list (it defines the fields each issue carries). If
`gather-review-issues` reports no issues, stop — there is nothing to walk
through.

Track each issue as a task — with the session's task-tracking tool if it has
one, otherwise as a status on the numbered issue list.

### 2. Investigate every issue

Record `HEAD` as the launch commit, then invoke the `investigate-issue` skill on
every issue, without waiting for one report before starting the next. Reports
that arrive early are held until their issue comes up.

### 3. Walkthrough — one issue at a time

For each issue loop the following steps: 1 → 2 → 3 → next issue, until all are
addressed.

#### 1. Check the report

Use this issue's report from the launch, waiting for it if it has not arrived.

Earlier fixes may have changed what the report rests on. Run
`git diff <launch commit> HEAD` over the files the report cites. If nothing in
the diff changes something the verdict rests on, present the report as-is;
otherwise re-investigate by invoking `investigate-issue` for this issue and
present the new report.

Carry the report into the next step; don't re-derive or reshape it.

#### 2. Present the current issue

Mark the issue's task `in_progress`, then present `## Issue k of N` — the
issue's `number` and the size of the list — followed by the report from substep
1, rendered as `finding-report` defines it.

When the report closes with a blocking question instead of directions, there is
nothing to pick: wait for the user's answer, then re-invoke `investigate-issue`
with the **original claim plus the user's answer** (not the answer alone, so the
original context isn't lost) and present the report it returns.

**Then stop and wait. Do not give a menu.** The Recommendation is advice, not a
decision. Expect discussion before a fix signal — the user often wants to talk
through the directions before picking one. Treat new fix ideas as options to
weigh, not directives to code.

#### 3. Implement & confirm

When the user signals which option ("A", "go with B", etc.), invoke the
`implement` skill to carry out the chosen fix. A bare "yes" or similar is only a
signal when there's a single fix option; otherwise it's ambiguous — if the
signal isn't clear, don't proceed; ask the user to clarify.

**A decision to change nothing is terminal whether or not the report lettered
it.** A `Not a Problem` renders no Corrective action at all, so there is no
letter to name — when the user accepts that verdict, nothing is implemented and
the issue is done. Never ask them to pick an option that was never offered.

**Then stop and wait.** Any clear positive acknowledgment ("next" / "move on" /
"lgtm" / "good" / 👍) → mark the issue's task `completed` and start the next
issue (back to substep 1). A change request ("actually, also do X" / "tweak it
to Y") → iterate on the same issue.

### 4. Reply to the review

When every task is `completed`, say "All N issues addressed", where `N` is the
number you walked, then invoke the `reply-to-review` skill.

## Common Mistakes

| Mistake                                       | Fix                                                                                                          |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| Auto-advancing after a fix                    | Wait for satisfaction; advance only after it                                                                 |
| Filtering out `Not a Problem` issues silently | Present anyway with the verdict; user decides                                                                |
| Implementing without first investigating      | Present the issue's report, wait for the signal                                                              |
| Batching multiple fixes at once               | One at a time. Each gets its own present → discuss → fix → confirm cycle                                     |
| Drifting into adjacent cleanup                | Implement only what the current issue requires                                                               |
| Treating a "yes" as go after the user hedged  | Any question or hint of doubt means you lay out the directions and confirm the specific change before coding |
