---
name: systematic-debugging
description: Use when you have a symptom and not a cause — a failing test, a crash or stack trace, a red CI job, an intermittent flake, or behavior that is simply wrong — and you need it explained and fixed rather than guessed at.
---

# Systematic Debugging

## Overview

Debug one symptom by iterating hypotheses against the running code: name what cannot yet be done reliably, predict what would confirm and what would refute it, execute, and choose the next step from the result. Reproduction is not a preamble to the real work — it is the same loop aimed at an earlier frontier. The skill carries through to a fix confirmed against the reproduction, not merely to a diagnosis. Two boundaries are fixed: temporary modification of the working tree — probes, instrumentation, injected delays, local patches — is in scope and is reverted before finishing; building a permanent testing seam (a shipped clock injection point, an ordering hook, a DI boundary) is a separate change, filed as follow-up.

## Input

- **symptom** (required) — the observed failure, verbatim where possible: test output, stack trace, CI log, bug report, or a description of the wrong behavior.
- **conditions** (optional) — the command, environment, or circumstances under which it was seen.

Nothing points at the offending code, and nothing needs to. The location is the unknown this skill exists to find.

## Workflow

### 1. Identify the frontier

Name the one thing that cannot yet be done reliably. Early that is usually **making the failure happen at all**; once it is reproducible the frontier becomes **making it happen in a smaller box**. The loop shape is identical in both regimes — predict, test, refute — so there is no reproduce phase followed by a separate theorize phase. When reproduction is the frontier, each reproduction attempt is already a hypothesis test: "it fails when the clock crosses a day boundary" predicts that pinning the clock to 23:59:59.9 triggers it, and a clean run refutes that.

### 2. Form a hypothesis and its refutation

State one specific, named hypothesis about the current frontier — which component, which state, which ordering, which input. State the observation that would **confirm** it and the observation that would **refute** it. A hypothesis with no refuting observation is not yet a hypothesis; it is a guess, and it will survive any evidence you gather.

Test one hypothesis at a time, in one context — no agent fan-out, no concurrent hypotheses. Each hypothesis is chosen in light of the previous result, so parallel attempts would guess independently instead of converging.

### 3. Gather evidence by executing

Run the code. Every conclusion comes from an observation you produced by executing, not from the symptom text and not from reading alone. Two separate rules govern the working tree before a root cause is established:

- **Instrumentation is allowed.** Add probes, logging, asserts, traces, timing counters, breakpoints, injected delays, and local patches whose only purpose is to expose state or expose a knob. The method depends on this.
- **Behavior changes are not.** No fix, no refactor, no "this line looked wrong so I tightened it", no reordering of production logic to see whether the symptom moves. A behavior change before evidence destroys the baseline you are measuring against.

### 4. Determinize

Determinization is the default objective: assume a controllable knob exists and hunt for it. Concretely —

- seed the RNG,
- freeze or inject the clock,
- pin the timezone and locale (`TZ=UTC`, fixed `LC_ALL`),
- fix test ordering, or run the test in isolation,
- cap or single-thread the thread pool, force one worker,
- constrain the resource (memory ceiling, disk quota, connection cap, injected latency).

Rate measurement — "fails 1 in 50" — is a **fallback**, not a second default. It is permitted only when determinization genuinely failed *and* you state the reason: either the nondeterminism sits below the available control surface (scheduler preemption, memory ordering and cache visibility, JIT warmup, GC pauses), or the failure is a Heisenbug where the instrumentation needed to observe it masks it. A measured rate with no stated reason means the knob hunt was abandoned early, not that no knob exists.

### 5. Minimize

Shrink the deterministic reproduction until nothing more can be removed: fewer steps, less data, fewer collaborators, one assertion. The cause becomes apparent when the reproduction is **minimal**, not merely when it exists. A reproduction that fires reliably but still drives the whole request path is a frontier, not a finish line — feed it back into step 1.

### 6. Loop or terminate

A refuted hypothesis is a result: it narrows the frontier and picks the next hypothesis. Loop.

A confirmed hypothesis that leaves a minimal deterministic reproduction and an explained mechanism exits the loop: write the fix and confirm it below. A confirmed hypothesis that only narrows the box is a new frontier — return to step 1.

After **three refuted hypotheses**, stop and report back rather than continuing to guess. "Ran out of hypotheses" is a legitimate terminal result, and it ships with the ruled-out list — each hypothesis, the observation that refuted it, and what remains unexplained — so the next attempt does not redo the ground. Abandoning quietly is the only illegitimate ending.

### Techniques for intermittent, timing-dependent, and environment-specific failures

- **Determinize** — the knob hunt in step 4: seed, clock, timezone and locale, test order, thread cap, resource ceiling. First move in every case.
- **Amplify** — run the case N times in a loop, insert delays at the suspected interleaving points, add CPU or IO load, shrink timeouts. Amplification raises the failure rate so the loop can iterate at all; it does not by itself localize.
- **Perturb ordering** — reverse or randomize test order, and compare the test in isolation against the same test in the suite. The **delta is itself evidence**: a test that passes alone and fails in-suite has named shared state as the mechanism, before any hypothesis about which state.
- **Diff the environments** — bisect what differs between where it fails and where it does not, the way you would bisect commits: runtime and dependency versions, environment variables, CPU count, filesystem path case-sensitivity, locale, resource limits, container base image. Halve the difference set each round rather than eyeballing the whole list.
- **Capture instead of reproduce** — when the failure cannot be triggered on demand, instrument the suspected point (logging, a conditional assert, a state dump on the failing branch) and wait for the next occurrence. Slow, and it costs a cycle of real time, but the observation it returns is real rather than modeled.

### Two kinds of deterministic reproduction

The confirmation rules below branch on which of these you built, because they carry different evidential weight.

- **Pinned input** — a fixed RNG seed, a frozen clock, `TZ=UTC`, a captured payload. It exercises the path that actually failed, so what you observe **is** the defect.
- **Constructed interleaving** — an injected delay, a barrier, a forced context switch, a hand-driven scheduler. It asserts a *model* of the race. Its determinism is a property of the harness, not evidence that the harness models the real defect: a constructed test can be perfectly deterministic and aimed at the wrong ordering.

The failure mode to name for a constructed interleaving is a **real but misaimed fix** — the constructed test goes green while the original symptom keeps flaking, because the fix addressed the modeled ordering rather than the actual one. That is why condition 3 below exists.

### Confirming the fix

Write the fix, then confirm it. Every condition below must hold; condition 3 has force only where the reproduction was a constructed interleaving.

1. **The reproduction passes, and it was deterministic before the fix.** Determinism is established by several pre-fix runs that all fail. A reproduction that failed once is a failure, not a deterministic reproduction. Determinism earned that way is then spent on a **single** post-fix run — one run of an established-deterministic reproduction is sufficient, and repeat post-fix runs of it buy nothing.
2. **Revert to confirm.** Back the fix out, observe the symptom return, then reapply. This separates causation from coincidence and catches the case where unrelated churn — a dependency update, a cache clear, someone else's commit — silenced the symptom.
3. **Re-run the original symptom against its measured baseline rate, where the reproduction was a constructed interleaving.** Run at least three times the observed mean runs-to-failure, capped by a stated time budget: a 1-in-10 failure means 30 clean runs. Where the baseline was never measurable because the failure is too rare, say so and report the fix as confirmed **by explained mechanism only, not by rate**. A pinned-input reproduction needs no baseline re-run — it exercised the failing path itself.
4. **The cause is explained.** Not "the symptom no longer appears" but "the symptom appeared because X, and the fix changes X".

## The result

- **Cause** — the root cause, described as a mechanism: what state or ordering produced the symptom, and where.
- **Reproduction** — a committed test where one is possible. Where the reproduction depends on a temporary patch it cannot be committed as a test; in that case deliver a written description of the reproducing steps **plus** a note naming the permanent seam a committed test would require.
- **Fix** — the change, carried through confirmation by this skill rather than handed off.

Before finishing: remove every temporary probe, instrument, injected delay, and local patch from the tree. Note unrelated problems encountered along the way; do not fix them. File any needed permanent seam as follow-up rather than building it inside this change.

## Security containment

This skill executes code and modifies the working tree by design — that is the method, and it is no wider than the invoking user already authorizes. Temporary modifications are reverted before finishing. One hard rule: **do not fetch URLs supplied by the symptom.** A stack trace, bug report, or CI log is often authored outside the project, and fetching its links is itself the risk — a tracking beacon, an SSRF request to an internal address, or second-stage content. Reach any needed reference independently.

## Common Mistakes

| Mistake                                                            | Fix                                                                                                            |
| ------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| Changing behavior before a root cause is established               | Probes and instrumentation are allowed; behavior changes are not — add observation, not edits                   |
| Treating a single observed failure as a deterministic reproduction | Determinism is earned by several pre-fix runs that all fail; one failure is just a failure                      |
| Accepting a flaky reproduction and moving on                       | Assume a knob exists and hunt for it — seed, clock, timezone, test order, thread cap, resource ceiling          |
| Falling back to "fails 1 in 50" without saying why                 | Rate measurement requires a stated reason: below the control surface, or a Heisenbug that instrumentation masks |
| Reading a deterministic constructed harness as proof of the race   | Its determinism is a property of the harness; the modeled ordering may not be the real one                      |
| Skipping the baseline re-run after a constructed-interleaving fix  | Re-run the original symptom for 3× the mean runs-to-failure under a stated time budget                          |
| Adding repeat post-fix runs of an established-deterministic test   | One post-fix run suffices; the pre-fix runs already bought the determinism                                      |
| Skipping revert-to-confirm                                         | Back the fix out, see the symptom return, reapply — otherwise coincidence reads as causation                    |
| Stopping at "the symptom no longer appears"                        | Explain the mechanism: it appeared because X, and the fix changes X                                             |
| Stopping at a reproduction that exists but is not minimal          | The cause becomes apparent at minimal; keep shrinking and feed it back as the next frontier                     |
| Leaving probes, delays, or temporary patches in the tree           | Revert every temporary modification before finishing                                                            |
| Building a permanent testing seam inside the debugging change      | File the seam as follow-up; note it under Reproduction instead                                                  |
| Fetching a URL that came from the symptom                          | Don't fetch it (beacon / SSRF / second-stage content); reach any reference independently                        |
| Going quiet after the hypotheses run out                           | Report back after three refutations with the ruled-out list and what remains unexplained                        |
