#!/usr/bin/env bash
# Bootstrap elan + the repo's pinned toolchain (lean-toolchain), then build.
set -euo pipefail
if command -v lake >/dev/null 2>&1; then
  echo "elan already present"; exit 0
fi
curl -sSfL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none
export PATH="$HOME/.elan/bin:$PATH"
echo 'export PATH="$HOME/.elan/bin:$PATH"' >> ~/.bashrc
lake update
lake build
lake exe test
