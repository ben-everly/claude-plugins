---
name: investigate-issue
description:
  Use when you need to judge whether a single claim about the code is a real
  problem and what to do about it.
---

# Investigate Issue

## Overview

Gather what the `development-workflow:investigator` agent needs to judge one
claim, dispatch it, and return its `finding-report` unchanged.

## Workflow

### 1. Write the brief

Fill every field you can from the arguments and the conversation. The agent
cannot see the conversation; the brief is all it gets.

| Field     | Required | Content                                                                                                                                                                                                                |
| --------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `claim`   | Yes      | One line: what the claim asserts.                                                                                                                                                                                      |
| `anchor`  | No       | The `path:line`s the claim points to.                                                                                                                                                                                  |
| `ref`     | No       | The code state to read: `HEAD`, a branch, or a SHA. Default: the working tree.                                                                                                                                         |
| `diff`    | No       | The change under review, as `git diff` arguments: `HEAD` (uncommitted), `--staged`, `main...HEAD` (branch commits), `--merge-base main` (branch + uncommitted). A PR is `gh pr diff <n>`, the one non-`git diff` form. |
| `context` | No       | Only what the conversation holds and the agent cannot find: how the user frames the claim, directions already ruled out, and any answer the user gave since a previous investigation.                                  |

The brief carries references, never file contents or pasted diffs — the agent
reads the current code itself.

### 2. Dispatch

Dispatch `development-workflow:investigator` by name with the brief. Its final
message is the finding report; return it unchanged. Never write the report
yourself — if the agent returns something other than a report, say so.
