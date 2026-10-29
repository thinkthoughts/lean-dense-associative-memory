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

**Status: source-level, awaiting kernel check.** The module `LeanDAM/CrossTalk.lean` is written and imported by `DenseAssociativeMemory.lean`. The authoring environment cannot run Lean, so build and axiom results below are pending until `lake build DenseAssociativeMemory` and `bash scripts/axiom-audit.sh` run on the VPS or in CI.

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

### Awaiting kernel check

| Check | Command | Result |
| --- | --- | --- |
| Build | `lake build DenseAssociativeMemory` | pending |
| Axiom footprint | `bash scripts/axiom-audit.sh` (36 reports) | pending |
| CI | push of `cp6c-mean-zero` | pending |

## Mathematical boundary

Historical source reportedly proves an exact decomposition:

\[
\Delta E_i^\mu=\bigl[N^n-(N-2)^n\bigr]+\eta_i^\mu.
\]

Conditional mean-zero noise under independent uniform non-target spin patterns is **implemented at source level** on `cp6c-mean-zero` (CP6c.1 above) and becomes established once the kernel check passes. Once proved, linearity yields the full conditional expected gap equal to the deterministic signal, even if the noise has nonzero variance. For fixed `n`, the signal has leading growth `2n N^(n-1)`.

The variance asymptotic, Gaussian retrieval-error estimate, and capacity scalings remain source claims, not checked theorems. No Energy Transformer architecture, circuit, energy-per-token metric, or Dynamical Mind hardware property has been formally verified here.

## Provenance

See [Claude's review](reviews/CLAUDE_REVIEW_2026-10-29.md), [DeepSeek's review](reviews/DEEPSEEK_REVIEW_2026-10-29.md), [editorial reconciliation](reviews/RECONCILIATION_2026-10-29.md), and the adopted [roadmap](ROADMAP.md). The attributed review files are retained without rewriting their conclusions.
