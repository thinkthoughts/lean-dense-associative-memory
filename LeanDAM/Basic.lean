import Mathlib

namespace LeanDAM

/-- A network state indexed by neurons. -/
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

end LeanDAM
