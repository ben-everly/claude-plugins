---
name: jira-cli
description: Use when the user mentions or needs to interact with Jira — issues, tickets, cards, work items, sprints, boards, backlog, story points, epics, subtasks, assignees, or transitions. Also when they reference issue keys like KEY-123 (2-10 uppercase letters/numbers starting with a letter, e.g., PRJ-11, ENG-452).
---

# Atlassian CLI (acli) - Jira Skills

`acli` is the Atlassian CLI for managing Jira from the terminal.

**Always run `acli jira <COMMAND> [SUBCOMMAND] --help` before constructing a command** — flags vary between commands.

## Command Overview

### Top-level commands

| Command     | Purpose                                     |
| ----------- | ------------------------------------------- |
| `board`     | List and view boards                        |
| `sprint`    | Manage sprints within a board               |
| `filter`    | Create, list, and manage saved filters      |
| `field`     | List and inspect issue fields               |
| `dashboard` | List and view dashboards                    |
| `project`   | List and view projects                      |
| `workitem`  | Create, edit, search, transition work items |

### `workitem` subcommands

| Subcommand    | Purpose                            |
| ------------- | ---------------------------------- |
| `create`      | Create a new issue                 |
| `create-bulk` | Create multiple issues at once     |
| `edit`        | Update fields on an existing issue |
| `assign`      | Change the assignee                |
| `search`      | Find issues using JQL              |
| `view`        | Display issue details              |
| `transition`  | Move an issue to a new status      |
| `comment`     | Add or list comments               |
| `link`        | Create links between issues        |
| `attachment`  | Upload or list attachments         |
| `watcher`     | Add or remove watchers             |
| `clone`       | Duplicate an issue                 |
| `archive`     | Archive an issue                   |
| `unarchive`   | Restore an archived issue          |
| `delete`      | Delete an issue                    |

## Formatting

Prefer **markdown** (plain text) — it supports more features through acli than ADF. Use ADF only when you need programmatic/structured JSON content (see `references/adf-format.md`).

### Markdown Quick Reference

| Element         | Syntax                                        |
| --------------- | --------------------------------------------- |
| Bold            | `**text**`                                    |
| Italic          | `*text*`                                      |
| Strikethrough   | `~~text~~`                                    |
| Monospace       | `` `text` ``                                  |
| Headings        | `#` through `######`                          |
| Unordered list  | `*` or `-`                                    |
| Ordered list    | `1.` or `2)`                                  |
| Checklist       | `[] item` (incomplete), `[x] item` (complete) |
| Block quote     | `>`                                           |
| Code block      | ` ``` `                                       |
| Link            | `[text](url)`                                 |
| Horizontal rule | `---`                                         |

## JQL Quick Reference

- Single quotes for values with spaces: `status = 'Some Status'`
- Avoid `!=` with backslash — use `NOT status = 'Done'` instead
- Functions: `currentUser()`, `now()`, `startOfDay()`, `endOfWeek()`
- Status categories: `statusCategory = Done`, `statusCategory = 'In Progress'`
- Operators: `AND`, `OR`, `NOT`, `IN`, `IS`, `IS NOT`, `~` (contains), `ORDER BY`

### Common JQL Patterns

```jql
project = <PROJECT> AND assignee = currentUser() AND resolution = Unresolved
project = <PROJECT> AND status = '<STATUS_NAME>'
project = <PROJECT> AND statusCategory = 'In Progress'
project = <PROJECT> AND updated >= -7d ORDER BY updated DESC
```

## Common Mistakes

- **Guessing flags** — always run `--help` for the specific command; flags differ between subcommands.
- **Plain text newlines** — a single `\n` doesn't create paragraph breaks. Use a blank line (`\n\n`) between paragraphs, or use `--body-file` with a markdown file for complex content.
- **`!=` with backslash in JQL** — JQL's `!=` operator behaves unexpectedly with some values. Use `NOT field = 'value'` instead.
