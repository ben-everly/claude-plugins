---
name: pr-authoring
description: Use when writing or drafting a GitHub pull request's body.
---

# PR Body Authoring

Author a PR's **body** as markdown while honoring the repo's conventions.

## Ground the body in the actual changes

Author from the real changeset — the diff and the commits against the PR's base — not from memory or the branch name. The Summary must describe changes you've read, and "Breaking changes: None" is a claim about a diff you've seen, not a guess.

## Body — structure precedence

Resolve the body's structure from the first source that prescribes a body structure:

1. **Session context.** An explicit instruction, or PR-structure guidance already present in context.
2. **Repo-documented structure**, two kinds that usually compose:
    - a `PULL_REQUEST_TEMPLATE.md` (case-insensitive) in the repo root, `.github/`, or `docs/`, or a `PULL_REQUEST_TEMPLATE/` directory under any of those;
    - a structure prescribed in `README.md`/`CONTRIBUTING.md` prose, which stands in as the template when no template file exists.

    Honor the template's structure and layer prose rules on top. Ask the user only on a genuine structural conflict, or when a `PULL_REQUEST_TEMPLATE/` directory offers several templates.

3. **Fallback section set** (below).

Follow any content rules in `README.md`/`CONTRIBUTING.md` (e.g. "always link the issue") regardless of where structure comes from.

**Filling a template:** read its HTML comments for intent (e.g. "delete if not applicable") before removing them, then fill each section with real content — no placeholders, no leftover comments. Extend it only to add something material (a breaking change, a migration step), in a marked block after the maintainers' sections, never interleaved.

## Body — fallback section set

When no structure is documented, emit these. **Summary** and **Breaking changes** always render; the rest render only when triggered, so the body isn't padded with empty headers.

| Section                       | Renders when                                     | Good content                                                                         |
| ----------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------ |
| **Summary**                   | always                                           | the problem and the solution, plus specific hints for the reviewer                   |
| **Breaking changes**          | always                                           | what broke and how behavior changed; an explicit "None" otherwise                    |
| **Architecture impact**       | a decision reaches beyond this PR                | decisions not contained to this PR; anything that should affect design going forward |
| **Deployment/rollback notes** | deploy/rollback needs more than the vanilla path | special steps — set env/secrets, provision infra, and similar                        |
| **Related issues**            | related issues exist                             | the issues and their relation — closes / related / depends on                        |

| Mistake                                                                                          | Fix                                                                             |
| ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------- |
| Ignoring the repo's `PULL_REQUEST_TEMPLATE.md` because it isn't auto-applied outside the web box | Discover and honor it (structure precedence)                                    |
| Authoring before reading the diff                                                                | Gather the changeset first; the Summary and Breaking-changes claim depend on it |
