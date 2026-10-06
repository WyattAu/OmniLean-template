# OmniLean-template

Maximalist **Lean 4** template: Lake, pinned toolchain (`lean-toolchain`),
**kernel-checked theorems** as first-class gates, `lean-action` CI with
upstream caching, mathlib behind a documented toggle — nix flake + dual
devcontainers + VS Code. Part of the
[WyattAu Omni template family](https://github.com/WyattAu?tab=repositories&q=omni-).

## Start here (after "Use this template")

1. Rename `omni-lean` / the `Omni` lib root in `lakefile.toml`.
2. Pick a door — all resolve to the pinned toolchain:

   | Door | Command |
   |---|---|
   | nix + direnv (host) | `direnv allow` |
   | Devcontainer (image) | VS Code → *Reopen in Container* (leanprover image) |
   | Devcontainer (nix)  | palette → *Rebuild in Container* → pick `.devcontainer/nix/` |

   No nix, no docker? `./scripts/bootstrap.sh` prints the manual path.
3. `lake build && lake exe test` — must be green before your first push.

## Make targets

| Target | Gate |
|---|---|
| `make build` | `lake build` — kernel checks every proof |
| `make test` | `lake exe test` — runtime assertions |
| `make contract` | Omni Core Contract structural checks |
| `make ci` | contract + build + test |

## What is inside

```
lean-toolchain        THE version pin (elan reads it; CI matches)
lakefile.toml         lib (globbed Omni/) + test exe
Omni/Basic.lean       L0 pattern: total defs + kernel-checked theorems (REQ-tagged)
Test.lean             assertion runner (lake exe test)
scripts/ + Makefile   the gates (make ci == CI)
docs/adr/             decision log (lake layout, mathlib toggle)
.github/workflows/    ci (lean-action + bitrot cron), devcontainers
.forgejo/             thin self-hosted mirror (scripts are canonical)
```

## Mathlib toggle (ADR-0001)

1. `lakefile.toml`: add `[[require]] name = "mathlib"` with a pinned `git`
   + `rev`.
2. CI: set the `lean-action` input `mathlib: true` (reservoir cache).
3. First build after the toggle downloads cached oleans — budget time.

## Estate pointers

- Gates, policies: [engineering-standards](https://github.com/WyattAu/engineering-standards)
- Omni Core Contract: [OMNI-CORE.md](https://github.com/WyattAu/engineering-standards/blob/main/OMNI-CORE.md)

## License

Apache-2.0 — commercial use expressly permitted.


## Performance budgets

Performance is a gate, not a hope. `make bench` measures, writes
`bench/current.tsv`, and compares it against the committed
`bench/baseline.tsv`; anything more than the threshold worse fails. The
comparator (`scripts/compare-bench.py`) is identical across the whole Omni
estate, so the policy is auditable in one place.

| Verb | What it does |
|---|---|
| `make bench` | measure + compare (advisory job in CI: `perf`) |
| `make bench-update` | deliberately re-baseline; the only way a baseline moves |

The first run on a fresh clone records the baseline instead of failing, so the
gate is meaningful from the second run onwards. Override the budget per run
with `OMNI_BENCH_THRESHOLD_PCT=15 make bench`. Rationale and per-template
metrics: `docs/adr/0004-performance-budget-gate.md`.


## Determinism

`make repro` builds twice from a clean state with a pinned `SOURCE_DATE_EPOCH`
and compares artifact hashes. Toolchains that are deterministic gate the build;
toolchains that embed timestamps or build ids by design report the difference
and explain why, rather than pretending to be reproducible. Rationale and the
per-toolchain split: `docs/adr/0005-determinism-verification.md`.
