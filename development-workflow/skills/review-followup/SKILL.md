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

Fetch every comment — top-level comments, inline threads, and review-summary bodies — plus any issues raised earlier in this chat. Don't filter by author or location; the goal is to find every issue. Note each issue's code location (for investigation) and where it came from (so you can reply later - see step 3, substep 4).

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

#### 2. Present the current issue in this format

```markdown
## Issue k of N

### Source:

inline review comment by @reviewer at src/foo.ts:42 (also raised in chat)

### Background:

<1-3 sentences: the current code the comment refers to, with `path:line` refs; include a short code block only if it aids understanding>

### Comment:

<verbatim body, trimmed if long>

### Investigation:

<2-4 sentences: whether the claim holds against the code, and any context that affects the fix>

### Verdict: <verdict>

<one sentence reasoning>

### Possible directions:

- <direction A> — <one-line tradeoff>
- <direction B> — <one-line tradeoff>
- Skip — <why you might choose not to fix>
```

For `not-a-problem` issues, lead with the verdict and prominent reasoning. The user can still push back or ask to fix anyway.

For `unclear-need-input` issues, lead with the verdict and replace the "Possible directions" section with **Questions to resolve before fixing** — a list of the specific unknowns blocking a confident verdict (e.g., project conventions, intended behavior, scope of the change). Once the user answers, update the verdict and present real directions in a follow-up turn before waiting for the implement signal.

**Then stop and wait. Do not give a menu.** Expect discussion before a fix signal — the user often wants to talk through the directions before picking one. Treat new fix ideas as options to weigh, not directives to code.

#### 3. Implement & confirm

When the user signals which direction to take (e.g., "go with direction A," "do the rename one," or any variant from discussion):

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

| Mistake                                       | Fix                                                                              |
| --------------------------------------------- | -------------------------------------------------------------------------------- |
| Auto-advancing after a fix                    | Wait for satisfaction, then do the review action (substep 4). Advance only after it |
| Replying or resolving without asking          | Use `AskUserQuestion` per issue                                                  |
| Auto-committing or auto-pushing               | Never commit or push without an explicit user signal                             |
| Filtering out `not-a-problem` issues silently | Present anyway with the verdict; user decides                                    |
| Performative reply ("Thanks for the catch!")  | Factual: "Fixed in `<ref>`. `<summary>`."                                        |
| Implementing without first investigating      | Read code, form a verdict, present, wait for signal                              |
| Batching multiple fixes at once               | One at a time. Each gets its own present → discuss → fix → confirm cycle         |
| Drifting into adjacent cleanup                | Implement only what the current issue requires                                   |
| Asking the review action for chat-only issues | Skip the question entirely for chat-only issues — there's no thread to reply to  |
