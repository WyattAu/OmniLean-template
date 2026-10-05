/-!
# Omni.Core

The L0 pattern made concrete for Lean: total definitions (returning
`Option` instead of partial functions) with machine-checked properties
tagged to REQUIREMENTS.md at the repo root.
-/

namespace Omni

/-- REQ-001: total head — `none` on the empty list, never partial. -/
def safeHead : List α → Option α
  | [] => none
  | x :: _ => some x

/-- REQ-002: clamp `lo ≤ x ≤ hi`. Documented (not hidden) behavior when
`lo > hi`: returns `lo`. -/
def clamp (lo hi : Nat) (x : Nat) : Nat :=
  if lo > hi then lo else max lo (min hi x)

/-- REQ-001: `safeHead` agrees with `List.head` exactly on non-empty lists.
The kernel checks this proof on every build — the property cannot rot. -/
theorem safeHead_eq_head {xs : List α} (h : xs ≠ []) :
    safeHead xs = some (xs.head h) := by
  cases xs with
  | nil => exact absurd rfl h
  | cons x _ => rfl

end Omni
