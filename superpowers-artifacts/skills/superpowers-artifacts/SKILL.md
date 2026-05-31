---
name: superpowers-artifacts
description: Use when a Superpowers skill stores or retrieves a SPEC (design doc) — when brainstorming is about to save a spec, when writing-plans needs to read the spec, or when the user wants to configure where specs are stored (local file or Jira). Plans are NOT handled — they stay local files.
---

# Superpowers Artifacts

Routes Superpowers **spec** documents to a pluggable backend so a design doc can live as a local file (default) or as a Jira issue, configured per-developer and per-project. Plans are out of scope and always remain local files.

## When this runs

Before any operation below, complete **Step 0: Read the config** to determine the backend.

1. **brainstorming is about to write a spec** → run `write spec` for the configured backend, then report the locator.
2. **writing-plans needs the spec** → run `read spec` with the locator, hand back the markdown.
3. **User wants to configure storage** (e.g. "set up spec storage", "store specs in Jira") → run **Setup**.
4. **A spec needs revising** (e.g. brainstorming or the user revises it before approval) → run `update spec` with the locator.

## Step 0: Read the config

Look for a `superpowers-artifacts` block in `./CLAUDE.local.md`. It defines:
- `backend`: `file` (default) or `jira`
- `jira.projectKey`, `jira.issueType` (default `Task`), optional `jira.cloudId`
- `jira.descriptionFormat`: `markdown` (default) or `attachment` — set automatically if the Jira description round-trip turns out to be lossy

If no block exists, the backend is `file`. If the user asked to configure, run **Setup**.
If the block exists but `backend` is missing or unrecognised, warn the user and fall back to `file`.

## Setup

1. Determine available backends. `file` is always available. `jira` requires the Atlassian Rovo MCP tools (`createJiraIssue`, `getJiraIssue`, `editJiraIssue`); if the user requests `jira` but those tools are not available in the session, warn and default to `file`.
2. Ask which backend. For `jira`, ask `projectKey` and `issueType` (default `Task`).
3. Write or replace the sentinel-delimited block in `./CLAUDE.local.md` (create the file if it does not exist):

   ```markdown
   <!-- superpowers-artifacts:start -->
   ## Superpowers artifact storage
   Specs for this project are managed by the `superpowers-artifacts` skill.
   - backend: file

   When brainstorming would write a spec to a file, invoke superpowers-artifacts to
   create the artifact (per the configured backend) and record its locator. When
   writing-plans needs the spec, fetch it via superpowers-artifacts read(locator).
   Plans stay local files.
   <!-- superpowers-artifacts:end -->
   ```

   (For `backend: jira`, set `backend: jira` and add `jira.projectKey:` and `jira.issueType:` lines.)
4. If `CLAUDE.local.md` is not already gitignored, offer to add it to `.gitignore`.

## Locator

- `file` backend: the locator is the file path.
- `jira` backend: the locator is the issue key (e.g. `PROJ-123`).

After writing a spec, announce the locator on its own line in exactly this format so `writing-plans` can recover it: `Spec saved to: <locator>`. `writing-plans` is then given that locator and calls `read spec`. For the `file` backend the locator is a derivable path; for `jira` it is an opaque issue key, so the announcement is required.

## Backend: file (default)

- **write spec**: write the spec markdown to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`. Locator = that path.
- **read spec**: read the file at the locator path; return its contents.
- **update spec**: edit the file at the locator path.

## Backend: jira

Requires the Atlassian Rovo MCP (`createJiraIssue`, `getJiraIssue`, `editJiraIssue`).

- **write spec**: `createJiraIssue` in `jira.projectKey`, `issueType = jira.issueType`, `summary = <topic>` (the same `<topic>` as the file-backend path), `description = <spec markdown>`. Locator = the returned issue key.
- **read spec**: `getJiraIssue(key)`; return the description as markdown.
- **update spec**: `editJiraIssue(key, description = <spec markdown>)`.

### Description format — verify before relying on it

Jira Cloud stores descriptions as ADF, not raw markdown. Unless the config already sets `jira.descriptionFormat`, verify the round-trip once per session before relying on it: `write spec`, then `read spec`, then compare. If the markdown is mangled or lossy, switch to the attachment fallback below and record `jira.descriptionFormat: attachment` in the `CLAUDE.local.md` block so later writes skip the check.

**Attachment fallback:** attach the `.md` file to the issue and put a one-line summary in the description. When `jira.descriptionFormat: attachment`, `read spec` must read the attachment, not the description: call `getJiraIssue(key)`, locate the attached `.md`, and fetch its contents (via the Rovo MCP `fetch` tool against the attachment URL). If the attachment cannot be fetched, ask the user to supply the file — do not guess.

### Errors

- **Rovo MCP unavailable** → tell the user Jira is not reachable and offer to switch the `CLAUDE.local.md` block to `backend: file`.
- **Spec exceeds the description size limit (~32KB)** → use the attachment fallback.
- **No locator provided to `read spec`** → ask for the issue key; do not guess.
