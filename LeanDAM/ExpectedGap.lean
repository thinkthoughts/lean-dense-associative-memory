import LeanDAM.CrossTalk

/-!
# CP6c.2 — Exact expected one-flip energy gap

Reading point: Krotov–Hopfield (arXiv:1606.01164v2), p. 2: the one-flip energy
difference `ΔE` "has a mean `⟨ΔE⟩ = Nⁿ − (N−2)ⁿ`, which comes from the term with
`ν = μ`". The paper follows this with the large-`N` approximation `≈ 2nNⁿ⁻¹`; only
the exact equality is proved here.

## Statement

For the polynomial separation function `polyF n = xⁿ`, conditioned on any target
pattern `ξ^μ = toPM ∘ t` under the uniform ±1 law,

  `E[ΔE_i^μ | ξ^μ] = Nⁿ − (N − 2)ⁿ`,   `N = Fintype.card Neuron`,

exactly, for every finite `N`, every finite number of memories and every `n`.

## Argument

1. `flipEnergyGap_signal_noise_decomposition` holds pointwise, at every sample,
   because every `patternsOf ω` is binary (`areBinaryPatterns_patternsOf`).
2. The signal is the same real number at every sample, and the average of a
   constant over a nonempty target fiber is that constant (`condMean_const`).
3. The cross-talk sums to zero over the fiber (CP6c.1).
4. Finite-sum linearity combines 1–3.

## Conventions

* `N − 2` is formed in `ℝ` as `(N : ℝ) − 2`, so `N < 2` causes no truncation.
* The existence of a neuron `i` and a memory `μ` forces `N ≥ 1` and `K ≥ 1`;
  no further size hypothesis appears.
* The formula `Nⁿ − (N−2)ⁿ` is specific to `polyF n`. CP6c.1's mean-zero result
  holds for every `F`, but the signal term depends on the polynomial convention,
  so this theorem is stated for `polyF n` only.
* Scope: no variance, tail-probability or capacity statement (CP6c.3–CP6c.5).
-/

namespace LeanDAM

/--
The exact deterministic one-flip signal `Nⁿ − (N − 2)ⁿ`, with `N` cast to `ℝ`
before the subtraction.
-/
noncomputable def oneFlipSignal (N n : ℕ) : ℝ :=
  (N : ℝ) ^ n - ((N : ℝ) - 2) ^ n

/-- The target-fiber cardinality is nonzero as a real number. -/
lemma targetFiber_card_ne_zero
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (t : Neuron → Bool) :
    (Fintype.card {ω : Omega Memory Neuron // ω μ = t} : ℝ) ≠ 0 :=
  Nat.cast_ne_zero.mpr (targetFiber_card_pos μ t).ne'

/-- Summing a constant over a target fiber gives the fiber size times the constant. -/
lemma sum_targetFiber_const
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (t : Neuron → Bool)
    (c : ℝ) :
    (∑ ω : Omega Memory Neuron, if ω μ = t then c else 0) =
      (Fintype.card {ω : Omega Memory Neuron // ω μ = t} : ℝ) * c := by
  rw [Fintype.card_subtype, ← Finset.sum_filter, Finset.sum_const, nsmul_eq_mul]

/-- The conditional average of a constant over a target fiber is that constant. -/
theorem condMean_const
    {Memory Neuron : Type}
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (t : Neuron → Bool)
    (c : ℝ) :
    condMeanGivenTarget μ t (fun _ => c) = c := by
  show (∑ ω : Omega Memory Neuron, if ω μ = t then c else 0) /
      (Fintype.card {ω : Omega Memory Neuron // ω μ = t} : ℝ) = c
  rw [sum_targetFiber_const, div_eq_iff (targetFiber_card_ne_zero μ t)]
  ring

/--
**CP6c.2 — Exact expected one-flip energy gap.** Under the uniform ±1 pattern law,
conditioned on any target pattern `ξ^μ = toPM ∘ t`, the one-flip energy gap of the
polynomial DAM at the stored memory has conditional mean exactly
`Nⁿ − (N − 2)ⁿ`, with `N` the number of neurons.
-/
theorem condMean_flipEnergyGap_eq_signal
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
        (fun ω => flipEnergyGap (polyF n) (patternsOf ω)
          (patternState (patternsOf ω) μ) i) =
      oneFlipSignal (Fintype.card Neuron) n := by
  unfold oneFlipSignal
  show (∑ ω : Omega Memory Neuron,
      if ω μ = t then
        flipEnergyGap (polyF n) (patternsOf ω) (patternState (patternsOf ω) μ) i
      else 0) /
      (Fintype.card {ω : Omega Memory Neuron // ω μ = t} : ℝ) =
    (Fintype.card Neuron : ℝ) ^ n - ((Fintype.card Neuron : ℝ) - 2) ^ n
  have hpt : ∀ ω : Omega Memory Neuron,
      (if ω μ = t then
        flipEnergyGap (polyF n) (patternsOf ω) (patternState (patternsOf ω) μ) i
      else 0) =
      (if ω μ = t then
        (Fintype.card Neuron : ℝ) ^ n - ((Fintype.card Neuron : ℝ) - 2) ^ n
      else 0) +
      (if ω μ = t then noiseTerm n (patternsOf ω) μ i else 0) := by
    intro ω
    rw [flipEnergyGap_signal_noise_decomposition n (patternsOf ω) μ i
      (areBinaryPatterns_patternsOf ω μ)]
    by_cases h : ω μ = t <;> simp [h]
  have hnoise :
      (∑ ω : Omega Memory Neuron,
        if ω μ = t then noiseTerm n (patternsOf ω) μ i else 0) = 0 :=
    sum_cond_crossTalk_eq_zero (polyF n) μ i t
  rw [Finset.sum_congr rfl (fun ω _ => hpt ω), Finset.sum_add_distrib,
    sum_targetFiber_const, hnoise, add_zero,
    div_eq_iff (targetFiber_card_ne_zero μ t)]
  ring

end LeanDAM
