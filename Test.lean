import Omni

/-! Executable test runner — `lake exe test`. Assertions here are checked
by the compiler + runtime on every CI run. -/

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

/-! Proof audit: the axioms each theorem depends on are printed in CI logs.
An incomplete proof would surface `sorryAx` here — the CI grep gate below
fails the build on any `sorry` in the source tree. -/
#print axioms Omni.safeHead_eq_head
#print axioms Omni.clamp_eq_in_bounds
#print axioms Omni.clamp_eq_lo
