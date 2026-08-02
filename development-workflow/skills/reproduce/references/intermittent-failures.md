# Intermittent, timing-dependent, and environment-specific failures

Read this when the symptom does not fail on every run, depends on timing or ordering, or reproduces in one environment and not another. Everything here sits inside the loop in `SKILL.md`: it supplies the techniques for making such a failure fire every time, and states what a reproduction built by forcing an ordering must ship with.

## Techniques

- **Determinize** — the knob hunt in step 4, before anything here.
- **Amplify** — run the case N times in a loop, insert delays at the suspected interleaving points, add CPU or IO load, shrink timeouts. Amplification raises the failure rate so the loop can iterate at all; it does not by itself localize.
- **Perturb ordering** — reverse or randomize test order, and compare the test in isolation against the same test in the suite. The **delta is itself evidence**: a test that passes alone and fails in-suite has named shared state as the mechanism, before any hypothesis about which state.
- **Diff the environments** — bisect what differs between where it fails and where it does not, the way you would bisect commits: runtime and dependency versions, environment variables, CPU count, filesystem path case-sensitivity, locale, resource limits, container base image. Halve the difference set each round rather than eyeballing the whole list.
- **Capture instead of reproduce** — when the failure cannot be triggered on demand, instrument the suspected point (logging, a conditional assert, a state dump on the failing branch) and wait for the next occurrence. Slow, and it costs a cycle of real time, but the observation it returns is real rather than modeled.

## Two kinds of deterministic reproduction

These carry different evidential weight, and the obligation below applies to only one of them.

- **Pinned input** — a fixed RNG seed, a frozen clock, `TZ=UTC`, a captured payload. It exercises the path that actually failed, so what you observe **is** the defect.
- **Constructed interleaving** — an injected delay, a barrier, a forced context switch, a hand-driven scheduler. It asserts a *model* of the race. Its determinism is a property of the harness, not evidence that the harness models the real defect: a constructed test can be perfectly deterministic and aimed at the wrong ordering.

The failure mode this sets up is a **real but misaimed fix** — the constructed test goes green while the original symptom keeps flaking, because the fix addressed the modeled ordering rather than the actual one.

## A constructed reproduction ships unvalidated

Nothing inside this skill can establish that a constructed interleaving models the real defect. That only becomes knowable once a change aimed at the modeled ordering is measured against the original symptom, which is outside this scope. So say so, and hand on what makes the check possible later:

- **State the caveat plainly.** This reproduction is deterministic by construction and exercises one ordering; it has not been shown to exercise the ordering that produces the symptom.
- **Report the measured baseline rate of the original symptom** — runs attempted and failures observed. Without it there is no way to tell later whether the flake actually stopped. Clearing that bar takes at least three times the observed mean runs-to-failure: for a per-run failure probability of `1/N`, the chance of zero failures across `3N` runs is about `e⁻³ ≈ 5%`, so a 1-in-10 symptom needs 30 clean runs. Record that figure alongside the rate.
- **State the time budget before the first measuring run**, not after — a budget named once the runs are already spent is not a cap.

Where the failure was never frequent enough to measure a mean at all, say that instead; the reproduction then rests on explained mechanism alone, with no rate behind it.

A pinned-input reproduction needs none of this — it exercised the failing path itself.
