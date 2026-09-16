import LeanDAM.Basic
import LeanDAM.Dynamics

namespace LeanDAM

variable {State : Type*}

/-- A fixed point remains fixed after any number of updates. -/
theorem fixedPoint_orbit (F : Update State) (x : State)
    (hx : IsFixedPoint F x) : ∀ n : ℕ, orbit F x n = x := by
  intro n
  induction n with
  | zero => rfl
  | succ n ih =>
      simp [orbit, ih, IsFixedPoint] at *
      exact hx

end LeanDAM
