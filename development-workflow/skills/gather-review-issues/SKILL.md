---
name: gather-review-issues
description: Use when a skill or the user needs to locate a review and turn its feedback into a normalized, numbered issue list — invoked by review-followup and reusable by other skills. Gathers every comment, inline thread, summary body, and chat-raised issue without filtering, and gives each a stable source backlink.
---

# Gather Review Issues

## Overview

Locate the review under discussion, collect every issue from every source, and normalize each into a stable identity — a number, a `<source>` backlink, code locations, the verbatim body, and its origin. The result is the numbered issue list that walkthrough skills (e.g. review-followup) consume.

## Workflow

### 1. Identify the review

Use best judgment from input:

- If the user provides a review reference (PR/MR number, URL, branch), use it
- Check chat history for recent reviews
- Check the current branch's PR/MR for reviews
- If the input is ambiguous, use your best judgment. If you cannot determine what to review, list the user's open reviews and ask

### 2. Gather every issue

Fetch every comment — top-level comments, inline threads, and review-summary bodies — plus any issues raised earlier in this chat. Don't filter by author or location; the goal is to find every issue.

Number issues 1..N. If there are no issues, say "No open review feedback found" (name the sources you checked) and stop.

### 3. Normalize each issue

Give each issue a stable identity with these fields:

- **number** — its `1..N` working order. `k of N` is presentation; the order can shift as issues are added or removed, so it is not part of the identity.
- **source** — the stable backlink to the original review item, so a reference survives re-ordering. Build it as below.
- **code location(s)** — every relevant `path:line` and line range the issue touches, not just the comment's anchor.
- **body** — the verbatim comment body (consumers trim if long).
- **origin** — whether the issue came from the review or only from chat, so consumers know whether an after-fix review action applies.

**Building `<source>`:**

- **Chat:** `chat history #c` — `c` counts chat-raised issues (1st raised in chat = `#1`). Assign the counter in the order issues appear during gathering and keep it fixed, so the backlink stays stable if issues are reordered. → `chat history #1`
- **GitHub / GitLab:** `github - @<user> - <identifier>` (use `gitlab` for MRs). Resolve `<identifier>` in order:
    1. The reviewer's own label, whatever scheme they use (e.g. `#3`, `R2`, `nit-1`). → `github - @alice - #3`
    2. Else a clickable markdown link to the source comment. → `github - @bob - [↗](https://github.com/org/repo/pull/12#discussion_r1234567)`
    3. Else omit it. → `github - @carol`
- **Cross-referenced** (raised in a review _and_ in chat): build the `<source>` from the review item — it's what gets a reply — and append `(also raised in chat)`. → `github - @alice - #2 (also raised in chat)`

## Output

Return the normalized, numbered issue list — each issue carrying number, `source`, code location(s), body, and origin. Consumers create their own tracking state and render titles from these fields.
