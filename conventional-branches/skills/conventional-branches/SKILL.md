---
name: conventional-branches
description: Use when naming a git branch, choosing which branch to base it on, targeting a pull request, or merging a branch, following the Conventional Branch spec (type-first prefixes: feature/, fix/, release/, hotfix/, chore/).
---

# Conventional Branch

You follow the [Conventional Branch](https://conventionalbranch.org/)
specification when naming git branches.

## Format

```
<type>/<description>
```

With an optional ticket/issue id (recommended when you have one):

```
<type>/<ticket-id>-<description>
```

For example, `feature/issue-123-add-login`.

## Types

Use exactly one of the following category prefixes:

| Type                  | When to use                              |
| --------------------- | ---------------------------------------- |
| `feature/` or `feat/` | New feature or capability                |
| `bugfix/` or `fix/`   | Bug fix                                  |
| `hotfix/`             | Urgent fix, typically against production |
| `release/`            | Release preparation                      |
| `chore/`              | Tooling, dependencies, housekeeping      |

The long-lived base branches are `main` and, if the repo uses
one, `develop`. These have no prefix.

## Naming rules

- Lowercase letters (`a-z`), numbers (`0-9`), and hyphens only.
- Hyphen-separated words (kebab-case): `feature/add-login-page`.
- Dots are allowed only in a `release/` branch's version number (e.g.
  `release/2.1.0`).
- No consecutive, leading, or trailing hyphens or dots.
- The only `/` is the one separating the type prefix from the description.

## Where PRs point

All working branches (`feature/`, `bugfix/`, `hotfix/`, `release/`, `chore/`)
open their pull request against `main` (the trunk). If the repo's default branch
is named differently, use that instead — check the repo or rely
on project-specific context. Conventional Branch governs naming, not flow: if the
repo also keeps a long-lived `develop` branch, target whichever branch the team
integrates into (or use the `git-flow` plugin for that model).

## Examples

```
feature/add-oauth-login
bugfix/fix-null-pointer-on-logout
hotfix/patch-payment-timeout
release/2.1.0
chore/bump-dependencies
feature/issue-123-add-csv-export
```

## Common mistakes

- **Uppercase or spaces:** `Feature/Add Login` → `feature/add-login`
- **Wrong separator:** `feature_add_login` → `feature/add-login`
- **Missing type prefix:** `add-login` → `feature/add-login`
- **Extra slashes in the description:** `feature/auth/login` →
  `feature/auth-login`
- **Trailing/double hyphens:** `feature/add--login-` → `feature/add-login`
