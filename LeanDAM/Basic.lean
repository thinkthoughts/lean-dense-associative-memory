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

/-- Expands a squared overlap into a double sum over neuron indices. -/
private lemma overlap_sq_expand
    {Neuron Memory : Type}
    [Fintype Neuron]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (μ : Memory) :
    (overlap ξ σ μ) ^ 2 =
      ∑ i, ∑ j, (ξ μ i * σ i) * (ξ μ j * σ j) := by
  unfold overlap
  rw [sq, Finset.sum_mul_sum]

/-- Moves the memory sum inward, past both neuron sums. -/
private lemma swap_memory_to_inner
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    (f : Memory → Neuron → Neuron → ℝ) :
    ∑ μ, ∑ i, ∑ j, f μ i j =
      ∑ i, ∑ j, ∑ μ, f μ i j := by
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.sum_comm]

/-- Factors the memory sum into `interaction`, pulling the two state terms out. -/
private lemma factor_interaction
    {Neuron Memory : Type}
    [Fintype Memory]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (i j : Neuron) :
    ∑ μ, (ξ μ i * σ i) * (ξ μ j * σ j) =
      σ i * interaction ξ i j * σ j := by
  have h : ∀ μ,
      (ξ μ i * σ i) * (ξ μ j * σ j) =
        σ i * σ j * (ξ μ i * ξ μ j) := by
    intro μ
    ring
  simp_rw [h]
  rw [← Finset.mul_sum]
  unfold interaction
  ring

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
  rw [energy_quadratic, neg_inj]
  calc
    ∑ μ, (overlap ξ σ μ) ^ 2
        = ∑ μ, ∑ i, ∑ j, (ξ μ i * σ i) * (ξ μ j * σ j) := by
          simp_rw [overlap_sq_expand]
    _ = ∑ i, ∑ j, ∑ μ, (ξ μ i * σ i) * (ξ μ j * σ j) :=
          swap_memory_to_inner
            (fun μ i j => (ξ μ i * σ i) * (ξ μ j * σ j))
    _ = ∑ i, ∑ j, σ i * interaction ξ i j * σ j := by
          simp_rw [factor_interaction]

end LeanDAM
