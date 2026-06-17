---
name: gather-review-issues
description: Use when a user asks to find, collect, or list the feedback from a code review.
---

# Gather Review Issues

## Overview

Locate the review under discussion, collect every issue from every source, and normalize each into a small set of single-purpose fields. The result is the numbered issue list that walkthrough skills (e.g. review-followup) consume.

## Workflow

### 1. Gather every issue

Gather from every available source by default — e.g. the current branch's open PR/MR review(s) and any feedback raised earlier in this chat — narrowing only when the user names a specific source (a PR/MR number, URL, branch, or reviewer). Within that scope, fetch everything: top-level comments, inline threads, and review-summary bodies, plus chat-raised issues. Don't skip anything in scope by author or location; the goal is to find every issue.

If there are no issues, say "No open review feedback found" (name the sources you checked) and stop.

### 2. Normalize each issue

Give each issue these fields, each holding exactly one thing. Omit the optional ones when the source doesn't provide them.

- **number** — its `1..N` position in the list, assigned in gather order. New issues are appended, so a number stays put once assigned — you can use it to refer back to an issue.
- **source** — where the issue came from: `chat`, `github`, or `gitlab`. This is how a consumer tells a chat-only issue from a review one. If an issue was raised in both a review and chat, use the review as its `source` — that's what gets a reply.
- **reviewer** — who raised the issue, stored as the handle you'd use to address them (`@alice`). Optional — omit for chat or when there's no distinct reviewer.
- **identifier** — the source's own label for the item, whatever scheme it uses (`#3`, `R2`, `nit-1`), if one is given. Optional.
- **link** — a clickable markdown link anchored to the original comment, if the source provides one. Optional.
- **anchor** — the `path:line` (or line range) the comment is anchored to, if the source provides one. Optional.
- **body** — the verbatim comment body.
