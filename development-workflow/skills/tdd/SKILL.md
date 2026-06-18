---
name: tdd
description: Use when implementing any testable change and you want test-first discipline.
---

# Test-Driven Development

## The loop: red → green → refactor

1. **Red** — write one failing test for the next behavior. Run it and confirm it fails *for the right reason* (the behavior is missing — not a typo or a setup error).
2. **Green** — write the minimal code to make that test pass. Nothing more.
3. **Refactor** — with the test green, clean up duplication and naming while keeping it green.

Repeat for the next behavior.

## One test at a time (vertical slices)

Never write all the tests first and then all the implementation. Each test covers one behavior end-to-end before you move to the next.

Writing tests in bulk produces tests for *imagined* behavior and locks you into a test structure before you understand the implementation.

## Test behavior, not implementation

Exercise real code paths through public interfaces. Don't assert on private internals, and don't mock the code under test.

Litmus test: if a test breaks when you refactor but the behavior hasn't changed, it's coupled to the implementation — rewrite it against the public behavior.

## Never refactor while red

Reach green first, then improve. Refactoring on top of a failing test means you can't tell whether a failure comes from the test you're driving or the change you just made.
