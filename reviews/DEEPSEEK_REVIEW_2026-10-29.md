# Review of "Lean DAM: Technical Review and Next Checkpoint" (Oct 29, 2026)

## 1. Confirmed Findings

**Repository integrity issue is accurately reported.** The review states that `LeanDAM/Capacity.lean` was overwritten with HTML in commit `83aec55`, and that the last Lean version at `0077024` retains all capacity declarations. The proposed repair (`git checkout 0077024 -- LeanDAM/Capacity.lean`) is correct and minimal. The absence of CI is a genuine contributing factor.

**Trust boundary claim is plausible but unverified in this environment.** The review claims zero `sorry` and zero `axiom` in the Lean sources at the relevant commits. Since the toolchain and Mathlib cache were blocked, this claim rests on source inspection, not kernel checking. The expected axiom footprint (`propext`, `Classical.choice`, `Quot.sound`) is standard for Lean/Mathlib-based proofs involving classical reasoning. However, **`#print axioms` at `0077024` would be required to confirm this**; the review itself acknowledges this in Section 7.

**The declaration inventory is broadly consistent with the Krotov–Hopfield model.** The mapping of `energy` to Eq. (2), `interaction` to Eq. (1) (modulo the ½ and diagonal convention), and `stepAt` to Eq. (4) with ties → +1 matches the paper's structure. The signal term Nⁿ − (N−2)ⁿ is the correct overlap contribution for a stored pattern under uniform ±1 patterns, and the decomposition into signal + noise via `flipEnergyGap_signal_noise_decomposition` is a faithful formalization of the paper's ΔE analysis.

**The proposed CP6c.1 target (kernel-checked proof that ⟨ΔE⟩ = Nⁿ − (N−2)ⁿ holds exactly for every finite N, K, n) is mathematically well-posed.** Under uniform independent ±1 patterns, the expected flip energy gap for a stored pattern separates into a deterministic signal from the target pattern and a zero-mean noise term from the other K−1 patterns. The signal contribution is indeed Nⁿ − (N−2)ⁿ for the rectified polynomial F(z) = zⁿ (z > 0). Formalizing this expectation over the product measure is a natural next step.

**The review correctly distinguishes "previously successful builds" from the current HEAD.** The default target at HEAD fails at `<!doctype`, while `0077024` is expected to build. This distinction is essential and is stated clearly.

---

## 2. Corrections and Disagreements

### 2.1 Mathematical precision: "⟨ΔE⟩ = Nⁿ − (N−2)ⁿ" is the signal, not the full expectation under the paper's ensemble

The review states the checkpoint as proving that the mean one-flip energy gap equals Nⁿ − (N−2)ⁿ. This is **the signal contribution only**. The full expected gap under the Krotov–Hopfield random-pattern ensemble includes the noise term, which has mean zero but nonzero variance. The paper's capacity analysis uses the signal-to-noise ratio, not the signal alone. The proposed theorem should be stated as:

> **Under the uniform ±1 product measure, the conditional expectation of the signal term in ΔE given the target pattern is Nⁿ − (N−2)ⁿ, and the noise term has conditional mean zero.**

This is a stronger and more faithful formalization. Stating it as "⟨ΔE⟩ = Nⁿ − (N−2)ⁿ" without qualification is misleading: it suggests the entire gap has that mean, which is false when K > 1.

### 2.2 "Numerical sign-agreement theorem (CP8a) follows directly" is overclaimed

The review says CP8a "follows directly" from CP6c.1. This is not accurate. CP6c.1 establishes an expected-value identity. CP8a appears to concern sign agreement (presumably that the update rule recovers the stored pattern with high probability). Moving from an expectation identity to a sign-agreement or error-probability bound requires:

1. A concentration or tail bound on the noise term (variance calculation or Gaussian approximation).
2. A union bound or per-coordinate error analysis.
3. The threshold condition P_error < 1/N from the paper.

None of these "follow directly" from the expectation identity alone. CP8a depends on CP6c.1, but the dependency is substantive, not immediate.

### 2.3 The source claims list conflates proven results with asymptotic heuristics

The "Source claims awaiting Lean counterparts" list includes both exact finite-N identities (⟨ΔE⟩) and asymptotic large-N results (Σ² with Ωₙ, the Gaussian P_error, K_max = αₙNⁿ⁻¹). These are not on the same footing. The variance formula Σ² = Ωₙ(K−1)Nⁿ⁻¹ with Ωₙ = 4n²(2n−3)!! is an asymptotic approximation for large N, not an exact finite-N identity. Formalizing it in Lean would require either:

- An exact finite-N variance formula (which may exist but is more complex), or
- An asymptotic statement with explicit error terms.

The review should distinguish these categories. Proposing "the Gaussian P_error" as a Lean target without specifying the approximation regime invites an ill-posed formalization.

### 2.4 Hardware implementation claims are entirely absent, correctly

The review makes no claims about hardware implementation. The prompt asks to identify "unsupported claims about hardware implementation," but none are present. The paper's discussion of rectified polynomial activations and their training speed is a software/algorithmic observation, not a hardware claim. The review appropriately does not venture into hardware.

### 2.5 The "Build at `0077024`" expectation is stated without evidence

The review says "Expected to build; confirm locally." This is honest but insufficient for a technical review. If the environment blocked the toolchain, the reviewer could at least inspect `lakefile.lean` / `lakefile.toml` and `lean-toolchain` at `0077024` to verify dependency consistency. The absence of this inspection is a gap, though not an error.

---

## 3. Recommended Next Theorem

**Smallest substantive theorem:** Formalize the **exact signal decomposition of the flip energy gap** for a stored pattern under the rectified polynomial F, including the noise term's conditional mean-zero property.

Concretely, the theorem should state:

> Let N, K, n be positive naturals. Let ξ⁽¹⁾, …, ξ⁽ᴷ⁾ be uniformly random ±1 patterns in {±1}^N. Let σ = ξ⁽¹⁾ be the target stored pattern. For any coordinate i, define ΔE as the energy change from flipping coordinate i of σ. Then:
> 1. ΔE decomposes as S + η, where S = Nⁿ − (N−2)ⁿ depends only on n and N.
> 2. E[η | ξ⁽¹⁾] = 0 under the conditional distribution of the other patterns.
> 3. E[ΔE | ξ⁽¹⁾] = Nⁿ − (N−2)ⁿ.

**Why this is the right next theorem:**

- It is **finite-N exact**, not asymptotic. Every step is a finite combinatorial identity over Finsets, amenable to Mathlib's `Finset.sum` and `Finset.prod` machinery.
- It directly captures the **signal-to-noise structure** that the Krotov–Hopfield capacity argument relies on. The paper's P_error analysis is a tail bound on the noise term; you cannot formalize the tail bound without first formalizing the decomposition.
- It is **substantive but tractable**: the signal term requires computing the contribution of the target pattern's overlap under a one-flip perturbation (a binomial coefficient identity), and the noise mean-zero property follows from symmetry of the uniform measure over ±1 patterns (each non-target pattern's contribution to the overlap flips sign under the coordinate flip, and the expectation over the pattern ensemble kills the cross terms).
- It establishes the **foundational lemma** for all subsequent capacity theorems. Without this decomposition, CP7 (variance) and CP8 (error probability) have no formal starting point.

**Relevance to energy-based AI architectures:** The signal-to-noise decomposition is the mathematical core of why dense associative memories can store many patterns: the signal grows as Nⁿ while the noise grows as √(KNⁿ) (up to constants), so for K ≪ Nⁿ⁻¹ the signal dominates. Formalizing this decomposition in Lean makes the capacity argument **auditable**: one can inspect the precise finite-N identities that the asymptotic scaling argument approximates. This is directly relevant to energy-based architectures (Hopfield networks, modern continuous Hopfield networks, and their Transformer connections) because it isolates the mechanism—higher-order interactions amplify the signal relative to cross-talk—that distinguishes dense memories from classical Hopfield networks.

---

## 4. Dependencies and Verification Requirements

### 4.1 Repository state dependencies

Before any kernel-checked theorem can be trusted, the following must be confirmed at commit `0077024`:

| Dependency | Verification command | Expected result |
|---|---|---|
| `Capacity.lean` is Lean, not HTML | `git show 0077024:LeanDAM/Capacity.lean \| head -5` | Lines beginning with `import` or Lean syntax, not `<!doctype` |
| Zero `sorry` in relevant modules | `#print axioms` on each declared theorem | No `sorryAx` in output |
| Axiom footprint | `#print axioms flipEnergyGap_stored_memory` (and others) | Subset of {`propext`, `Classical.choice`, `Quot.sound`} |
| Build succeeds | `lake build LeanDAM.Capacity` at `0077024` | Exit code 0, no errors |
| Toolchain consistency | Inspect `lean-toolchain` and `lake-manifest.json` | Mathlib revision matches Lean version |

The review's proposed CI workflow (`lake build` on push) would have caught the overwrite. This should be adopted, but it is a process fix, not a mathematical one.

### 4.2 Mathematical dependencies for the recommended theorem

The theorem requires the following Mathlib ingredients (all standard):

1. **Finite product measure over {±1}^N.** Mathlib's `PMF` (probability mass function) or a direct `Finset` cardinality argument over `Fin N → Bool` (mapped to ±1). The review's `uniformSamples` and `coordinatePMF` declarations suggest this infrastructure is partially present.
2. **Finset sum manipulation.** The energy is a sum over patterns μ and coordinates. The flip changes one coordinate, so the difference isolates the μ = 1 (target) term and leaves the others. Mathlib's `Finset.sum_sub_distrib` and `Finset.sum_congr` handle this.
3. **Binomial coefficient identity.** The target signal Nⁿ − (N−2)ⁿ requires computing (N)ⁿ − (N−2)ⁿ for the overlap. Since the target pattern is aligned with itself, the overlap before flip is N, after flip is N−2. This is a `norm_num`/`ring` computation once the definitions unfold.
4. **Symmetry / mean-zero of noise.** For each non-target pattern ξ⁽ᵘ⁾ (μ ≠ 1), its contribution to the overlap is a sum of ±1 terms. Under the uniform measure, flipping coordinate i changes the overlap from S to S − 2ξ_i⁽ᵘ⁾σ_i, and the expectation over ξ_i⁽ᵘ⁾ is zero by symmetry. This requires a `Finset.sum` over the pattern ensemble with an explicit symmetry argument.

**Verification requirement:** The theorem should be stated with **explicit hypotheses** on N, K, n (positive naturals, K ≥ 1, n ≥ 1) and with the uniform measure defined as a `Finset`-cardinality-weighted sum over the finite pattern space. No `noncomputable` classical choice should be needed for the combinatorial identity itself; classical reasoning may enter only for the expectation definition if using `PMF`.

---

## 5. Proposed ROADMAP.md Checkpoints

The following checkpoints are ordered by dependency and minimality. Each is stated as a kernel-checkable theorem or definition.

### CP6c.1 (revised): Signal decomposition of ΔE

**Statement:** For F(z) = zⁿ (rectified: z > 0), under uniform ±1 patterns, ΔE for flipping coordinate i of a stored pattern decomposes as S + η, with S = Nⁿ − (N−2)ⁿ and E[η | target] = 0.

**Dependencies:** `flipEnergyGap_signal_noise_decomposition` (already proved), `uniformSamples`, `coordinatePMF`.

**Verification:** `#print axioms` shows no `sorryAx`; the expectation is a finite Finset sum, not a measure-theoretic integral.

### CP7: Variance of the noise term (finite-N exact, or asymptotic with error)

**Statement (finite-N version):** For the noise term η, Var[η] is a computable expression in N, K, n (possibly involving sums of binomial coefficients).

**Statement (asymptotic version, if finite-N is too complex):** For fixed n and K → ∞ with K/Nⁿ⁻¹ → α, Var[η] / (K Nⁿ⁻¹) → Ωₙ, with an explicit error bound.

**Recommendation:** Attempt the finite-N exact variance first. If the expression is unwieldy, formalize the leading asymptotic with an explicit `O` or `o` bound (Mathlib has `Asymptotics`). The review's claimed Σ² = Ωₙ(K−1)Nⁿ⁻¹ is an asymptotic result and should be labeled as such.

**Dependencies:** CP6c.1, plus Mathlib's `Finset` moment computations or `ProbabilityTheory` variance lemmas.

### CP8a: Sign agreement / error probability bound

**Statement:** Under the signal-to-noise decomposition, P(ΔE < 0) ≤ some explicit bound (e.g., via Chebyshev or a Gaussian approximation with Berry–Esseen error).

**Dependencies:** CP6c.1 (signal), CP7 (variance). This does **not** follow directly from CP6c.1 alone.

**Note:** The paper's criterion is P_error < 1/N, leading to K_max ≈ αₙNⁿ⁻¹. Formalizing the exact threshold αₙ requires the variance asymptotic and a tail bound. This is the most substantive checkpoint and should be attempted only after CP7 is stable.

### CP9 (optional, if pursuing the full paper): Capacity scaling theorem

**Statement:** If K ≤ c Nⁿ⁻¹ for a sufficiently small constant c (depending on n), then P_error < 1/N.

**Dependencies:** CP8a. This is the paper's main capacity result and is likely beyond the scope of a near-term Lean formalization. It should be listed as a long-term goal, not a next checkpoint.

### Process checkpoints (non-mathematical)

| Checkpoint | Action | Verification |
|---|---|---|
| CP0.1 | Restore `Capacity.lean` from `0077024` | `lake build` succeeds at HEAD |
| CP0.2 | Add `lake build` CI on push | CI fails on HTML-in-Lean or `sorryAx` |
| CP0.3 | Move HTML to `docs/index.html` | Repository structure matches `README.md` |
| CP0.4 | Add `#print axioms` audit script | All theorems report only {`propext`, `Classical.choice`, `Quot.sound`} |

These process checkpoints are prerequisites for trusting any mathematical checkpoint. The review's recommendation to restore and add CI is correct and should be implemented before CP6c.1 is attempted.

---

## Summary Judgment

The review correctly identifies the repository corruption and accurately inventories the existing Lean declarations. Its proposed CP6c.1 is mathematically sound but imprecisely stated (signal ≠ full expectation) and overclaims the immediacy of CP8a. The recommended next theorem should be the **exact signal-noise decomposition with conditional mean-zero noise**, stated with finite-N precision and verified via `#print axioms` at `0077024`. Hardware claims are absent, correctly. The roadmap should prioritize repository repair and CI before advancing the formalization.