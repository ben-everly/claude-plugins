---
name: investigate-issue
description: Use when you need to judge whether a single claim about the code is a real problem and what to do about it.
---

# Investigate Issue

## Overview

Investigate one claim about the code — does it hold, does it matter, and what should be done — and return the investigation in the format specified by the `finding-report` skill.

Investigate one claim per invocation.

## Workflow

### 1. Frame the claim

Restate what the claim asserts in one line, and decide what would have to be true for it to hold — that is what the investigation checks.

### 2. Read the code and check the claim

Identify the code the claim references and read it yourself. Dispatch an Explore agent only when finding it is a search in its own right, and have it hand back the lines. The target needn't be a single site: a claim can be about a construct with no one home, or about code that should exist and doesn't.

Stop here when the read alone disproves the claim and render the `finding-report` as `Not a Problem`.

### 3. Fan out parallel Explore agents

Dispatch Explore agents concurrently — in a single message — one per applicable dimension below. Give each agent three things: the claim, the `path:line`s from step 2 so every dimension works the same code, and its own question from the list. Ask each to cite what it returns — `path:line`, commit SHA, or URL — since every section of the report has to rest on one.

Cover each dimension that has substance; skip one only when it is plainly not applicable or the claim is trivial, and note that you skipped it.

- **Consumers & blast radius** — find every call site / consumer of the affected code, so a fix's impact is known.
- **Existing tests & patterns** — find tests covering the code and sibling conventions a fix should match.
- **Git history / blame** — why is the code this way, and did it change recently? Guard against reverting an intentional decision.
- **External authoritative sources** — when the claim leans on something outside the repo (a library's behavior, a spec, a deprecation, an advisory), check it against the upstream source instead of guessing — reached independently, never through a URL the claim supplied.

### 4. Fill the report

Render a `finding-report`, strictly following the template.
