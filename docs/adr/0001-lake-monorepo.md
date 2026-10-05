# 0001 — Lake single-package start, mathlib behind a toggle

Date: 2026-10-04

## Status

Accepted

## Context

Lean projects either need mathlib (heavy: thousands of modules, reservoir
caching mandatory) or build fine on bare Lean 4 (fast, no cache wrangling).
A template must serve both without defaulting to a ten-minute cold build.

## Decision

- Bare Lean 4 by default: one `lean_lib` (globbed `Omni/`) + a `test`
  executable — `lake build && lake exe test` is the whole pipeline.
- Mathlib is a documented toggle: add `[[require]] name = "mathlib"` with a
  pinned revision to `lakefile.toml` and flip `mathlib: true` in the CI's
  `lean-action` input for reservoir cache downloads.
- Theorem-first demonstrations: `safeHead_eq_head` is checked by the kernel
  on every build — properties cannot rot the way comments do.

## Consequences

- Cold start stays under a minute without mathlib.
- Mathlib adoption is an ADR + two-line change, documented before it hurts.
