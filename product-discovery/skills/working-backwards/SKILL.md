---
name: working-backwards
description: Draft an Amazon-style Working Backwards (PR/FAQ) document from the research in the current conversation.
disable-model-invocation: true
---

# Working Backwards (PR/FAQ)

## Overview

Draft an Amazon-style Working Backwards document — a one-page Press Release plus an FAQ — from the research the user has already done in this conversation. Reason backwards from the customer's experience to what must be built.

Produce the draft in one pass, do not ask follow-up questions.

## Inputs

- **The conversation** — the primary and authoritative source. Build the document from what the user has already established here: the idea, decisions, research, constraints, and any quotes or numbers they provided.
- **Optional grounding** — you may read the codebase or use external tools (web / MCP) only to support or verify something stated in the conversation. Never to introduce new facts or assumptions.

## Core discipline: never fabricate

Do not guess or invent any fact, metric, quote, price, date, customer name, or claim. If the conversation does not supply it and you cannot ground it, mark it as a gap — do not write plausible-sounding filler.

Customer quotes and leadership quotes are always gap-marked unless a real one exists in the conversation.

When you infer a load-bearing fact (product name, target customer, scope) rather than taking it from the conversation, surface it — inline or in Open Questions — as an assumption to confirm, not as settled fact.

### Gap markers

Where required information is missing, insert a gap marker instead of content, two options:

- **Inline**, exactly where the content belongs, so the document's shape stays intact:
  `[GAP: <what's missing> — <where it might come from>]`
- **At the end** in an "Open Questions & Gaps" section — for broader gaps that don't fit a single slot in the document.

A section with no supporting material in the conversation becomes a single gap marker, not fabricated prose.

## Output

Render the full draft in the chat by default. Do not write a file unless the user asks. When they ask, save to the path they provide (confirm one if they don't), then tell them where it is. There is no default output path.

## Document structure

Produce these sections in order.

### 1. Press Release

About one page, customer-facing, jargon-free, written as if the product already launched.

- **Heading** — the product name as a customer would say it.
- **Sub-heading** — one line: the target customer and the key benefit.
- **Date** — the intended launch date, written in the future as if it were today. Gap-mark if unknown.
- **Summary** — one paragraph: product + customer + benefit. Must stand on its own.
- **Problem** — the customer problem, from their point of view.
- **Solution** — how the product solves it, simply.
- **Leadership quote** — a quote from the company explaining why you built it. Gap-mark unless a real one exists.
- **How to get started** — how a customer begins, in one or two sentences.
- **Customer quote** — a satisfied customer describing the benefit they got. Gap-mark unless a real one exists.
- **Closing / call to action** — where to go next.

### 2. External FAQ

Questions a customer or the press would ask. Answer each from the conversation; gap-mark what's missing.

- What does it cost?
- How do I get it, and when is it available?
- What exactly does it do?
- How is it different from the alternatives?
- Add any others the conversation raises.

### 3. Internal FAQ

The hard questions leadership will press on — where the real thinking lives. Answer from the conversation, gap-mark the rest.

- What is the customer / market size and the opportunity?
- What is the hardest technical or operational problem?
- What are the economics — business model, costs, margins?
- What are the risks and dependencies?
- What did we learn from prototypes, data, or customer research?
- Why us, and why now?
- What are we explicitly NOT doing (non-goals)?

### 4. Open Questions & Gaps (optional)

A checklist of the broader gaps that don't fit a single slot above.

## Principles

- Reason backwards from the customer, not forwards from the technology.
- Use plain language a customer would use — no internal jargon or acronyms.
- Keep it lean: these are prompts to answer, not sections to pad. Honest gaps beat padded prose.
