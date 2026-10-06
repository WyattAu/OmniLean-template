# Thin wrapper — the same verbs in every Omni template. Lake is canonical;
# these targets keep the cross-language verbs identical.
.PHONY: bench bench-update repro build test contract ci clean

build:
	lake build

test:
	lake exe test

contract:
	./scripts/check-contract.sh

## What CI gates before merge (mirror of .github/workflows/ci.yml):
ci: contract build test

repro:
	./scripts/repro-check.sh

bench:
	./scripts/bench-budget.sh

bench-update:
	./scripts/bench-budget.sh --update

clean:
	rm -rf .lake build
