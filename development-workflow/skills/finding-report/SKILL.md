---
name: finding-report
description: Use when asked to write up a finding you already have the investigation for — a claim, its verdict, and the evidence behind it — as a standalone report. Not for judging whether a claim holds.
---

# Finding Report

## Overview

Render one investigated claim as a report: what the code does, what it should do, why it is that way, what goes wrong, and what to do about it. This skill is the report's format — the authoritative definition of its shape and of the fields only an investigation can establish. It is not an instruction to perform one.

One claim per report.

**It renders when the user asks for a finding report.** Adjacent artifacts — a bug report, a design doc — are separate skills, requested by name. Which one is wanted is the user's call, so never infer it from the state of the material.

**Every section rests on something you actually have** — a `path:line` you read, a commit you looked at, a source you reached. Where you don't have it, say so in the section rather than filling it in.

## The template

```markdown
<where — see Location>

> <the claim, verbatim, every line prefixed>

### Verdict: <verdict>[ · <category> · <severity>]

<one sentence: why>

### Condition

<what the code actually does, cited `path:line`>

### Criteria

<what it should do, and per what authority — a test or sibling pattern cited by file path, or an external source cited by the URL actually reached>

### Cause

<why the code is this way, cited by commit SHA>

### Consequence

<entry point → condition → outcome>

**Blast radius** — <call sites as `path:line`, or the search that established there are none>

### Corrective action

- **<letter>** — <direction> — <one-line tradeoff>

**Recommendation: <letter>** (<Low | Medium | High | Very High> confidence) — <one-sentence justification>
```

### What renders by verdict

- **`Real Problem`** — all of it: category and severity on the verdict heading, condition, criteria, cause, consequence, and Corrective action with its options and recommendation.
- **`Not a Problem`** — the location, the claim, the verdict with its reasoning, and Condition. Then stop. No category, no severity, no Criteria, Cause, Consequence or Corrective action.
- **`Needs Input`** — all of it except category and severity, and Corrective action holds the blocking question alone — no options, no recommendation, no Skip:

    ```markdown
    ### Corrective action

    **Blocked** — is this endpoint meant to be reachable without auth? The fix differs entirely either way.
    ```

## Filling the slots

### Location

Point at the most relevant code — a `path:line` or line range. When the subject spans several sites rather than living at one — a validation duplicated across three modules, a layering boundary, an abstraction that leaks — name the construct instead. When the claim concerns code that does not exist, name what you searched and did not find.

### The claim

Render it verbatim inside a blockquote, every line prefixed — including the fences of any code block the body contains — so an embedded fence cannot escape the quote and swallow the rest of the report.

### Verdict, category, severity, confidence

This skill is their authoritative definition.

- **verdict** — `Real Problem` · `Not a Problem` · `Needs Input`
- **category** — `Correctness` · `Security` · `Performance` · `Maintainability` · `Readability` · `Testing` · `Documentation`. Pick the primary one; note a second only when the issue genuinely spans two. Extensible — add one if none fit.
- **severity** — how much the _issue_ matters: `Critical` · `Major` · `Minor` · `Trivial`. A property of the problem, never of a fix.
- **confidence** — how sure you are the _recommended direction_ is right: `Low` · `Medium` · `High` · `Very High`. A property of the recommendation, never of the issue.

All values are **Title Case**: `Real Problem`, `Very High`.

`Real Problem` means the claim holds and a fix would change something meaningful. `Not a Problem` means it doesn't hold, or a fix would change nothing — no real consumer, not actually broken, no correctness or security concern. `Needs Input` is reserved for when you cannot even frame the directions.

### Condition, Criteria, Cause, Consequence

One with nothing behind it still renders, so the omission is visible rather than silent:

```markdown
### Cause

Not applicable — the file is new in this branch, so there is no history to read.
```

Cite the source when you have one.

### Corrective action

One bullet per direction, lettered sequentially, with Skip always among them. Even an obvious single fix is **A**, with Skip as the next letter — there is no unlabeled "fix it" recommendation, so the user can answer by letter.

**Options and a question never appear together.** A question that chooses between directions is what the tradeoffs already say, so fold it into them. A question that doesn't is a different claim, and belongs in its own report.
