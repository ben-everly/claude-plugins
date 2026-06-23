---
name: design-doc
description: Writes an agreed design up as a Google-style design doc.
disable-model-invocation: true
---

# Design Doc

## Overview

Write up an already-agreed design as a Google-style design doc, at design altitude, from the conversation context. Render it inline by default; never choose where it is stored.

## Input

The agreed design, drawn from the conversation. This skill does no questioning of its own — it reads what has already been settled and writes it up.

## Altitude

Design altitude: what to build and the shape of how — components, data flow, key decisions, and the alternatives weighed. Stop short of file-level technicals. Name each unresolved technical point explicitly in Open Questions rather than leaving it implicit, so a downstream reader — possibly a fresh `decompose` or `implement`/`tdd` session that lacks the original conversation — sees the gap and settles it there, instead of inheriting silence.

## Governing rules

1. **Emit inline; never pick a storage location.** Render the doc inline in chat as the deliverable — no file written, no default output path. When the user asks to save it, write to the path they provide (confirm one if they don't), then report where it landed. Never choose a location unilaterally.
2. **Fixed backbone, adaptive Design substructure.** The anchor sections always appear in this order: **Context & Scope → Goals & Non-Goals → Design → Alternatives Considered → Cross-cutting Concerns → Open Questions.** The substructure within Design adapts to the topic. Cross-cutting Concerns always renders its four dimensions — security, privacy, observability, operations — and each is either addressed or dismissed with a stated reason ("not applicable because…"), never by silent omission. Any other anchor with no genuine material collapses to a one-line "None" rather than padded prose, so the reader always knows where to find each anchor.
3. **Written as if fresh.** Describe the target system and the genuine alternatives a reader might weigh, as though authored by someone never in the conversation. This is a writing-style rule, not a section ban: Alternatives Considered and Non-Goals are real, expected sections — written as clean, reader-facing prose, never as a record of the conversation. Tangents from the conversation do not appear.

## Section guide

What each anchor holds, at design altitude:

- **Context & Scope** — the problem and what the change touches.
- **Goals & Non-Goals** — what success means; the boundaries. Non-Goals covers only real scope boundaries a reasonable reader might otherwise assume to be in scope.
- **Design** — the target system. The substructure here adapts to the topic.
- **Alternatives Considered** — only genuine options a reader would weigh, and why each was not chosen.
- **Cross-cutting Concerns** — security, privacy, observability, and operations, each addressed or dismissed with a stated reason.
- **Open Questions** — unresolved points, including any deferred technical detail.
