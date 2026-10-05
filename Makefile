# Thin wrapper — the same verbs in every Omni template. Lake is canonical;
# these targets keep the cross-language verbs identical.
.PHONY: build test contract ci clean

build:
	lake build

test:
	lake exe test

contract:
	./scripts/check-contract.sh

## What CI gates before merge (mirror of .github/workflows/ci.yml):
ci: contract build test

clean:
	rm -rf .lake build
