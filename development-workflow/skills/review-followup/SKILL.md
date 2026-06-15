---
name: review-followup
description: Use when working through review feedback systematically — phrasings like "go through the review feedback," "address the PR comments," "let's work through the review," "follow up on those review issues." Triggers on systematic walkthrough of multiple review items, not single-fix requests.
---

# Review Follow-up

## Overview

Walk through review feedback one issue at a time: investigate, present with fix options, implement on the user's signal, confirm satisfaction, then advance.

## Workflow

### 1. Identify the review

Use best judgment from input:

- If the user provides a review reference (PR/MR number, URL, branch), use it
- Check chat history for recent reviews
- Check the current branch's PR/MR for reviews
- If the input is ambiguous, use your best judgment. If you cannot determine what to review, list the user's open reviews and ask

### 2. Gather issues

Fetch every comment — top-level comments, inline threads, and review-summary bodies — plus any issues raised earlier in this chat. Don't filter by author or location; the goal is to find every issue. Note each issue's code location (for investigation) and where it came from — the source becomes the issue title (substep 2) and lets you reply later (substep 4). For chat-raised issues, assign the `chat history #c` counter (substep 2) in the order they appear here and keep it fixed, so the backlink stays stable if issues are reordered.

Number issues 1..N. If there are no issues, say "No open review feedback found" (name the sources you checked) and stop.

Create a `TaskCreate` task per issue. Mark `in_progress` when presented, `completed` after the review action. See step 3, substeps 2 and 4.

### 3. Walkthrough — one issue at a time

For each issue loop the following steps: 1 → 2 → 3 → 4 → next issue, until all are addressed.

#### 1. Investigation

1. Read the referenced code.
2. Check the claim against the current code.
3. Check whether a fix would change anything meaningful (real consumer? known broken behavior? security/correctness concern?).
4. Form a verdict: `real-problem` | `not-a-problem` | `unclear-need-input`.
5. Draft 1–3 fix options (even for `not-a-problem`, in case the user disagrees).
6. Pick a recommended option and rate your confidence — `medium` | `high` | `very high` — with a one-sentence justification. Confidence measures whether the recommended direction is the right call for this issue, not merely that some fix is correct: `very high` means it's the only change the user could reasonably want; `medium` is the floor — proceed, but look closely, this is one you'd want the user's eyes on. There is no tier below `medium`: if you can't reach it, change the verdict to `unclear-need-input`, discard the directions you drafted in step 5, and present **Questions to resolve before fixing** instead (substep 2) — gather input rather than guessing.
7. Decide which sections substep 2 needs: always Title, Comment, and Recommendation; add Background, Investigation, Verdict, and Possible directions only when they help explain the issue (see the brevity principle in substep 2).

#### 2. Present the current issue

Always present Title, Comment, and Recommendation; include the other sections only when they help. Follow this principle:

> _**Brevity principle:** Explain the issue as simply and clearly as you can: include only the sections that help, keep each one short, and drop any that don't add anything. Title, Comment, and Recommendation are the only constants._

```markdown
## Issue k of N - <source>

### Background:

<1-3 sentences: the current code the comment refers to. List EVERY relevant `path:line` and line range the issue touches — not just the comment's anchor. Include a short code block only if it aids understanding>

### Comment:

<verbatim body, trimmed if long>

### Investigation:

<2-4 sentences: whether the claim holds against the code, and any context that affects the fix>

### Verdict: <verdict>

<one sentence reasoning>

### Possible directions:

- **A** — <direction> — <one-line tradeoff>
- **B** — <direction> — <one-line tradeoff>
- **C — Skip** — <why you might choose not to fix>

### Recommendation: <letter, or "fix it" when no directions are listed> (<medium | high | very high> confidence)

<one-sentence justification — why this option over the others; or, when no directions are listed, the evidence that makes this the only sensible change. When Background is omitted, name the `path:line`(s) here: "currently does X; should do Y.">
```

**Title format** — `## Issue k of N - <source>`. `k of N` is the working order and can shift as issues are added or removed. The trailing `<source>` label is a **stable backlink** to the original review item, so a reference survives re-ordering. Build `<source>` like this:

- **Chat:** `chat history #c` — `c` counts chat-raised issues (1st raised in chat = `#1`). → `## Issue 2 of 7 - chat history #1`
- **GitHub / GitLab:** `github - @<user> - <identifier>` (use `gitlab` for MRs). Resolve `<identifier>` in order:
    1. The reviewer's own label, whatever scheme they use (e.g. `#3`, `R2`, `nit-1`). → `## Issue 4 of 7 - github - @alice - #3`
    2. Else a clickable markdown link to the source comment. → `## Issue 5 of 7 - github - @bob - [↗](https://github.com/org/repo/pull/12#discussion_r1234567)`
    3. Else omit it. → `## Issue 6 of 7 - github - @carol`
- **Cross-referenced** (raised in a review _and_ in chat): title by the review source — it's what gets a reply — and append `(also raised in chat)`. → `## Issue 3 of 7 - github - @alice - #2 (also raised in chat)`

**Whenever you include the Possible directions section, label every option with a sequential letter (A, B, C, …), including Skip.** This lets the user refer to a choice by letter ("go with B," "take the second one"). Never present the directions as unlabeled prose bullets. (When you omit Possible directions and recommend "fix it," there are no options to label.)

For `not-a-problem` issues, lead with the verdict and prominent reasoning, and point the Recommendation at **Skip**. The user can still push back or ask to fix anyway.

For `unclear-need-input` issues, lead with the verdict and replace the "Possible directions" section with **Questions to resolve before fixing** — a list of the specific unknowns blocking a confident verdict (e.g., project conventions, intended behavior, scope of the change). **Omit the Recommendation** until the user answers; then update the verdict, present real directions, and add the recommendation in a follow-up turn (re-applying the step 6 confidence check) before waiting for the implement signal.

**Then stop and wait. Do not give a menu.** The Recommendation is advice, not a decision. Expect discussion before a fix signal — the user often wants to talk through the directions before picking one. Treat new fix ideas as options to weigh, not directives to code.

#### 3. Implement & confirm

When the user signals which direction to take:

- **If you presented directions:** a letter or named direction — "A," "go with B," "the second one," "do the rename one," or any variant from discussion. A bare "yes" / "sounds good" that names no option is ambiguous — the Recommendation is advice, not a default, so confirm which direction before coding.
- **If you presented one sensible fix (no directions):** there's no letter — a plain "yes" / "go" / "do it" is the signal. But any question, hedge, or sign of uncertainty means you should lay out the directions and confirm the specific change before coding.

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

Only for issues that came from the review. For issues raised only in chat there's nothing to act on — just advance.

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

| Mistake                                          | Fix                                                                                                                            |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| Auto-advancing after a fix                       | Wait for satisfaction, then do the review action (substep 4). Advance only after it                                            |
| Replying or resolving without asking             | Use `AskUserQuestion` per issue                                                                                                |
| Auto-committing or auto-pushing                  | Never commit or push without an explicit user signal                                                                           |
| Filtering out `not-a-problem` issues silently    | Present anyway with the verdict; user decides                                                                                  |
| Performative reply ("Thanks for the catch!")     | Factual: "Fixed in `<ref>`. `<summary>`."                                                                                      |
| Implementing without first investigating         | Read code, form a verdict, present, wait for signal                                                                            |
| Batching multiple fixes at once                  | One at a time. Each gets its own present → discuss → fix → confirm cycle                                                       |
| Drifting into adjacent cleanup                   | Implement only what the current issue requires                                                                                 |
| Asking the review action for chat-only issues    | Skip the question entirely for chat-only issues — there's no thread to reply to                                                |
| Padding an obvious fix with sections it doesn't need | Drop Background/Investigation/Verdict/Directions for an obvious fix; present just Title + Comment + Recommendation                  |
| Stripping sections an issue with a real tradeoff needs | Include the directions and reasoning whenever there's a genuine alternative to weigh                                       |
| Treating a "yes" as go after the user hedged     | Any question or hint of doubt means you lay out the directions and confirm the specific change before coding                   |
| Dropping relevant line numbers from Background   | Background must list every relevant `path:line` the issue touches, not just the comment's anchor                               |
| Recommending without confidence or justification | Every recommendation names a letter (or "fix it") with `medium`/`high`/`very high` confidence and a one-sentence justification |
