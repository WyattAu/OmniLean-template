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
