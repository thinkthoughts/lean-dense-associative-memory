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

/-- A state confined to the spin values {-1, 1}. -/
def IsSpinState {Neuron : Type} (σ : State Neuron) : Prop :=
  ∀ i, σ i = 1 ∨ σ i = -1

/-- The state obtained from `σ` by setting neuron `i` to `1`. -/
def candidatePos {Neuron : Type} [DecidableEq Neuron]
    (σ : State Neuron) (i : Neuron) : State Neuron :=
  Function.update σ i 1

/-- The state obtained from `σ` by setting neuron `i` to `-1`. -/
def candidateNeg {Neuron : Type} [DecidableEq Neuron]
    (σ : State Neuron) (i : Neuron) : State Neuron :=
  Function.update σ i (-1)

/-- Asynchronous energy-minimizing update at neuron `i`. -/
noncomputable def stepAt
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (i : Neuron) : State Neuron :=
  if energy F ξ (candidatePos σ i) ≤ energy F ξ (candidateNeg σ i)
  then candidatePos σ i
  else candidateNeg σ i

/--
A source-specific asynchronous update cannot increase the energy
of a binary spin state.
-/
theorem energy_stepAt_le
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (i : Neuron)
    (hσ : IsSpinState σ) :
    energy F ξ (stepAt F ξ σ i) ≤ energy F ξ σ := by
  rcases hσ i with hpos | hneg
  · have hσ_eq : candidatePos σ i = σ := by
      unfold candidatePos
      rw [← hpos]
      exact Function.update_eq_self i σ
    unfold stepAt
    split_ifs with h
    · simp [hσ_eq]
    · have hlt :
          energy F ξ (candidateNeg σ i) <
            energy F ξ (candidatePos σ i) :=
        lt_of_not_ge h
      rw [hσ_eq] at hlt
      exact le_of_lt hlt
  · have hσ_eq : candidateNeg σ i = σ := by
      unfold candidateNeg
      rw [← hneg]
      exact Function.update_eq_self i σ
    unfold stepAt
    split_ifs with h
    · rw [hσ_eq] at h
      exact h
    · simp [hσ_eq]

/-- A single asynchronous update preserves the binary spin-state constraint. -/
theorem stepAt_isSpinState
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (i : Neuron)
    (hσ : IsSpinState σ) :
    IsSpinState (stepAt F ξ σ i) := by
  unfold stepAt
  split_ifs
  · intro j
    by_cases hj : j = i
    · subst j
      left
      simp [candidatePos]
    · simpa [candidatePos, Function.update, hj] using hσ j
  · intro j
    by_cases hj : j = i
    · subst j
      right
      simp [candidateNeg]
    · simpa [candidateNeg, Function.update, hj] using hσ j
/--
The overlap contribution from all neurons except `i`.

This is the clamped contribution appearing in the source's
asynchronous update equation.
-/
def clampedOverlap
    {Neuron Memory : Type}
    [Fintype Neuron]
    [DecidableEq Neuron]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (μ : Memory)
    (i : Neuron) : ℝ :=
  ∑ j ∈ Finset.univ.erase i, ξ μ j * σ j

/--
The energy-comparison expression appearing inside the sign
in Krotov–Hopfield Eq. (4).
-/
def updateGap
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (i : Neuron) : ℝ :=
  ∑ μ,
    (F (ξ μ i + clampedOverlap ξ σ μ i) -
     F (-ξ μ i + clampedOverlap ξ σ μ i))

/--
Replacing neuron `i` by `+1` gives the overlap appearing in
the positive candidate of Eq. (4).
-/
lemma overlap_candidatePos
    {Neuron Memory : Type}
    [Fintype Neuron]
    [DecidableEq Neuron]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (μ : Memory)
    (i : Neuron) :
    overlap ξ (candidatePos σ i) μ =
      ξ μ i + clampedOverlap ξ σ μ i := by
  unfold overlap candidatePos clampedOverlap
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i)]
  congr 1
  · simp
  · apply Finset.sum_congr rfl
    intro j hj
    have hji : j ≠ i := by
      simpa using hj
    simp [Function.update, hji]

/--
Replacing neuron `i` by `-1` gives the overlap appearing in
the negative candidate of Eq. (4).
-/
lemma overlap_candidateNeg
    {Neuron Memory : Type}
    [Fintype Neuron]
    [DecidableEq Neuron]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (μ : Memory)
    (i : Neuron) :
    overlap ξ (candidateNeg σ i) μ =
      -ξ μ i + clampedOverlap ξ σ μ i := by
  unfold overlap candidateNeg clampedOverlap
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i)]
  congr 1
  · simp
  · apply Finset.sum_congr rfl
    intro j hj
    have hji : j ≠ i := by
      simpa using hj
    simp [Function.update, hji]

/--
Krotov–Hopfield Eq. (4)'s comparison quantity is exactly the
energy difference between the negative and positive candidate states.
-/
theorem updateGap_eq_energy_difference
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (i : Neuron) :
    updateGap F ξ σ i =
      energy F ξ (candidateNeg σ i) -
        energy F ξ (candidatePos σ i) := by
  unfold updateGap energy
  simp_rw [overlap_candidatePos, overlap_candidateNeg]
  rw [Finset.sum_sub_distrib]
  ring

end LeanDAM
