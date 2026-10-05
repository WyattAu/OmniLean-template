/-! Executable test runner — `lake exe test`. Assertions here are checked
by the compiler + runtime on every CI run. -/

import Omni

open Omni

def main : IO Unit := do
  -- REQ-001: total head, positive case
  assert! (safeHead [1, 2, 3] == some 1)
  -- REQ-001: empty case returns none instead of crashing
  assert! (safeHead (α := Nat) [] == none)
  -- REQ-002: clamp bounds
  assert! (clamp 0 10 5 == 5)
  assert! (clamp 0 10 99 == 10)
  IO.println "omni-lean: all checks passed"
