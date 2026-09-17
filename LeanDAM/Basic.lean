import Mathlib

namespace LeanDAM

/--
A network state indexed by neurons.

For CP2–CP4 the state is real-valued. Restrictions such as
`σᵢ ∈ {−1, 1}` belong to later source-specific dynamics,
stability, and capacity specifications.
-/
abbrev State (Neuron : Type) := Neuron → ℝ

/-- A collection of stored patterns indexed by memories and neurons. -/
abbrev Patterns (Memory Neuron : Type) := Memory → Neuron → ℝ

/-- The overlap of state `σ` with stored pattern `μ`. -/
def overlap
    {Neuron Memory : Type}
    [Fintype Neuron]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (μ : Memory) : ℝ :=
  ∑ i, ξ μ i * σ i

/-- A separation function used to define a dense associative memory energy. -/
abbrev Separation := ℝ → ℝ

/-- Generalized dense associative memory energy. -/
def energy
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron) : ℝ :=
  -∑ μ, F (overlap ξ σ μ)

/-- Quadratic separation function. -/
def quadratic : Separation :=
  fun x => x ^ 2

/--
Quadratic separation specializes the generalized DAM energy
to the quadratic energy expressed through pattern overlaps.
-/
theorem energy_quadratic
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron) :
    energy quadratic ξ σ =
      -∑ μ, (overlap ξ σ μ) ^ 2 := rfl

/-- The Hopfield interaction matrix `Tᵢⱼ = Σᵤ ξᵢᵘ ξⱼᵘ`. -/
def interaction
    {Neuron Memory : Type}
    [Fintype Memory]
    (ξ : Patterns Memory Neuron)
    (i j : Neuron) : ℝ :=
  ∑ μ, ξ μ i * ξ μ j

/--
The quadratic DAM energy expands into the Hopfield
interaction-matrix form.
-/
theorem energy_quadratic_interaction
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron) :
    energy quadratic ξ σ =
      -∑ i, ∑ j, σ i * interaction ξ i j * σ j := by
  simp only [energy_quadratic, interaction, sq]
  congr 1
  simp_rw [Finset.sum_mul_sum, Finset.mul_sum]
  rw [Finset.sum_comm]
  congr 1; ext i
  congr 1; ext j
  ring_nf
  rw [Finset.sum_mul, Finset.mul_sum]
  congr 1; ext μ
  ring

end LeanDAM
