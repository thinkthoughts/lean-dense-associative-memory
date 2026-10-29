I’ll clone the repository read-only, audit the Lean sources and the `Capacity.lean` discrepancy, try a build, and then compare CP6c against the numerical sign-preservation theorem.

I’ve read every file in the repository at HEAD `f52348e`, the last Lean version of `Capacity.lean`, and the paper’s capacity section. I couldn’t run a build here because this workspace’s network policy blocks the Lean toolchain and Mathlib cache downloads. The integrity finding below comes from the git history, and the “compiled” column reflects source inspection. Section 7 has the commands to confirm everything locally.

### 1. Audit summary

**`Capacity.lean` root cause.** Commit `83aec55` (2026-09-19 18:04, message “Update print statement from ‘Hello’ to ‘Goodbye’”, which reads like a web-editor default) replaced all 577 lines of Lean with 591 lines of HTML. The HTML is the write-up page “Formalizing Dense Associative Memory in Lean”. Commit `dce8375` then edited that HTML in place. The last Lean version is `0077024` (“Refactor simp calls…”). Every capacity declaration is intact in history and recoverable with one `git checkout 0077024 -- LeanDAM/Capacity.lean`. Nothing was moved elsewhere.

**Build status at HEAD.** `DenseAssociativeMemory.lean` imports `LeanDAM.Capacity`, so the default target fails at the first token (`<!doctype`). `LeanDAM.Basic` stands alone and should build. The repo has no CI, which is how this went unnoticed.

**Trust boundary.** `Basic.lean` and `Capacity@0077024` contain zero `sorry` and zero `axiom` declarations. The expected axiom footprint is the standard trio (`propext`, `Classical.choice`, `Quot.sound`), since `Real` and `PMF` are classical. Confirm it with `#print axioms` (section 7).

**Documentation drift.**

- `README.md` describes modules `Energy`, `Dynamics`, `FixedPoint` and a file `SPEC.md`, none of which exist.
- `REPORT.md` is an empty outline.
- `SPECIFICATION.md` cites “CP6b.3”, but CP6b has no numbered subsections.

### 2. Declaration inventory (source of truth: `Basic@HEAD` + `Capacity@0077024`)

| Layer | Declaration                                                                                      | Paper correspondence           | Status                      |
| ----- | ------------------------------------------------------------------------------------------------ | ------------------------------ | --------------------------- |
| CP2   | `overlap`                                                                                        | ξ^μ·σ                          | def                         |
| CP3   | `energy`, `quadratic`, `energy_quadratic`                                                        | Eq. (2)                        | rfl                         |
| CP4   | `interaction`, `energy_quadratic_interaction`                                                    | Eq. (1), up to ½ and diagonal  | proved                      |
| CP5   | `IsSpinState`, `candidatePos/Neg`, `stepAt`                                                      | Eq. (4), ties → +1             | def                         |
| CP5   | `energy_stepAt_le`, `stepAt_isSpinState`                                                         | “energy decreases”             | proved, **for arbitrary F** |
| CP5   | `clampedOverlap`, `updateGap`, `overlap_candidatePos/Neg`, `updateGap_eq_energy_difference`      | Eq. (4) argument = E(−) − E(+) | proved                      |
| CP6a  | `patternState`, `IsBinaryPattern`, `IsStablePattern`                                             | stability                      | def                         |
| CP6a  | `stablePattern_of_candidate_energy`, `stablePattern_of_updateGap`                                | sufficient criterion           | proved                      |
| CP6b  | `polyF`, `flip`, `flipEnergyGap`, `flipEnergyGap_stored_memory`                                  | ΔE definition, p. 2            | proved\*                    |
| CP6b  | `flipEnergyGap_eq_updateGap_of_pos`, `…_eq_neg_updateGap_of_neg`                                 | bridges ΔE ↔ Eq. (4)           | proved\*                    |
| CP6b  | `overlap_self_of_binary` (=N), `overlap_self_flip_of_binary` (=N−2), `self_signal_term`          | Nⁿ − (N−2)ⁿ                    | proved\*                    |
| CP6b  | `noiseTerm`, `flipEnergyGap_signal_noise_decomposition`                                          | exact signal + noise           | proved\*                    |
| CP6c  | `Omega`, `toPM`, `patternsOf`, `areBinaryPatterns_patternsOf`, `uniformSamples`, `coordinatePMF` | random ±1 model                | def/proved\*                |
| CP6c  | `coordinate_true_fiber_card`, `coordinatePMF_true/false`, `patternCoordinate_pm_half`            | Pr(ξ = ±1) = ½                 | proved\*                    |

\* These are in history at `0077024` and absent from HEAD.

The following are source claims only, with no Lean counterpart yet:

- Independence of the pattern components.
- ⟨ΔE⟩ = Nⁿ − (N−2)ⁿ.
- The variance Σ² = Ωₙ(K−1)Nⁿ⁻¹ (large N).
- The Gaussian P_error.
- K_max = αₙNⁿ⁻¹ and Eq. (6).
- The rectified-F case, Eq. (3).

### 3. Mathematical review

**Energy-based update.** The Eq. (4) correspondence is exact. `updateGap` is literally the paper’s Sign argument. The paper notes this differs from field-based updates “due to self-coupling terms”, and the Lean form inherits that energy-based behaviour, so the diagonal issue is handled correctly by construction.

**Descent hypotheses.** `energy_stepAt_le` needs only `IsSpinState σ` and holds for every `F : ℝ → ℝ`. The paper’s “smooth” is unnecessary for descent, which is a small but genuine sharpening worth recording.

**Normalization.** The ½ factor and the i = j terms (which contribute the constant KN on spin states) are correctly tracked in the spec as order-preserving conventions. They matter only for exact coefficient work.

**Tie convention.** Sign(0) is unspecified in the paper. Lean resolves it toward +1, so a stored −1 bit needs a strict gap. The spec records this correctly.

**Fixed point versus local minimum.** `IsStablePattern` (fixed under every `stepAt`) implies one-flip local minimality (ΔE_i ≥ 0 for all i). The converse fails exactly at a −1 bit with ΔE_i = 0. Under `IsBinaryPattern` the CP6a criterion is in fact an iff, but only the sufficient direction is proved. The necessary direction is a cheap, useful addition.

**Random model.** Only one-coordinate marginals are proved, and independence is implicit in the uniform law on `Omega`. A sign-reversing involution over the finite product space avoids needing an explicit independence theorem for the next result (§5).

**Latent fragility.** `omegaFintype := Fintype.ofFinite _` can coexist with Mathlib’s `Pi` instance once `DecidableEq` is available, which can make `rw` on `Fintype.card` fail. Using the `Pi` instance directly under `classical` is safer.

### 4. Ranking and CP7–CP9 roadmap

| Candidate                          | Soundness              | Feasibility | Relevance to DAM hardware | Effort                                       |
| ---------------------------------- | ---------------------- | ----------- | ------------------------- | -------------------------------------------- |
| A. Exact finite probability (CP6c) | high: exact identities | high        | medium-high               | \~150 lines                                  |
| D. Numerical sign/margin (CP8a)    | high                   | very high   | high                      | \~80 lines                                   |
| C. Descent dynamics                | high                   | medium      | medium                    | \~200 lines                                  |
| B. Energy Transformer              | depends on source      | medium-low  | high                      | large; needs RP for Hoover et al. 2023 first |

On the numerical lemma you proposed: it is correct, and the bare real-number version is a short `abs_sub_le_iff` + `linarith` lemma independent of DAM. Its value comes from composing it with `stepAt` and CP6a. One refinement makes it more useful: the design-time form needs only ε < |ΔE| on the *exact* gap, not a 2ε margin. The runtime form ε < |ΔÊ| is the one hardware can check online. Together they show that ties are the only fragile region.

The recommended order keeps the spec’s existing CP numbers, per your revision rule:

- **CP6c-0 (repair).** Restore Lean, move the HTML to `docs/`, add CI.
- **CP6c.1 (exact mean).** Recommended next theorem, below.
- **CP6c.2 (exact second moment).** Cross terms between memories ν ≠ ν′ vanish by the same involution, so Var(noise) = (K−1)·E[g(b)²] exactly. The asymptotic Ωₙ Nⁿ⁻¹ remains a separately labelled analytic claim.
- **CP6c.3 (certified finite error bound).** Chebyshev or Cantelli gives P(ΔE ≤ 0) ≤ Var/(Var + S²). This is a non-asymptotic, Gaussian-free capacity bound with a weaker constant. It cleanly separates exact finite results from the paper’s Gaussian estimate.
- **CP8a (implementation agreement).** Prove `stepAtWith gapHat = stepAt` under a certified ε, plus stability transfer given ε < flipEnergyGap at every neuron. Through CP6b, that margin is exactly signal + noise > ε.
- **CP8b (derive ε).** Bound ε from a fixed-point or quantization model. For F = xⁿ with overlaps bounded by M, ε ≤ 2K·n·Mⁿ⁻¹·δ.
- **CP7 (Energy Transformer).** Spec-only until a primary-source reading point exists.
- **CP9 (report).** The four-way separation listed in §6.

### 5. Recommended next theorem: CP6c.1

The paper writes ⟨ΔE⟩ = Nⁿ − (N−2)ⁿ as an equality before the ≈. Lean can certify that this holds **exactly for every finite N, K, n** under the uniform ±1 model, with no large-N or Gaussian step.

lean

```lean
namespace LeanDAM
variable {Memory Neuron : Type} [Fintype Memory] [Fintype Neuron]
  [DecidableEq Memory] [DecidableEq Neuron]

/-- Negate one Boolean coordinate. -/
def toggleAt (ν : Memory) (i : Neuron) (ω : Omega Memory Neuron) : Omega Memory Neuron :=
  fun ν' j => if ν' = ν ∧ j = i then !(ω ν' j) else ω ν' j

/-- Each noise summand is odd under toggling (ν, i), for ν ≠ μ. -/
lemma noiseSummand_toggle (n : ℕ) {μ ν : Memory} (hνμ : ν ≠ μ) (i : Neuron)
    (ω : Omega Memory Neuron) :
    let g := fun ω : Omega Memory Neuron =>
      (overlap (patternsOf ω) (patternState (patternsOf ω) μ) ν) ^ n -
      (overlap (patternsOf ω) (flip (patternState (patternsOf ω) μ) i) ν) ^ n
    g (toggleAt ν i ω) = - g ω

theorem sum_noiseTerm_patternsOf (n : ℕ) (μ : Memory) (i : Neuron) :
    ∑ ω : Omega Memory Neuron, noiseTerm n (patternsOf ω) μ i = 0

/-- Exact finite mean of the one-flip energy gap (Krotov–Hopfield, p. 2). -/
theorem mean_flipEnergyGap_eq_signal (n : ℕ) (μ : Memory) (i : Neuron) :
    (Fintype.card (Omega Memory Neuron) : ℝ)⁻¹ *
      ∑ ω : Omega Memory Neuron,
        flipEnergyGap (polyF n) (patternsOf ω) (patternState (patternsOf ω) μ) i
    = (Fintype.card Neuron : ℝ) ^ n - ((Fintype.card Neuron : ℝ) - 2) ^ n
```

**Why it holds.** Write a = ξᵢ^ν ξᵢ^μ and b = Σ\_{j≠i} ξⱼ^ν ξⱼ^μ. The ν-th summand is (a+b)ⁿ − (−a+b)ⁿ. Toggling (ν, i) with ν ≠ μ negates a, fixes b and ξ^μ, and so negates the summand. Since `toggleAt` is an involution, `Equiv.sum_comp` gives S = −S, so S = 0. The mean theorem then follows from `flipEnergyGap_signal_noise_decomposition`, `areBinaryPatterns_patternsOf`, and `Fintype.card_pos`.

I’m recommending this over CP8a as the *next* step for three reasons:

- It continues the open checkpoint and forces the repair anyway.
- It is the only candidate that certifies a displayed source equation.
- It supplies the exact mean of the margin quantity that CP8a’s stability-transfer hypothesis needs.

CP8a should follow immediately. Its core statement:

lean

```lean
noncomputable def stepAtWith (gapHat : State Neuron → Neuron → ℝ)
    (σ : State Neuron) (i : Neuron) : State Neuron :=
  if 0 ≤ gapHat σ i then candidatePos σ i else candidateNeg σ i

theorem stepAtWith_eq_stepAt (F : Separation) (ξ : Patterns Memory Neuron)
    (gapHat) (σ i) {ε : ℝ}
    (herr : |gapHat σ i - updateGap F ξ σ i| ≤ ε)
    (hm : ε < |updateGap F ξ σ i|) :
    stepAtWith gapHat σ i = stepAt F ξ σ i
```

### 6. Smallest implementation plan for CP6c.1

1. Run `git checkout 0077024 -- LeanDAM/Capacity.lean`, move the HTML to `docs/index.html`, and confirm `lake build` is green.
2. Add `toggleAt`, `toggleAt_involutive`, and an `Equiv.ofInvolutive` wrapper. This generalizes the `toggle` inside `coordinate_true_fiber_card`, which can then be refactored to reuse it.
3. Add a lemma splitting `overlap ξ σ ν` into its i-th term plus the `Finset.univ.erase i` sum. The pattern already exists in `overlap_candidatePos`.
4. Prove `noiseSummand_toggle` by `ring` after rewriting with step 3 and `toPM` negation (`toPM (!b) = - toPM b`).
5. Prove `sum_noiseTerm_patternsOf` with `Finset.sum_comm` and per-ν `Equiv.sum_comp`, using `eq_neg_self_iff`.
6. Prove `mean_flipEnergyGap_eq_signal`, then update the CP6c section of `SPECIFICATION.md` to mark “exact mean” as kernel-verified, keeping the variance, Gaussian, and K_max lines labelled approximate.

This is a candidate for Comparator-style independent checking. The statement file is short (`overlap`, `energy`, `polyF`, `flip`, `noiseTerm`, `patternsOf`, and the theorem), the proof is long, and the remaining human check is whether `noiseTerm` matches the paper’s ΔE. The bare CP8a sign lemma gains little from Comparator because its statement and proof are equally small.

### 7. Reproduction commands

bash

```bash
git clone https://github.com/thinkthoughts/lean-dense-associative-memory && cd lean-dense-associative-memory
git show --stat 83aec55                      # Lean → HTML replacement
git show 83aec55^:LeanDAM/Capacity.lean | head   # last Lean version (= 0077024)
lake exe cache get
lake build                                   # HEAD: expect failure in LeanDAM/Capacity.lean
git checkout 0077024 -- LeanDAM/Capacity.lean    # local, uncommitted
lake build
cat > /tmp/Axioms.lean <<'EOF'
import DenseAssociativeMemory
#print axioms LeanDAM.energy_stepAt_le
#print axioms LeanDAM.stablePattern_of_updateGap
#print axioms LeanDAM.flipEnergyGap_signal_noise_decomposition
#print axioms LeanDAM.patternCoordinate_pm_half
EOF
lake env lean /tmp/Axioms.lean
git checkout HEAD -- LeanDAM/Capacity.lean       # restore working tree
```

### 8. Why an energy-model researcher would care

Here is how the results split across the layers you asked about:

- **Abstract-model properties.** Descent holds for arbitrary F. The stability criterion is stated exactly, including the tie convention. The exact finite mean gap involves no Gaussian step.
- **Implementation properties.** CP8a shows that an implementation computing the gap within a certified ε makes exactly the same update choice as the energy model whenever the exact gap exceeds ε. Ties are the only fragile region.
- **Arithmetic assumptions.** These enter only through ε, which CP8b derives from a stated arithmetic model.
- **Empirical claims.** Power, latency, analog noise statistics, and drift stay outside Lean. A randomly distributed analog error would need its own probability model rather than a bound ε.

Combined with CP6c.2–.3, this gives a fully finite chain: random patterns, then an exact mean and variance, then a certified probability of a positive margin, then agreement between hardware and model. Each link carries its assumptions in the type signature.

I can turn this into a Doc for sharing, or start the CP6c-0 repair and CP6c.1 proof as a branch when you’re ready.