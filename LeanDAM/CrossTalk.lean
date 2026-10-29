import LeanDAM.Capacity

/-!
# CP6c.1 — Exact conditional mean-zero cross-talk

Reading point: Krotov–Hopfield (arXiv:1606.01164v2), p. 2. The paper states that
the one-flip energy difference `ΔE` "has a mean `⟨ΔE⟩ = Nⁿ − (N−2)ⁿ`, which comes
from the term with `ν = μ`". By the exact decomposition
`flipEnergyGap_signal_noise_decomposition`, that claim is equivalent to the
cross-talk (`noiseTerm`) contribution having mean zero. This file proves the
mean-zero statement exactly, for every finite `N`, `K`, `n`, conditioned on the
target pattern.

## Model

* Sample space: `Omega Memory Neuron = Memory → Neuron → Bool` with the uniform
  law `uniformSamples`; patterns `patternsOf ω = toPM ∘ ω`.
* Conditioning on the target pattern `ξ^μ` is conditioning on the fiber
  `{ω | ω μ = t}` for a fixed `t : Neuron → Bool`. Under the uniform law the
  conditional expectation is the average over that fiber, written here as the
  finite sum `condMeanGivenTarget`.

## Symmetry

For `ν ≠ μ`, `toggleAt ν i` negates the single Boolean coordinate `(ν, i)`.
It is an involution, it preserves every target fiber, and it reverses the
`ν`-th cross-talk summand

  `F(a + b) − F(−a + b)`,   `a = ξᵢ^ν ξᵢ^μ`,  `b = Σ_{j ≠ i} ξⱼ^ν ξⱼ^μ`,

because it sends `a ↦ −a` and fixes `b`. The reversal holds for an arbitrary
separation function `F : ℝ → ℝ`: it requires neither oddness, smoothness nor a
polynomial form. It therefore covers the repository's `polyF n = xⁿ` (the paper's
"polynomial energy function") and equally the paper's rectified polynomial,
Eq. (3).

## Scope

Mean zero says nothing about the variance of the cross-talk (CP6c.3) or the
probability of a retrieval error (CP6c.4). The expected full gap (CP6c.2) is a
separate corollary.
-/

namespace LeanDAM

/-! ### Coordinate lemmas -/

/-- An overlap splits into the `i`-th term and the sum over the other neurons. -/
lemma overlap_split
    {Neuron Memory : Type}
    [Fintype Neuron]
    [DecidableEq Neuron]
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (ν : Memory)
    (i : Neuron) :
    overlap ξ σ ν =
      ξ ν i * σ i + ∑ j ∈ Finset.univ.erase i, ξ ν j * σ j := by
  unfold overlap
  exact (Finset.add_sum_erase Finset.univ (fun j => ξ ν j * σ j)
    (Finset.mem_univ i)).symm

/-- Flipping neuron `i` negates coordinate `i`. -/
lemma flip_self_coord
    {Neuron : Type}
    [DecidableEq Neuron]
    (σ : State Neuron)
    (i : Neuron) :
    flip σ i i = -σ i := by
  unfold flip
  simp

/-- Flipping neuron `i` leaves every other coordinate unchanged. -/
lemma flip_other_coord
    {Neuron : Type}
    [DecidableEq Neuron]
    (σ : State Neuron)
    {i j : Neuron}
    (h : j ≠ i) :
    flip σ i j = σ j := by
  unfold flip
  simp [Function.update, h]

/-- Negating a Boolean negates its spin value. -/
lemma toPM_not (b : Bool) : toPM (!b) = -toPM b := by
  cases b <;> simp [toPM]

/-! ### Cross-talk for an arbitrary separation function -/

/--
The `ν`-th cross-talk summand of the one-flip energy gap at stored memory `μ`
and neuron `i`, for an arbitrary separation function `F`.
-/
def crossSummand
    {Neuron Memory : Type}
    [Fintype Neuron]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (μ ν : Memory)
    (i : Neuron) : ℝ :=
  F (overlap ξ (patternState ξ μ) ν) -
    F (overlap ξ (flip (patternState ξ μ) i) ν)

/-- The full cross-talk: the sum of `crossSummand` over all memories `ν ≠ μ`. -/
def crossTalk
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    [DecidableEq Memory]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (i : Neuron) : ℝ :=
  ∑ ν ∈ Finset.univ.erase μ, crossSummand F ξ μ ν i

/-- The existing `noiseTerm` is the cross-talk for `polyF n`. -/
theorem noiseTerm_eq_crossTalk
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    [DecidableEq Memory]
    (n : ℕ)
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (i : Neuron) :
    noiseTerm n ξ μ i = crossTalk (polyF n) ξ μ i :=
  rfl

/--
**Symmetry lemma.** Suppose `ξ'` agrees with `ξ` on the target pattern `μ`,
negates coordinate `i` of pattern `ν`, and agrees with `ξ` on every other
coordinate of pattern `ν`. Then the `ν`-th cross-talk summand is reversed,
for every separation function `F`.
-/
theorem crossSummand_neg_of_coord_negation
    {Neuron Memory : Type}
    [Fintype Neuron]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ ξ' : Patterns Memory Neuron)
    {μ ν : Memory}
    (i : Neuron)
    (hμ : ξ' μ = ξ μ)
    (hνi : ξ' ν i = -ξ ν i)
    (hνj : ∀ j, j ≠ i → ξ' ν j = ξ ν j) :
    crossSummand F ξ' μ ν i = -crossSummand F ξ μ ν i := by
  have hS : ∀ σ : State Neuron,
      overlap ξ' σ ν =
        -(ξ ν i * σ i) + ∑ j ∈ Finset.univ.erase i, ξ ν j * σ j := by
    intro σ
    rw [overlap_split ξ' σ ν i, hνi]
    congr 1
    · ring
    · apply Finset.sum_congr rfl
      intro j hj
      rw [hνj j (Finset.ne_of_mem_erase hj)]
  have hPS : patternState ξ' μ = patternState ξ μ := by
    unfold patternState
    exact hμ
  have hB :
      ∑ j ∈ Finset.univ.erase i, ξ ν j * flip (patternState ξ μ) i j =
        ∑ j ∈ Finset.univ.erase i, ξ ν j * patternState ξ μ j := by
    apply Finset.sum_congr rfl
    intro j hj
    rw [flip_other_coord _ (Finset.ne_of_mem_erase hj)]
  unfold crossSummand
  rw [hPS, hS, hS,
    overlap_split ξ (patternState ξ μ) ν i,
    overlap_split ξ (flip (patternState ξ μ) i) ν i,
    hB, flip_self_coord]
  simp only [mul_neg, neg_neg]
  ring

/-! ### The involution on Boolean samples -/

/-- Negate the single Boolean coordinate `(ν, i)` of a sample. -/
def toggleAt
    {Memory Neuron : Type}
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (ν : Memory)
    (i : Neuron)
    (ω : Omega Memory Neuron) : Omega Memory Neuron :=
  fun ν' j => if ν' = ν ∧ j = i then !(ω ν' j) else ω ν' j

/-- `toggleAt ν i` is an involution. -/
theorem toggleAt_toggleAt
    {Memory Neuron : Type}
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (ν : Memory)
    (i : Neuron)
    (ω : Omega Memory Neuron) :
    toggleAt ν i (toggleAt ν i ω) = ω := by
  funext ν' j
  by_cases h : ν' = ν ∧ j = i
  · simp [toggleAt, h]
  · simp [toggleAt, h]

/-- `toggleAt ν i` as a permutation of the sample space. -/
def toggleEquiv
    {Memory Neuron : Type}
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (ν : Memory)
    (i : Neuron) : Omega Memory Neuron ≃ Omega Memory Neuron where
  toFun := toggleAt ν i
  invFun := toggleAt ν i
  left_inv := toggleAt_toggleAt ν i
  right_inv := toggleAt_toggleAt ν i

/-- Toggling a coordinate of pattern `ν ≠ μ` leaves the target pattern fixed. -/
theorem toggleAt_target
    {Memory Neuron : Type}
    [DecidableEq Memory]
    [DecidableEq Neuron]
    {μ ν : Memory}
    (hνμ : ν ≠ μ)
    (i : Neuron)
    (ω : Omega Memory Neuron) :
    toggleAt ν i ω μ = ω μ := by
  funext j
  simp [toggleAt, Ne.symm hνμ]

/--
The involution reverses the `ν`-th cross-talk summand of the induced patterns,
for every separation function `F` and every `ν ≠ μ`.
-/
theorem crossSummand_toggleAt
    {Memory Neuron : Type}
    [Fintype Neuron]
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ω : Omega Memory Neuron)
    {μ ν : Memory}
    (hνμ : ν ≠ μ)
    (i : Neuron) :
    crossSummand F (patternsOf (toggleAt ν i ω)) μ ν i =
      -crossSummand F (patternsOf ω) μ ν i := by
  apply crossSummand_neg_of_coord_negation
  · funext j
    simp [patternsOf, toggleAt, Ne.symm hνμ]
  · simp [patternsOf, toggleAt, toPM_not]
  · intro j hj
    simp [patternsOf, toggleAt, hj]

/-! ### Conditioning on the target pattern -/

/-- The cross-talk summand restricted to the target fiber `{ω | ω μ = t}`. -/
noncomputable def condCross
    {Memory Neuron : Type}
    [Fintype Neuron]
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (μ ν : Memory)
    (i : Neuron)
    (t : Neuron → Bool)
    (ω : Omega Memory Neuron) : ℝ :=
  if ω μ = t then crossSummand F (patternsOf ω) μ ν i else 0

/--
Summed over a target fiber, each cross-talk summand with `ν ≠ μ` vanishes.
-/
theorem sum_condCross_eq_zero
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (μ ν : Memory)
    (hνμ : ν ≠ μ)
    (i : Neuron)
    (t : Neuron → Bool) :
    ∑ ω : Omega Memory Neuron, condCross F μ ν i t ω = 0 := by
  have hneg : ∀ ω : Omega Memory Neuron,
      condCross F μ ν i t (toggleAt ν i ω) = -condCross F μ ν i t ω := by
    intro ω
    unfold condCross
    simp only [toggleAt_target hνμ i ω, crossSummand_toggleAt F ω hνμ i]
    by_cases h : ω μ = t <;> simp [h]
  have hsum :
      ∑ ω : Omega Memory Neuron, condCross F μ ν i t (toggleAt ν i ω) =
        ∑ ω : Omega Memory Neuron, condCross F μ ν i t ω :=
    Equiv.sum_comp (toggleEquiv ν i) (condCross F μ ν i t)
  simp_rw [hneg] at hsum
  rw [Finset.sum_neg_distrib] at hsum
  linarith

/--
**Fiber sum of cross-talk.** For every separation function `F`, every target
memory `μ`, neuron `i` and target pattern `t`, the cross-talk summed over the
samples whose target pattern is `t` is zero.
-/
theorem sum_cond_crossTalk_eq_zero
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (μ : Memory)
    (i : Neuron)
    (t : Neuron → Bool) :
    ∑ ω : Omega Memory Neuron,
        (if ω μ = t then crossTalk F (patternsOf ω) μ i else 0) = 0 := by
  have h : ∀ ω : Omega Memory Neuron,
      (if ω μ = t then crossTalk F (patternsOf ω) μ i else 0) =
        ∑ ν ∈ Finset.univ.erase μ, condCross F μ ν i t ω := by
    intro ω
    unfold condCross crossTalk
    by_cases hω : ω μ = t <;> simp [hω]
  rw [Finset.sum_congr rfl (fun ω _ => h ω), Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro ν hν
  exact sum_condCross_eq_zero F μ ν (Finset.ne_of_mem_erase hν) i t

/--
Conditional expectation of `X` given target pattern `t`, under the uniform
law on `Omega`: the average of `X` over the fiber `{ω | ω μ = t}`.
-/
noncomputable def condMeanGivenTarget
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (t : Neuron → Bool)
    (X : Omega Memory Neuron → ℝ) : ℝ :=
  (∑ ω : Omega Memory Neuron, if ω μ = t then X ω else 0) /
    (Fintype.card {ω : Omega Memory Neuron // ω μ = t} : ℝ)

/-- Every target fiber is nonempty, so `condMeanGivenTarget` is a genuine average. -/
theorem targetFiber_card_pos
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (t : Neuron → Bool) :
    0 < Fintype.card {ω : Omega Memory Neuron // ω μ = t} :=
  Fintype.card_pos_iff.mpr ⟨⟨fun _ => t, rfl⟩⟩

/--
**CP6c.1 — Exact conditional mean-zero cross-talk.** Under the uniform ±1
pattern law, conditioned on any target pattern `ξ^μ = toPM ∘ t`, the cross-talk
`noiseTerm n` of the one-flip energy gap has mean exactly zero, for every
finite number of neurons and memories and every power `n`.
-/
theorem condMean_noiseTerm_eq_zero
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (n : ℕ)
    (μ : Memory)
    (i : Neuron)
    (t : Neuron → Bool) :
    condMeanGivenTarget μ t
        (fun ω => noiseTerm n (patternsOf ω) μ i) = 0 := by
  unfold condMeanGivenTarget
  simp only [noiseTerm_eq_crossTalk, sum_cond_crossTalk_eq_zero, zero_div]

/--
The same conditional mean-zero statement for an arbitrary separation function,
including the paper's rectified polynomial (Eq. 3).
-/
theorem condMean_crossTalk_eq_zero
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    [DecidableEq Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (μ : Memory)
    (i : Neuron)
    (t : Neuron → Bool) :
    condMeanGivenTarget μ t
        (fun ω => crossTalk F (patternsOf ω) μ i) = 0 := by
  unfold condMeanGivenTarget
  simp only [sum_cond_crossTalk_eq_zero, zero_div]

end LeanDAM
