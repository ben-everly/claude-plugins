---
name: conventional-commits
description: Use when creating git commits or writing commit messages.
---

# Conventional Commits

You follow the [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) specification for all commit messages.

## Message Structure

```
<type>[(optional scope)]: <description>

[optional body]

[optional footer(s)]
```

## Types

Use exactly one of the following types:

| Type | When to use |
|------|-------------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, whitespace (no logic changes) |
| `refactor` | Neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or correcting tests |
| `build` | Build system or external dependencies |
| `ci` | CI configuration |
| `chore` | Other (doesn't modify src or test files) |

## Scope

Parenthesized after the type: `feat(auth): add OAuth2 support`

**Include when:** project has distinct domains/modules/services, monorepo, or bounded contexts (e.g. `auth`, `api`, `billing`)

**Omit when:** small/single-purpose project, broad cross-cutting change, or no established scope convention

## Description

- Use the imperative, present tense: "add" not "added" nor "adds"
- Do not capitalize the first letter
- No period at the end
- Keep it concise — one line, under 72 characters

## Body

- Separated from description by a blank line
- Imperative, present tense — explain **what** and **why**, not how
- Wrap at 72 characters

**Include when:** commit is large, reason isn't obvious, or there are important trade-offs to capture

**Omit when:** description fully captures the change

## Footers

Footers follow the [git trailer format](https://git-scm.com/docs/git-interpret-trailers): `token: value` or `token #value`.

### Breaking Changes

A breaking change MUST be indicated by either:
1. A `!` after the type/scope: `feat(api)!: remove deprecated endpoints`
2. A `BREAKING CHANGE:` footer in the commit body
3. Both, when the footer provides additional detail

Breaking changes can be part of any type.

### Other Footers

- `Refs: #123` — reference related issues
- `Reviewed-by: Name` — reviewer attribution
- `Co-authored-by: Name <email>` — co-author attribution

## Examples

Simple fix (no scope, no body):
```
fix: prevent duplicate form submissions
```

Full example (scope, body, breaking change, footer):
```
feat(api)!: require authentication for all endpoints

All API endpoints now require a valid bearer token. Previously,
read-only endpoints were publicly accessible.

BREAKING CHANGE: unauthenticated requests to read endpoints now
return 401 instead of 200.

Refs: #452
```

## Common Mistakes

- **Capitalized description:** `fix: Resolve timeout` → `fix: resolve timeout` (lowercase first letter of description)
- **Past tense:** `fixed` or `added` → `fix`, `add` (imperative mood)
- **Period at end:** `fix: resolve timeout.` → `fix: resolve timeout`
- **Missing blank line before body:** Body must be separated from description by an empty line
- **Scope on small projects:** Don't force a scope when the project doesn't have distinct domains
- **Vague types:** Using `chore` as a catch-all — pick the most specific type
