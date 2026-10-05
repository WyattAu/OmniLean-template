#!/usr/bin/env bash
# Non-nix fallback. Canonical env: flake.nix (lean4 + elan) or devcontainers.
set -euo pipefail
cat <<'MSG'
Manual toolchain (no nix):
  1. elan (https://lean-lang.org/lean4/doc/setup.html) — the repo's
     lean-toolchain file pins the exact Lean version automatically.
  2. lake build && lake exe test
Prefer zero setup? Open the repo in a devcontainer, or `nix develop`.
MSG
