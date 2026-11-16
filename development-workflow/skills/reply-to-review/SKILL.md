---
name: reply-to-review
description:
  Use when review feedback has been addressed and the review needs replies.
---

# Reply to Review

## Overview

Draft a reply for every addressed review issue in one batch, let the user edit
and decide each one, then post them. A reply for a fix cites a commit the
reviewer can open, so nothing is drafted until the branch is pushed.

## Workflow

### 1. Check the branch is pushed

The branch is pushed when all of these hold:

- `git status --porcelain --untracked-files=no` prints nothing
- the branch has an upstream
- `git rev-list @{u}..HEAD` prints nothing

If any fails, tell the user to push first, and stop. Untracked files don't
count: they are never part of a commit a reply could cite.

### 2. Collect the addressed issues

Take the issues addressed in this conversation, with what was decided for each:
the commits that fixed it, or the reason it was left alone. If no issue list
exists yet, invoke `gather-review-issues` for one. If an issue's outcome isn't
clear from the conversation, ask.

Find each fix's commit in the pushed history (`git log @{u}`), not from a SHA
noted earlier: pushing can squash fixups and rewrite SHAs.

### 3. Group by reply target

An issue has a reply target when it arrived somewhere you can post a reply — a
review thread or comment you can reach through that source's API or CLI. A
`chat` issue has none; draft nothing for it. Neither a missing `link` nor a
present `anchor` decides it: a review-summary comment can yield an issue without
a permalink, and a chat issue can name a `path:line`. When an issue came from a
review and you can't tell where a reply would go, ask.

Issues that share a `link` share a target — usually several points from one
review's summary comment. They get one reply, with one entry per issue.

### 4. Draft every reply

Each reply states what was decided: the fix, or why the code stays as it is.

```text
Fixed in <short SHA>. <One-sentence description of the change.>
```

```text
Discussed and decided not to fix because <reason>.
```

Name every commit that fixed it (`Fixed in <sha1>, <sha2>.`). An issue that was
partly fixed and partly declined gets both sentences. Name only SHAs from
step 2. A shared target's reply is a list, each entry naming the point it
answers by its `identifier` or a few words of the comment:

```text
- <point>: Fixed in <short SHA>. <One-sentence description of the change.>
- <point>: Discussed and decided not to fix because <reason>.
```

Keep replies short and factual, with no thanks or praise for the reviewer.

### 5. Decide each reply

Show every draft at once, each under its issue number and target. Then ask, with
one `AskUserQuestion` per draft, what to do with it:

- **Reply + resolve** — post it and mark the thread resolved
- **Reply only** — post it and leave the thread open
- **Resolve only** — mark the thread resolved without posting
- **Skip** — do nothing

Offer the resolve options only for a target that can be resolved; a top-level
comment gets **Reply** and **Skip**. The user can edit a draft or talk it
through in their answer; settle that, then re-ask for that draft.

Post nothing until every draft has a decision, so any draft can still change.

### 6. Post

Carry out every decision: replies to an inline comment go in its thread, others
as a top-level comment on the review. Then report what was posted and resolved,
with links.
