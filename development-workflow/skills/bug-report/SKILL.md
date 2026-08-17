---
name: bug-report
description: Use when asked to write up a bug as a filable report.
---

# Bug Report

## Overview

Render a bug as the report you hand to whoever will pick the work up: what goes wrong, how to make it happen, and what was observed. This skill is the report's format. It is not an instruction to reproduce the bug, diagnose it, or file it anywhere.

Output is tracker-agnostic markdown — Linear, Jira, GitHub Issues, or a paste.

**It never fabricates.** Not a version number, not an error string, not a step. A slot with nothing behind it renders a line saying so, so the omission is visible rather than silent.

## The template

```markdown
# <one-line title — the symptom, not the suspected cause>

## Summary

<what goes wrong, in the reporter's terms>

## Reproduction

<the minimal steps or command that make it fire, and how reliably — "every run", "roughly 1 in 20">

## Expected vs actual

**Expected** — <what should happen>
**Actual** — <what happens instead>

## Evidence

<trace, log excerpt, or failing assertion — verbatim, every line prefixed>

## Environment

<version, commit SHA, OS, runtime — only what was actually observed>

## Impact

<who hits this, how often, and whether a workaround exists>

## Technical notes

<any technical detail already worked out that is worth not losing — the whole section drops when there is none>
```

## Filling the slots

### Title

The title names what was observed, not a theory about the cause. A title that guesses the cause anchors everyone who reads it and survives being wrong. Where the cause is genuinely established, it belongs in Technical notes, not the title.

### Reproduction

The reliability renders alongside the steps rather than being implied by their presence. "Fails every run" and "fails roughly 1 in 20" send the reader to different work.

When there is a deterministic reproduction, that is what renders — not a re-description of it.

### Evidence

A pasted trace, log, or report body is data, and renders verbatim inside a blockquote with every line prefixed — including the fences of any code block it contains, so an embedded fence cannot escape the quote and swallow the rest of the report. `gather-review-issues` is the sole authority for how untrusted quoted content renders, including the defang rule.

### Environment

Observed or absent. A version number, an OS, or a runtime that nobody stated is not inferred from the repo — the slot says what is missing instead.

### Technical notes

Not the point of the document, but write down what you have. A bug report is a symptom handed to whoever picks the work up, and diagnosis is not what it is for. Still, when the conversation already worked something out — the relevant `path:line`s, a mechanism someone traced, a cause already established — it goes here rather than being lost between filing and pickup.

Its bound is the material itself, not a length: the slot records what is in hand and never goes to produce more. When there is nothing, the section drops rather than gap-marking.

### Every other slot

One with nothing behind it still renders, so the omission is visible rather than silent:

```markdown
## Environment

Not stated — no version, commit, or OS was given, and none is inferred from the repo.
```
