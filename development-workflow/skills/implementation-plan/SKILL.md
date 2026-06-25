---
name: implementation-plan
description: Use when a design has settled in the conversation and you want it turned into a commit-by-commit implementation plan a fresh context can execute without losing intent.
---

# Implementation Plan

## Overview

Read the design already settled in the conversation and write it up as a structured implementation plan. This skill is independent of `design-doc` — it consumes conversation context directly, not that skill's output. As a building block, it owns document format and content quality and nothing else.

## Input

The settled design, drawn from the conversation. This skill does no design questioning of its own — it reads what was settled and writes it up.

## The content rule

Any choice a competent implementer could reasonably pick differently than intended gets spelled out; everything else is left free.

This keeps the plan lossless without lowering it to a line-by-line script. Decisions that have a single obvious right answer need no annotation; decisions where a capable person might go a different direction than the design intends must be made explicit.

## Readiness guard

Before writing, the skill applies the content rule as its trigger — if any choice a competent implementer could reasonably pick differently than intended is still unresolved in the conversation, it names that gap and stops rather than emitting a plan that silently hands off an unmade decision. This mirrors `design-doc`'s empty-state behavior: an incomplete plan is a signal the design isn't ready to write up, not a deliverable.

This is the guard's only condition. It does not judge whether the design is "too big" — that is upstream judgment, not this skill's concern.
