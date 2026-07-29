# Intermittent, timing-dependent, and environment-specific failures

Read this when the symptom does not fail on every run, depends on timing or ordering, or reproduces in one environment and not another. Everything here sits inside the loop in `SKILL.md`: it supplies the techniques for that loop's early frontiers and adds one condition to confirming the fix.

## Techniques

- **Determinize** — the knob hunt in step 4: seed, clock, timezone and locale, test order, thread cap, resource ceiling. First move in every case.
- **Amplify** — run the case N times in a loop, insert delays at the suspected interleaving points, add CPU or IO load, shrink timeouts. Amplification raises the failure rate so the loop can iterate at all; it does not by itself localize.
- **Perturb ordering** — reverse or randomize test order, and compare the test in isolation against the same test in the suite. The **delta is itself evidence**: a test that passes alone and fails in-suite has named shared state as the mechanism, before any hypothesis about which state.
- **Diff the environments** — bisect what differs between where it fails and where it does not, the way you would bisect commits: runtime and dependency versions, environment variables, CPU count, filesystem path case-sensitivity, locale, resource limits, container base image. Halve the difference set each round rather than eyeballing the whole list.
- **Capture instead of reproduce** — when the failure cannot be triggered on demand, instrument the suspected point (logging, a conditional assert, a state dump on the failing branch) and wait for the next occurrence. Slow, and it costs a cycle of real time, but the observation it returns is real rather than modeled.

## Two kinds of deterministic reproduction

The baseline re-run condition below branches on which of these you built, because they carry different evidential weight.

- **Pinned input** — a fixed RNG seed, a frozen clock, `TZ=UTC`, a captured payload. It exercises the path that actually failed, so what you observe **is** the defect.
- **Constructed interleaving** — an injected delay, a barrier, a forced context switch, a hand-driven scheduler. It asserts a *model* of the race. Its determinism is a property of the harness, not evidence that the harness models the real defect: a constructed test can be perfectly deterministic and aimed at the wrong ordering.

The failure mode to name for a constructed interleaving is a **real but misaimed fix** — the constructed test goes green while the original symptom keeps flaking, because the fix addressed the modeled ordering rather than the actual one. That is why the baseline re-run condition exists.

## The baseline re-run condition

This condition is additional to the confirmation conditions in `SKILL.md`, all of which still apply.

**Re-run the original symptom against its measured baseline rate, where the reproduction was a constructed interleaving.** Run at least three times the observed mean runs-to-failure: a 1-in-10 failure means 30 clean runs. State that re-run's time budget **before the first run** — a budget named once the runs are already spent is not a cap. Where three times the mean exceeds the budget you stated, or the failure was never frequent enough to measure a mean at all, say so and report the fix as confirmed **by explained mechanism only, not by rate**. A pinned-input reproduction needs no baseline re-run — it exercised the failing path itself.
