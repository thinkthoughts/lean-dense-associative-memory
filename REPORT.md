# Dense Associative Memory — Verification Report

**October 29, 2026 · Gate R0 verification passed (branch `gate-r0`)**

The documentation checkpoint reviewed snapshot `f52348e`; `main` was at `a3b4b03` before the repair. Branch `gate-r0` restores the Lean source and adds CI and audit scripts. The repaired source at `b02311c` built successfully on the VPS, with evidence committed at `bfff927`. The GitHub Actions workflow was also reported green.

## Findings

- `LeanDAM/Basic.lean` contains the overlap, generalized energy, quadratic interaction expansion, energy-based asynchronous update, and deterministic stability declarations.
- Before Gate R0, imported `LeanDAM/Capacity.lean` contained HTML beginning `<!doctype html>`. The historical Lean source is restored and the HTML preserved at `docs/index.html`.
- Restored capacity proofs from `0077024` include one-flip energy, exact signal/noise decomposition, and finite random-pattern coordinate marginals; the restored source now builds.
- `SPECIFICATION.md` describes further research targets beyond the current verified state.

## Gate R0 — evidence on branch `gate-r0`

### Established on `gate-r0`

| Check | Method | Result |
| --- | --- | --- |
| Source restoration | `diff <(git show 0077024:LeanDAM/Capacity.lean) LeanDAM/Capacity.lean` | byte-identical (577 lines) |
| HTML preservation | `diff <(git show f52348e:LeanDAM/Capacity.lean) docs/index.html` | byte-identical (591 lines), moved with `git mv` |
| Unchanged Lean context | `git diff 0077024 -- LeanDAM/Basic.lean DenseAssociativeMemory.lean lakefile.toml lean-toolchain` | empty: the Lean tree equals commit `0077024` exactly |
| Theorem statements | restoration only | unchanged: 22 theorems/lemmas, 46 public declarations |
| Integrity guard, repaired tree | `bash scripts/check-lean-sources.sh` | exit 0: 4 Lean files pass |
| Integrity guard, original HEAD `a3b4b03` | same script | exit 1: flags `LeanDAM/Capacity.lean` (HTML markup; first line `<!doctype html>`) |
| Guard self-test | synthetic files | docstring/comment mentions pass; `by sorry` and `axiom bad : False` fail |
| `sorry` / `admit` / `axiom` tokens | guard, comments and strings stripped | none in `Basic.lean`, `Capacity.lean`, `DenseAssociativeMemory.lean` |

### Pinned build and axiom evidence

| Check | Command | Result |
| --- | --- | --- |
| Toolchain | `lean --version` | Lean 4.35.0-rc2, Lake 5.0.0 |
| Mathlib | `lake-manifest.json` | resolved manifest committed at `bfff927`; pinned rev `a218e50f981942cba4fd060faff7cae680805062` |
| Build | `lake build DenseAssociativeMemory` | exit 0, 8,940 jobs, zero warnings |
| Axiom footprint | `bash scripts/axiom-audit.sh` | 22/22 audited; only `propext`, `Classical.choice`, `Quot.sound`; no `sorryAx` |
| GitHub Actions | `.github/workflows/lean.yml` on `gate-r0` | green check reported October 29, 2026 |

VPS evidence is preserved in `verification/env.txt`, `verification/guard.log`, `verification/cache.log`, `verification/build.log`, `verification/axiom-audit.txt` and `verification/axiom-audit.log`. The CI result is reported separately.

### Verification machinery added

- `scripts/check-lean-sources.sh` — fails on HTML/XML markup, empty files, `sorry`/`admit`, `axiom` declarations, and unresolved `LeanDAM.*` imports.
- `scripts/AxiomAudit.lean` — `#print axioms` for every public theorem and lemma.
- `scripts/axiom-audit.sh` — runs the audit, saves raw output, and enforces the standard-axiom boundary and the report count.
- `scripts/r0-verify.sh` — one-command local run writing `verification/` evidence.
- `.github/workflows/lean.yml` — on push, PR and manual dispatch: guard → elan → Mathlib cache → build → axiom audit → evidence artifact.

## CP6c.1 — conditional mean-zero cross-talk (branch `cp6c-mean-zero`)

**Status: kernel-verified at `6d77ae7`; audit recorded at `7e31c72`.** The module `LeanDAM/CrossTalk.lean` is imported by `DenseAssociativeMemory.lean`.

### Statement

For finite types `Memory`, `Neuron`, every power `n`, target memory `μ`, neuron `i` and target Boolean pattern `t : Neuron → Bool`:

```lean
theorem condMean_noiseTerm_eq_zero (n : ℕ) (μ : Memory) (i : Neuron) (t : Neuron → Bool) :
    condMeanGivenTarget μ t (fun ω => noiseTerm n (patternsOf ω) μ i) = 0
```

`condMeanGivenTarget μ t X` is the average of `X` over the fiber `{ω : Omega Memory Neuron | ω μ = t}`, which is the conditional expectation given `ξ^μ = toPM ∘ t` under `uniformSamples`. `targetFiber_card_pos` shows every fiber is nonempty, so the average is non-vacuous.

### Hypotheses

- Patterns are `patternsOf ω` for `ω : Memory → Neuron → Bool`; each fiber of the target coordinate carries the uniform law. No further independence assumption is used: the proof works on the finite product space directly.
- The symmetry requires `ν ≠ μ` for each cross-talk summand and nothing about the separation function: `condMean_crossTalk_eq_zero` holds for every `F : ℝ → ℝ`.

### Proof mechanism

For `ν ≠ μ`, `toggleAt ν i` negates Boolean coordinate `(ν, i)`. It is an involution (`toggleAt_toggleAt`), fixes the target pattern (`toggleAt_target`), and reverses the `ν`-th summand `F(a+b) − F(−a+b)`, with `a = ξᵢ^ν ξᵢ^μ` and `b = Σ_{j≠i} ξⱼ^ν ξⱼ^μ`, because it sends `a ↦ −a` and fixes `b` (`crossSummand_neg_of_coord_negation`, `crossSummand_toggleAt`). Reindexing the fiber sum by this involution gives `S = −S`, so each fiber sum vanishes (`sum_condCross_eq_zero`, `sum_cond_crossTalk_eq_zero`).

### Convention check

`polyF n = xⁿ` is the paper's "polynomial energy function", the case its capacity calculation on p. 2 uses; the rectified polynomial is Eq. (3). Because the symmetry lemma holds for arbitrary `F`, the mean-zero result covers both conventions. `noiseTerm_eq_crossTalk` identifies the existing `noiseTerm n` with `crossTalk (polyF n)` definitionally. No existing definition or statement changed.

### Pre-build evidence

| Check | Result |
| --- | --- |
| Brute-force model check (Python, exact integer/rational arithmetic; N ∈ {3,4}, K ∈ {2,3}, n ∈ {1,2,3,4}; F ∈ {`xⁿ`, rectified `xⁿ`, `1/(1+x²) + x³`}) | involution reverses every summand; every target-fiber noise sum is exactly 0 |
| Non-vacuity (N=4, K=3, n=3) | noise takes values −112, −64, −48, −16, 0, 16, 48, 64, 112 |
| `bash scripts/check-lean-sources.sh` | exit 0: 5 Lean files pass |
| `scripts/AxiomAudit.lean` | extended from 22 to 36 theorem/lemma reports |

### Kernel verification

| Check | Command | Result |
| --- | --- | --- |
| Build | `lake build DenseAssociativeMemory` (VPS, pinned Lean 4.35.0-rc2 / Mathlib) | 8,941 jobs, success |
| Axiom footprint | `bash scripts/axiom-audit.sh` (36 reports) | 34 × `[propext, Classical.choice, Quot.sound]`; 2 × `[propext, Quot.sound]` (`toggleAt_toggleAt`, `toggleAt_target`); zero `sorryAx`. Evidence: `verification/cp6c1-axiom-audit.txt` |
| CI | push of `cp6c-mean-zero` | complete workflow successful |

## CP6c.2 — exact expected one-flip energy gap (branch `cp6c-expected-gap`)

**Status: source-level, awaiting kernel check.** `LeanDAM/ExpectedGap.lean` is imported by `DenseAssociativeMemory.lean`. The authoring environment cannot run Lean; build and axiom rows below are pending until the VPS or CI run.

### Statement

```lean
theorem condMean_flipEnergyGap_eq_signal (n : ℕ) (μ : Memory) (i : Neuron) (t : Neuron → Bool) :
    condMeanGivenTarget μ t
        (fun ω => flipEnergyGap (polyF n) (patternsOf ω) (patternState (patternsOf ω) μ) i) =
      oneFlipSignal (Fintype.card Neuron) n
```

with `oneFlipSignal N n := (N : ℝ) ^ n - ((N : ℝ) - 2) ^ n`.

### Hypotheses

- Finite `Memory` and `Neuron` with decidable equality; any `n : ℕ`, including `n = 0`.
- The existence of `μ` and `i` forces at least one memory and one neuron; no other size hypothesis, and no large-`N` regime.
- `N − 2` is formed in `ℝ`, so `N ∈ {1, 2}` is handled without natural-number truncation.
- Separation function `polyF n` only: the signal formula is specific to the polynomial convention, even though CP6c.1's mean-zero result holds for every `F`.

### Argument

1. `flipEnergyGap_signal_noise_decomposition` applies at every sample, since `areBinaryPatterns_patternsOf ω μ` makes each target pattern binary.
2. The signal is a fixed real number; `condMean_const` averages it over the nonempty fiber (`sum_targetFiber_const`, `targetFiber_card_ne_zero`).
3. The cross-talk fiber sum is zero by CP6c.1 (`sum_cond_crossTalk_eq_zero (polyF n)`, definitionally `noiseTerm n`).
4. `Finset.sum_add_distrib` combines the two.

Target memory `μ`, neuron `i` and target pattern `t` are fixed throughout; only the non-target coordinates vary across the fiber.

### Source correspondence

Krotov–Hopfield p. 2 states `⟨ΔE⟩ = Nⁿ − (N−2)ⁿ ≈ 2nNⁿ⁻¹`. This theorem proves the exact equality, conditioned on the target pattern; the `≈` remains an asymptotic source claim.

### New declarations

`oneFlipSignal` (def), `targetFiber_card_ne_zero`, `sum_targetFiber_const`, `condMean_const`, `condMean_flipEnergyGap_eq_signal`. No existing statement changed.

### Pre-build evidence

| Check | Result |
| --- | --- |
| Exact brute-force check (`scripts/cp6c2_model_check.py`; N ∈ {1,2,3,4}, K ∈ {2,3}, n ∈ {0,…,4}) | every target-fiber mean equals `Nⁿ − (N−2)ⁿ` exactly |
| `bash scripts/check-lean-sources.sh` | exit 0: 6 Lean files pass |
| `scripts/AxiomAudit.lean` | extended from 36 to 40 reports |

### Awaiting kernel check

| Check | Command | Result |
| --- | --- | --- |
| Build | `lake build DenseAssociativeMemory` | pending |
| Axiom footprint | `bash scripts/axiom-audit.sh` (40 reports) | pending |
| CI | push of `cp6c-expected-gap` | pending |

## Mathematical boundary

Historical source reportedly proves an exact decomposition:

\[
\Delta E_i^\mu=\bigl[N^n-(N-2)^n\bigr]+\eta_i^\mu.
\]

Conditional mean-zero noise under independent uniform non-target spin patterns is **kernel-verified** (CP6c.1 above). The resulting exact conditional expected gap is CP6c.2, at source level above. By linearity the expected gap equals the deterministic signal even though the noise has nonzero variance. For fixed `n`, the signal has leading growth `2n N^(n-1)`.

The variance asymptotic, Gaussian retrieval-error estimate, and capacity scalings remain source claims, not checked theorems. No Energy Transformer architecture, circuit, energy-per-token metric, or Dynamical Mind hardware property has been formally verified here.

## Provenance

See [Claude's review](reviews/CLAUDE_REVIEW_2026-10-29.md), [DeepSeek's review](reviews/DEEPSEEK_REVIEW_2026-10-29.md), [editorial reconciliation](reviews/RECONCILIATION_2026-10-29.md), and the adopted [roadmap](ROADMAP.md). The attributed review files are retained without rewriting their conclusions.
