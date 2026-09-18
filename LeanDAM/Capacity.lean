import LeanDAM.Basic

namespace LeanDAM

/-- Polynomial separation function `F(x) = x^n`. -/
def polyF (n : ℕ) : Separation :=
  fun x => x ^ n

/-- State obtained by negating coordinate `i`. -/
def flip
    {Neuron : Type}
    [DecidableEq Neuron]
    (σ : State Neuron)
    (i : Neuron) : State Neuron :=
  Function.update σ i (-σ i)

/--
Energy change produced by flipping neuron `i`.

At a stored memory and for polynomial separation, this is the
deterministic energy difference used in the paper's stability analysis.
-/
def flipEnergyGap
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (i : Neuron) : ℝ :=
  energy F ξ (flip σ i) - energy F ξ σ

/--
At a stored memory, the flip-energy gap for polynomial separation
is the difference between the current-overlap power sum and the
flipped-overlap power sum.
-/
theorem flipEnergyGap_stored_memory
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (n : ℕ)
    (ξ : Patterns Memory Neuron)
    (μ₀ : Memory)
    (i : Neuron) :
    flipEnergyGap (polyF n) ξ (patternState ξ μ₀) i =
      (∑ ν, (overlap ξ (patternState ξ μ₀) ν) ^ n) -
      (∑ ν, (overlap ξ
        (flip (patternState ξ μ₀) i) ν) ^ n) := by
  unfold flipEnergyGap energy polyF
  ring

end LeanDAM
