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

- Review reference (PR/MR number, URL, branch) passed → use it
- "This review" / "the review" / nothing → identify the review for the current branch
- Ambiguous → list the user's open reviews and ask
- Chat-only intent ("the issues you just raised") → use chat history

### 2. Aggregate sources

When a review is in play, gather from all four sources:

| Source                                    | What to fetch                                                                                                       |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Inline review comments + review summaries | Unresolved, non-outdated review threads with their bodies, locations, and thread identifiers; review summary bodies |
| Top-level comments                        | Top-level conversation comments on the review                                                                       |
| Chat history                              | Issues raised earlier in this conversation                                                                          |

Normalize each issue:

```
{ id, source, source_ref, location?, body, author?, thread_ref? }
```

where `source ∈ {inline, review_summary, top_level, chat}` and `thread_ref` is set only for `inline` — an opaque handle the agent's tooling can use to target reply/resolve operations.

Number issues 1..N. Show a summary table to the user (number, source, location, one-line summary) before investigation. Use "—" for the location cell when the source has no location (e.g., `top_level`, `chat`).

**Empty result:** if zero issues, say "No open review feedback found" (mention which sources were checked) and stop.

### 3. Investigation pass (read-only) - one issue at a time

Investigate the current issue (loop: steps 3 → 4 → 5 → 6 → next issue, until all are addressed):

1. Read the referenced code (`location` if present, else grep for symbols/file the comment names).
2. Check the claim against the current code.
3. Check whether a fix would change anything meaningful (real consumer? known broken behavior? security/correctness concern?).
4. Form a verdict: `real-problem` | `not-a-problem` | `unclear-need-input`.
5. Draft 1–3 fix options (even for `not-a-problem`, in case the user disagrees).

### 4. Walkthrough — one issue at a time

Present the current issue in this format:

```
─── Issue k of N ───
Source:    inline review comment by @reviewer at src/foo.ts:42 (also raised in chat)
Comment:   "<verbatim body, trimmed if long>"

Investigation:
  <2-4 sentences: what the code does, whether the claim holds, context affecting the fix>

Verdict: real-problem
  <one sentence reasoning>

Possible directions:
  - <direction A> — <one-line tradeoff>
  - <direction B> — <one-line tradeoff>
  - Skip — <why you might choose not to fix>

These are starting points for discussion, not a menu — let me know your thoughts.
```

For `not-a-problem` issues, lead with the verdict and prominent reasoning. The user can still push back or ask to fix anyway.

For `unclear-need-input` issues, lead with the verdict and replace the "Possible directions" section with **Questions to resolve before fixing** — a list of the specific unknowns blocking a confident verdict (e.g., project conventions, intended behavior, scope of the change). Once the user answers, update the verdict and present real directions in a follow-up turn before waiting for the implement signal.

Create a `TaskCreate` task per issue at the start of the walkthrough. Mark `in_progress` when presented, `completed` when the user signals "move on."

**Then stop and wait.** Expect discussion before a fix signal — the user often wants to talk through the directions before picking one. Treat new fix ideas as options to weigh, not directives to code.

### 5. Implement & confirm

When the user signals which direction to take (e.g., "go with direction A," "do the rename one," or any variant from discussion):

- Implement _only_ the current issue's fix; no adjacent cleanup
- Run targeted verification (test, type check, grep) — not the full suite unless the issue is broad
- Show the diff or short summary; reference files as `path:line`

Then say:

```
Fixed. <one-line summary of the change>
Verified by: <command/check, or "manual review only" if nothing automated applies>

Let me know when you're satisfied with the fix.
```

**Wait for the satisfaction signal** — any clear positive acknowledgment of the fix. If the user pushes back, iterate on the same issue.

**Signal recognition:**

- Satisfied with the fix: "next" / "move on" / "good" / "great" / "lgtm" / "looks good" / "perfect" / "satisfied" / "👍" — anything clearly positive counts
- Wants more changes: "actually, also do X" / "tweak it to Y" / any specific change request

Satisfaction triggers step 6 (the review-action question), not a jump to the next issue. Advance to the next issue only after step 6 completes.

### 6. After-fix review action

After the user signals satisfaction, ask via `AskUserQuestion`:

> "Fix is in. What should I do on the review?"
>
> - **Reply + resolve** — post a brief fix summary on the thread, mark resolved
> - **Reply only** — post the summary; leave the thread open
> - **Resolve only** — mark resolved without a reply
> - **Skip** — do nothing on the review

**Skip the question entirely for `chat`-source issues** (no review thread to act on) and just advance.

**For inline issues (`thread_ref` present):**

- Reply → post a reply on the specific thread (use `thread_ref` to target it)
- Resolve → mark the thread resolved (use `thread_ref` to target it)

**For `review_summary` and `top_level` issues** (no `thread_ref`):

- Reply → post a top-level comment on the review
- Resolve is not applicable — collapse the menu to **Reply** / **Skip**

**Reply body** — drafted by the skill, shown to the user before sending:

```
Fixed in <commit-ish or path:line>. <One-sentence description of the change.>
```

Short and factual. No "Thanks for the review!" or performative agreement. The user can edit before sending.

**If the user chose "Skip" as the fix option** (decided not to fix), still ask the review-action question, but draft the reply body as "Discussed and decided not to fix because X."

After the review action: mark the current issue's task `completed`, present the next issue (back to step 4). When all are done, say "All N issues addressed" and stop.

## Common Mistakes

| Mistake                                       | Fix                                                                              |
| --------------------------------------------- | -------------------------------------------------------------------------------- |
| Auto-advancing after a fix                    | Wait for satisfaction, then do step 6 (review action). Advance only after step 6 |
| Replying or resolving without asking          | Use `AskUserQuestion` per issue                                                  |
| Auto-committing or auto-pushing               | Never commit or push without an explicit user signal                             |
| Filtering out `not-a-problem` issues silently | Present anyway with the verdict; user decides                                    |
| Performative reply ("Thanks for the catch!")  | Factual: "Fixed in `<ref>`. `<summary>`."                                        |
| Implementing without first investigating      | Read code, form a verdict, present, wait for signal                              |
| Batching multiple fixes at once               | One at a time. Each gets its own present → discuss → fix → confirm cycle         |
| Drifting into adjacent cleanup                | Implement only what the current issue requires                                   |
| Asking review action for chat-source issues   | Skip the question entirely for `chat` source — no thread exists to reply to      |
