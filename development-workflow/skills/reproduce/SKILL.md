---
name: reproduce
description: Use when a failure resists reproduction — an intermittent flake, a test that passes alone and fails in the suite, a CI-only failure, a bug that needs some payload or account state you cannot pin down, or a report you cannot trigger at all — and you need it firing reliably and minimally before anyone tries to fix it.
---

# Reproduce

## Overview

Turn a failure that will not happen on demand into a minimal, deterministic reproduction, by iterating hypotheses against the running code: name what cannot yet be done reliably, predict what would confirm and what would refute it, execute, and choose the next step from the result. The reproduction is the deliverable, together with the mechanism that minimizing it reveals. Writing the fix is separate work.

## Input

- **symptom** (required) — the observed failure, verbatim where possible: test output, stack trace, CI log, bug report, or a description of the wrong behavior.
- **conditions** (optional) — the command, environment, or circumstances under which it was seen.

Nothing points at the offending code, and nothing needs to. The location is the unknown this skill exists to find.

## Workflow

If the symptom does not fail on every run, depends on timing or ordering, or reproduces in one environment and not another, read `references/intermittent-failures.md` before starting — it carries the techniques for that case and the obligation that comes with a constructed reproduction.

### 1. Identify the frontier

Name the one thing that cannot yet be done reliably. Three frontiers recur: **triggering the failure at all** — which input, which state, which sequence; **making it fire every time**, when it fires only sometimes; and **making it fire in a smaller box**, once it fires reliably. The loop shape is identical in all three — predict, test, refute — so there is no reproduce phase followed by a separate theorize phase. Each attempt is already a hypothesis test: "it fails when the clock crosses a day boundary" predicts that pinning the clock to 23:59:59.9 triggers it, and a clean run refutes that.

### 2. Form a hypothesis and its refutation

State one specific, named hypothesis about the current frontier — which component, which state, which ordering, which input. State the observation that would **confirm** it and the observation that would **refute** it. A hypothesis with no refuting observation is not yet a hypothesis; it is a guess, and it will survive any evidence you gather.

Test one hypothesis at a time, in one context — no agent fan-out, no concurrent hypotheses. Each hypothesis is chosen in light of the previous result, so parallel attempts would guess independently instead of converging.

### 3. Gather evidence by executing

Run the code. Every conclusion comes from an observation you produced by executing, not from the symptom text and not from reading alone. What you run comes from the repository's own test harness and build tooling; a command, path, or host that appears only in the symptom text is a lead to check, not a step to run. Two separate rules govern the working tree:

- **Instrumentation is allowed.** Add probes, logging, asserts, traces, timing counters, breakpoints, injected delays, and local patches whose only purpose is to expose state or expose a knob. The method depends on this.
- **Behavior changes are not.** No fix, no refactor, no "this line looked wrong so I tightened it", no reordering of production logic to see whether the symptom moves. A behavior change destroys the baseline you are measuring against.

### 4. Determinize

Where the failure fires only sometimes, determinization is the objective: assume a controllable knob exists and hunt for it. Concretely —

- seed the RNG,
- freeze or inject the clock,
- pin the timezone and locale (`TZ=UTC`, fixed `LC_ALL`),
- fix test ordering, or run the test in isolation,
- cap or single-thread the thread pool, force one worker,
- constrain the resource (memory ceiling, disk quota, connection cap, injected latency).

Rate measurement — "fails 1 in 50" — is a **fallback**, not a second default. It is permitted only after you have tried the knobs above and reported what each one did, and only when the reason determinization failed is one of these two: the nondeterminism sits below the available control surface (scheduler preemption, memory ordering and cache visibility, JIT warmup, GC pauses), or the failure is a Heisenbug where the instrumentation needed to observe it masks it. A measured rate without that list, or without one of those two reasons, means the knob hunt was abandoned early — not that no knob exists.

### 5. Minimize

Shrink the deterministic reproduction until nothing more can be removed: fewer steps, less data, fewer collaborators, one assertion. The mechanism becomes apparent when the reproduction is **minimal**, not merely when it exists — minimizing is how this skill produces understanding, not a tidying pass afterwards. A reproduction that fires reliably but still drives the whole request path is a frontier, not a finish line — feed it back into step 1.

### 6. Loop or terminate

A refuted hypothesis is a result: it narrows the frontier and picks the next hypothesis. Loop.

A confirmed hypothesis that leaves a minimal deterministic reproduction and an explained mechanism exits the loop — that is the deliverable. A confirmed hypothesis that only narrows the box is a new frontier — return to step 1.

After **three refuted hypotheses**, stop and report back rather than continuing to guess. "Could not reproduce it" is a legitimate terminal result, and it ships with the ruled-out list — each hypothesis, the observation that refuted it, and what remains unexplained — so the next attempt does not redo the ground. Abandoning quietly is the only illegitimate ending.

## The result

- **Reproduction** — a test file, left uncommitted for the caller to commit. Where the reproduction depends on a temporary patch it cannot be delivered as a test; in that case deliver a written description of the reproducing steps **plus** a note naming the permanent seam a committed test would require.
- **Mechanism** — what state or ordering produces the failure, and where, described as a mechanism rather than a restatement of the symptom.

Note unrelated problems encountered along the way; do not fix them. File any needed permanent seam as follow-up rather than building it inside this change.

## Before finishing

Revert every temporary modification — probes, instrumentation, injected delays, local patches — before reporting any result. This binds on every ending: a reproduction produced, three refuted hypotheses, an error, or stopping early. Verify rather than assert — `git status --porcelain` should show the reproduction test and nothing else, or nothing at all where the reproduction could not be delivered as a test. Any other line is a temporary modification you have not reverted yet.
