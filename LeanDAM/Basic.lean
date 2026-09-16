namespace LeanDAM

variable {State : Type*}

/-- A deterministic one-step update on a state space. -/
abbrev Update (State : Type*) := State → State

/-- A state is fixed by an update if one update returns the same state. -/
def IsFixedPoint (F : Update State) (x : State) : Prop :=
  F x = x

end LeanDAM
