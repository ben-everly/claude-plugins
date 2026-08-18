---
name: review-followup
description: Use when working through review feedback systematically — phrasings like "go through the review feedback," "address the PR comments," "let's work through the review," "follow up on those review issues." Triggers on systematic walkthrough of multiple review items, not single-fix requests.
---

# Review Follow-up

## Overview

Walk through review feedback one issue at a time: investigate, present the finding report, implement on the user's signal, confirm satisfaction, then advance.

## Workflow

### 1. Gather the issues

Invoke the `gather-review-issues` skill to locate the review and produce the normalized, numbered issue list (it defines the fields each issue carries). If `gather-review-issues` reports no issues, stop — there is nothing to walk through.

Create a `TaskCreate` task per issue.

### 2. Walkthrough — one issue at a time

For each issue loop the following steps: 1 → 2 → 3 → 4 → next issue, until all are addressed.

#### 1. Investigation

Invoke the `investigate-issue` skill with the issue's `body` as the claim, and its `anchor` (when present) as where that claim points. It runs the investigation and returns the finding report. Carry that report into the next step; don't re-derive or reshape it.

#### 2. Present the current issue

Mark the issue's task `in_progress`, then present the issue as two stitched parts:

1. the issue's title line, exactly as `gather-review-issues` renders it — that skill is the sole authority for it and defines which parts drop when a field is absent;
2. the report `investigate-issue` returned, rendered as `finding-report` defines it.

The two say different things — the title line is where the issue came from, the report's Location line is where the code is — so both render, and neither collapses into the other.

When the report closes with a blocking question instead of directions, there is nothing to pick: wait for the user's answer, then re-invoke `investigate-issue` with the **original claim plus the user's answer** (not the answer alone, so the original context isn't lost) and present the report it returns.

**Then stop and wait. Do not give a menu.** The Recommendation is advice, not a decision. Expect discussion before a fix signal — the user often wants to talk through the directions before picking one. Treat new fix ideas as options to weigh, not directives to code.

#### 3. Implement & confirm

When the user signals which option ("A", "go with B", etc.), invoke the `implement` skill to carry out the chosen fix. A bare "yes" or similar is only a signal when there's a single fix option; otherwise it's ambiguous — if the signal isn't clear, don't proceed; ask the user to clarify.

**A decision to change nothing is terminal whether or not the report lettered it.** A `Not a Problem` renders no Corrective action at all, so there is no letter to name — when the user accepts that verdict, nothing is implemented and you go straight to substep 4. Never ask them to pick an option that was never offered.

**Then stop and wait.** Any clear positive acknowledgment ("next" / "move on" / "lgtm" / "good" / 👍) → advance to substep 4. A change request ("actually, also do X" / "tweak it to Y") → iterate on the same issue.

#### 4. After-fix review action

Only for an issue that arrived somewhere you can post a reply — a review thread or comment you can reach through that source's API or CLI. An issue raised in `chat` has nowhere to post, so there's nothing to act on; just mark the issue's task `completed` and advance.

Test for a postable reply target, not for a field. `link` is optional, so its absence doesn't mean there's no thread — a review-summary comment can yield an issue with no permalink and still be repliable. An `anchor` isn't the signal either: a chat-raised issue can name a `path:line` too. When the issue came from a review and you can't tell where a reply would go, ask rather than skipping.

Draft the reply comment up front and show it:

```text
Fixed in <short commit SHA>. <One-sentence description of the change.>
```

The draft keys off what landed in the code, not off which option the user picked. If no commits this session addressed this issue draft it as "Discussed and decided not to fix because X." Never name a SHA you don't have. Short and factual — no "Thanks for the review!" or performative agreement.

Then ask via `AskUserQuestion` what to do with it:

- **Reply + resolve** (if applicable) — post the comment, mark the thread resolved
- **Reply only** — post the comment, leave the thread open
- **Resolve only** (if applicable) — mark resolved without posting
- **Skip** — do nothing on the review
- **Chat about it** — discuss before deciding

If they pick **Chat about it**, discuss the options, then re-ask this menu once it's settled.

Post the reply in the appropriate place (the thread, or top-level review comment). The user can edit the comment before it's sent.

After the action: mark the issue's task `completed` and start the next issue (back to substep 1).

When every task is `completed`, say "All N issues addressed", where `N` is the number you walked, and stop.

## Common Mistakes

| Mistake                                              | Fix                                                                                                          |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| Auto-advancing after a fix                           | Wait for satisfaction, then do the review action (substep 4). Advance only after it                          |
| Replying or resolving without asking                 | Use `AskUserQuestion` per issue                                                                              |
| Filtering out `Not a Problem` issues silently        | Present anyway with the verdict; user decides                                                                |
| Performative reply ("Thanks for the catch!")         | Factual: "Fixed in `<ref>`. `<summary>`."                                                                    |
| Implementing without first investigating             | Invoke `investigate-issue`, present the report it returns, wait for the signal                               |
| Batching multiple fixes at once                      | One at a time. Each gets its own present → discuss → fix → confirm cycle                                     |
| Drifting into adjacent cleanup                       | Implement only what the current issue requires                                                               |
| Asking the review action for an issue with no thread | Skip the question only when there's nowhere to post — a chat-raised issue. A missing `link` is not the test  |
| Treating a "yes" as go after the user hedged         | Any question or hint of doubt means you lay out the directions and confirm the specific change before coding |
