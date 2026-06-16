---
name: ticket-branches
description: Use when naming a git branch, choosing which branch to base it on, targeting a pull request, or merging a branch, in a repo that names branches after their ticket/issue id (ticket-first).
---

# Ticket-First Branches

You name branches after their tracker ticket/issue id, with the id leading so
it is the primary, autocompletable key. This matches the "create branch from
issue" style used by GitHub and GitLab. It suits trunk-based development.

## Format

```
<ticket-id>/<description>
```

Examples: `PROJ-123/add-login`, `1234/fix-timeout`.

The ticket id leads and the `/` namespaces it. One ticket can hold several
branches:

```
PROJ-123/api
PROJ-123/ui
```

This gives real folder grouping in branch UIs and lets you list all work on a
ticket — include remote-tracking refs so teammates' branches show up too, not
just your local ones:

```bash
git for-each-ref refs/heads/PROJ-123/ refs/remotes/*/PROJ-123/
```

## Rules

- **Ticket id:** use the id as the tracker emits it — Jira `PROJ-123`,
  GitHub/GitLab issue number `1234` — and only from a trusted tracker, since it
  flows straight into branch names and `git` commands. Match its canonical case:
  git ref namespaces are case-sensitive, so `PROJ-123/...` and `proj-123/...` are
  different namespaces that won't group together.
- **Description:** lowercase, hyphen-separated (kebab-case), alphanumeric and
  hyphens only, short.
- One `/` only — separating the ticket id from the description.

## No ticket?

This convention assumes a tracker. If there is genuinely no ticket, do not
invent a fake id — note that another model (such as the `conventional-branches`
plugin) fits better.

## Where PRs point

All branches open their pull request against `main` (the trunk). If the repo's
default branch is named differently, use that instead — check the repo or rely
on project-specific context.

## Examples

```
PROJ-123/add-csv-export
1234/fix-login-redirect
PROJ-456/api
PROJ-456/ui
```

## Common mistakes

- **Leading with type instead of ticket:** `feature/PROJ-123-add-export` →
  `PROJ-123/add-export` (this plugin is ticket-first)
- **Mangling the tracker key:** `proj123/add-export` → `PROJ-123/add-export`
  (use the tracker's canonical key)
- **Spaces or uppercase in the description:** `PROJ-123/Add Export` →
  `PROJ-123/add-export`
- **Inventing an id when there is no ticket** — use a different branching model
  instead
