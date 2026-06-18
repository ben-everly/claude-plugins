---
name: review-followup
description: Use when working through review feedback systematically — phrasings like "go through the review feedback," "address the PR comments," "let's work through the review," "follow up on those review issues." Triggers on systematic walkthrough of multiple review items, not single-fix requests.
---

# Review Follow-up

## Overview

Walk through review feedback one issue at a time: investigate, present with fix options, implement on the user's signal, confirm satisfaction, then advance.

## Workflow

### 1. Gather the issues

Invoke the `gather-review-issues` skill to locate the review and produce the normalized, numbered issue list (it defines the fields each issue carries). If `gather-review-issues` reports no issues, stop — there is nothing to walk through.

Create a `TaskCreate` task per issue.

### 2. Walkthrough — one issue at a time

For each issue loop the following steps: 1 → 2 → 3 → 4 → next issue, until all are addressed.

#### 1. Investigation

Invoke the `investigate-issue` skill with the issue's `body` as the claim and its `anchor` (when present) as the anchor. It runs the investigation and returns the result — `verdict`, `category`, `severity`, a confidence-rated `recommendation`, `fix options`, and `open questions` — and is the authoritative definition of those fields. Carry that result into the next step; don't re-derive it.

#### 2. Present the current issue

Mark the issue's task `in_progress`, then present it. Always present Title and Comment. When there are fix options, present **Fix options and Recommendation**. Always present **Open questions** when there are some. Include the other sections only when they help. Follow this principle:

> _**Brevity principle:** Explain the issue as simply and clearly as you can: include only the sections that help, keep each one short, and drop any that don't add anything._

```markdown
## Issue k of N - <source>

### Background:

<1-3 sentences: the current code the comment refers to. Start from the issue's `anchor`, then list EVERY relevant `path:line` and line range the issue touches — not just that anchor. Include a short code block only if it aids understanding>

### Comment:

<verbatim body, trimmed if long>

### Investigation:

<1-4 sentences: whether the claim holds against the code, and any context that affects the fix>

### Verdict: <verdict>[ · <category> · <severity>]

<one sentence reasoning. Append ` · <category> · <severity>` to the heading only for a Real Problem; drop both otherwise.>

### Fix options:

- **A** — <direction> — <one-line tradeoff>
- **B** — <direction> — <one-line tradeoff>
- **C — Skip** — <why you might choose not to fix>

### Open questions:

- **Q1** — <a question worth resolving; may decide between the directions above>

### Recommendation: <letter, or "answer Q1 first"> (<Low | Medium | High | Very High> confidence)

<one-sentence justification — why this option over the others. When Background is omitted, name the `path:line`(s) here: "currently does X; should do Y.">
```

**Title format** — `## Issue k of N - <source>`. `k of N` is the gather order; new issues append to the end, so an issue's number stays put. `source`, `reviewer`, `identifier`, and `link` all come from `gather-review-issues`; render the title as `k of N - <source>`, then append `reviewer`, `identifier`, and `link` when present and drop whichever are absent. Examples:

- `## Issue 2 of 7 - chat`
- `## Issue 3 of 7 - chat - #2`
- `## Issue 4 of 7 - github - @alice - #3 [↗](https://github.com/org/repo/pull/12#discussion_r1234567)`
- `## Issue 5 of 7 - github - @bob - [↗](https://github.com/org/repo/pull/12#discussion_r1234568)`
- `## Issue 6 of 7 - github - @carol`

**Always present the Fix options section with at least one lettered option, labeling every option with a sequential letter (A, B, C, …), including Skip.** Even an obvious single fix is option A (with Skip as the next letter) — there is no unlabeled "fix it" recommendation. This lets the user refer to a choice by letter ("go with B"). Never present the options as unlabeled prose bullets. Fix options are absent only when a blocking question must be answered before any option can be framed (see below).

For `Not a Problem` issues, the Verdict and its reasoning are the sections that matter most — make sure they're there — and point the Recommendation at **Skip**. The user can still push back or ask to fix anyway.

When the investigation surfaced **open questions**, include the Open questions section and label them `Q1`, `Q2`, …; they can sit alongside the Fix options. If a question blocks the choice between options, point the Recommendation at it ("answer Q1 first") rather than picking blindly. For a `Needs Input` verdict — where no fix options could even be framed — **omit the Recommendation** until the user answers; then invoke `investigate-issue` again with the user's answer, present real fix options, and add the recommendation in a follow-up turn before waiting for the implement signal.

**Then stop and wait. Do not give a menu.** The Recommendation is advice, not a decision. Expect discussion before a fix signal — the user often wants to talk through the directions before picking one. Treat new fix ideas as options to weigh, not directives to code.

#### 3. Implement & confirm

When the user signals which direction to take:

- **If you presented multiple fix options:** a letter or named option — "A," "go with B," "the second one," "do the rename one," or any variant from discussion. A bare "yes" / "sounds good" that names no option is ambiguous — the Recommendation is advice, not a default, so confirm which option before coding.
- **If you presented a single fix option (A plus Skip):** a plain "yes" / "go" / "do it" signals A. But any question, hedge, or sign of uncertainty means you should lay out alternatives and confirm the specific change before coding.

Then:

- Implement _only_ the current issue's fix; no adjacent cleanup
- Run targeted verification (test, type check, grep) — not the full suite unless the issue is broad
- Show the diff or short summary; reference files as `path:line`
- State what verified it: `Verified by: <command/check, or "manual review only" if nothing automated applies>`

**Then stop and wait.** If the user gives any clear positive acknowledgment of the fix, move to the next step. If the user pushes back, iterate on the same issue.

**Signal recognition:**

- Satisfied with the fix: "next" / "move on" / "good" / "great" / "lgtm" / "looks good" / "perfect" / "satisfied" / "👍" — anything clearly positive counts
- Wants more changes: "actually, also do X" / "tweak it to Y" / any specific change request

#### 4. After-fix review action

Only for issues that came from a review (`source` is not `chat`). For chat-only issues there's nothing to act on — just advance.

Draft the reply comment up front and show it:

```text
Fixed in <commit-ish or path:line>. <One-sentence description of the change.>
```

(If the user chose not to fix, draft it as "Discussed and decided not to fix because X.") Short and factual — no "Thanks for the review!" or performative agreement.

Then ask via `AskUserQuestion` what to do with it:

- **Reply + resolve** (if applicable) — post the comment, mark the thread resolved
- **Reply only** — post the comment, leave the thread open
- **Resolve only** (if applicable) — mark resolved without posting
- **Skip** — do nothing on the review
- **Chat about it** — discuss before deciding

If they pick **Chat about it**, discuss the options, then re-ask this menu once it's settled.

Post the reply in the appropriate place (the thread, or top-level review comment). The user can edit the comment before it's sent.

After the action: mark the issue's task `completed` and start the next issue (back to substep 1). When all are done, say "All N issues addressed" and stop.

## Common Mistakes

| Mistake                                                       | Fix                                                                                                                                           |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Auto-advancing after a fix                                    | Wait for satisfaction, then do the review action (substep 4). Advance only after it                                                           |
| Replying or resolving without asking                          | Use `AskUserQuestion` per issue                                                                                                               |
| Auto-committing or auto-pushing                               | Never commit or push without an explicit user signal                                                                                          |
| Filtering out `Not a Problem` issues silently                 | Present anyway with the verdict; user decides                                                                                                 |
| Performative reply ("Thanks for the catch!")                  | Factual: "Fixed in `<ref>`. `<summary>`."                                                                                                     |
| Implementing without first investigating                      | Read code, form a verdict, present, wait for signal                                                                                           |
| Batching multiple fixes at once                               | One at a time. Each gets its own present → discuss → fix → confirm cycle                                                                      |
| Drifting into adjacent cleanup                                | Implement only what the current issue requires                                                                                                |
| Asking the review action for chat-only issues                 | Skip the question entirely for chat-only issues — there's no thread to reply to                                                               |
| Padding an obvious fix with sections it doesn't need          | Drop Background/Investigation/Verdict for an obvious fix; keep the lettered directions (at least A) and Recommendation                        |
| Stripping sections an issue with a real tradeoff needs        | Include the directions and reasoning whenever there's a genuine alternative to weigh                                                          |
| Treating a "yes" as go after the user hedged                  | Any question or hint of doubt means you lay out the directions and confirm the specific change before coding                                  |
| Dropping relevant line numbers from Background                | Background must list every relevant `path:line` the issue touches, not just the comment's anchor                                              |
| Treating fix options and open questions as mutually exclusive | They can coexist; a blocking question can defer the recommendation to it ("answer Q1 first")                                                  |
| Recommending without confidence or justification              | Every recommendation names a letter (or "answer Q1 first") with `Low`/`Medium`/`High`/`Very High` confidence and a one-sentence justification |
