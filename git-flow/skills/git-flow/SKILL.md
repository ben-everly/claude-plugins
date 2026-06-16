---
name: git-flow
description: Use when naming a git branch, choosing which branch to base it on, targeting a pull request, or merging a branch in a repo that follows the git-flow CLI / Atlassian branching model.
---

# Git Flow

You follow the git flow branching model as implemented by the git-flow CLI and
documented by Atlassian: two long-lived branches plus short-lived supporting
branches (feature, bugfix, release, hotfix) that base off and merge back to
specific branches.

## Branches

Assume the two long-lived branches are `main` (production) and `develop`
(integration). If the repo uses different branches use those names instead
— check the repo or rely on project-specific context. If you can't determine
the branch names, ask the user.

## Branch types, base, and PR target

| Branch      | Base off  | PR into   | Also merge back to |
| ----------- | --------- | --------- | ------------------ |
| `feature/*` | `develop` | `develop` | —                  |
| `bugfix/*`  | `develop` | `develop` | —                  |
| `release/*` | `develop` | `main`    | `develop`          |
| `hotfix/*`  | `main`    | `main`    | `develop`          |

`release/*` and `hotfix/*` must land in **both** `main` and `develop`, so the
work ships to production and isn't lost from the next release line. A pull
request targets one branch, so finish them in order:

1. Merge the branch into `main` (via PR).
2. Tag `main` with the release version (e.g. `2.1.0`).
3. Merge `main` into `develop` (a second PR or a local `git merge`) so the two
   branches don't diverge. Resolve any conflicts keeping both sides — a hotfix
   back-merge resolved wrong silently reintroduces the bug it fixed.

## Naming

```
<type>/<description>
```

Lowercase, hyphen-separated (kebab-case). Release branches are commonly named
for their version: `release/2.1.0`.

## Examples

```
feature/add-oauth-login      # base develop, PR into develop
bugfix/fix-cart-total        # base develop, PR into develop
release/2.1.0                # base develop, PR into main, merge back to develop
hotfix/patch-payment-timeout # base main, PR into main, merge back to develop
```

## Common mistakes

- **Basing a feature off main:** features base off `develop`, not the production
  branch.
- **Pointing a release/hotfix PR only at one branch:** they must land in both
  `main` and `develop`.
- **Using git flow without a `develop` branch** — confirm it exists first.
