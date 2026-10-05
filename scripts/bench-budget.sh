#!/usr/bin/env bash
# Perf budget gate: measure, emit bench/current.tsv, compare to the committed
# baseline with the shared comparator. `make bench-update` re-baselines
# deliberately - it is the only way a baseline moves.
set -euo pipefail
cd "$(dirname "$0")/.."
BASELINE=bench/baseline.tsv
CURRENT=bench/current.tsv
THRESHOLD_PCT="${OMNI_BENCH_THRESHOLD_PCT:-25}"
UPDATE=()
[ "${1:-}" = "--update" ] && UPDATE=(--update)
mkdir -p bench

# Lean has no runtime hot path. Two measurements:
#   * `.olean` bytes - exact, and a real proxy for proof bulk (how much proof
#     the kernel has to carry). Gated at 5%.
#   * `lake build` wall time - what a contributor waits for, but far too noisy
#     on a shared runner to gate, so it is reported.
now_ms() {
  python3 -c 'import time; print(int(time.time() * 1000))'
}


rm -rf .lake/build
start="$(now_ms)"
lake build >/dev/null
end="$(now_ms)"

olean_bytes="$(python3 -c 'import pathlib; print(sum(p.stat().st_size for p in pathlib.Path(".lake/build").rglob("*.olean")))')"
[ "$olean_bytes" -gt 0 ] || {
  echo "bench: no .olean files under .lake/build - did lake build run?" >&2
  exit 1
}

printf 'olean-bytes\t%s\tbytes\tgate\nlake-build-ms\t%s\tms\tinfo\n' \
  "$olean_bytes" "$((end - start))" > "$CURRENT"

python3 scripts/compare-bench.py "$BASELINE" "$CURRENT" \
  --threshold-pct "$THRESHOLD_PCT" "${UPDATE[@]+"${UPDATE[@]}"}"
