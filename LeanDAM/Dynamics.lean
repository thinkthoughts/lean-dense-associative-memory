import LeanDAM.Basic

namespace LeanDAM

variable {State : Type*}

/-- State reached after `n` iterations of `F`, beginning at `x`. -/
def orbit (F : Update State) (x : State) : ℕ → State
  | 0 => x
  | n + 1 => F (orbit F x n)

@[simp] theorem orbit_zero (F : Update State) (x : State) :
    orbit F x 0 = x := rfl

@[simp] theorem orbit_succ (F : Update State) (x : State) (n : ℕ) :
    orbit F x (n + 1) = F (orbit F x n) := rfl

end LeanDAM
