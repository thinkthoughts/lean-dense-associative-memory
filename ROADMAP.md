# Lean DAM Roadmap

**October 29, 2026.** This roadmap reconciles the Claude and DeepSeek reviews, preserves the historical checkpoints in `SPECIFICATION.md`, and distinguishes completed work from proposed results. An unchecked item has not been verified at the current HEAD.

## Gate R0 — Recover a verifiable baseline

- [x] **R0.1 Restore source.** Inspect `git show 0077024:LeanDAM/Capacity.lean`; preserve the HTML currently occupying that path (e.g. `docs/index.html`), restore the Lean module and examine the diff. *Done on `gate-r0`: Lean module byte-identical to `0077024`; HTML byte-identical at `docs/index.html` (see `REPORT.md`).*
- [x] **R0.2 Build.** VPS: pinned Lean 4.35.0-rc2/Mathlib, 8,940 jobs, exit 0, zero warnings. Evidence: `verification/build.log` and `verification/env.txt`.
- [x] **R0.3 Axioms.** All 22 theorem/lemma reports contain only `propext`, `Classical.choice`, `Quot.sound`; no `sorryAx`. Evidence: `verification/axiom-audit.txt`.
- [x] **R0.4 CI.** The push/PR workflow ran successfully on `gate-r0` (green check reported October 29, 2026).
- [x] **R0.5 Update verification status.** Historical CP2–CP6c declarations restored and verified at `b02311c`; evidence committed at `bfff927`. Proposed capacity extensions remain open.

*Gate R0: all five checkpoints complete on `gate-r0`. Merge into `main` remains a separate action.*

## Track A — Exact finite capacity mathematics

- [x] **CP6c.1 — Mean-zero cross-talk.** Define a finite uniform ±1 pattern ensemble with an explicitly fixed target memory; prove `E[noiseTerm | target] = 0` by finite symmetry/involution. Confirm whether the source's `polyF` agrees with the primary paper's rectified-polynomial convention before claiming exact source equivalence. *Verified on `cp6c-mean-zero` (`6d77ae7`, audit `7e31c72`): `LeanDAM/CrossTalk.lean`, main theorem `condMean_noiseTerm_eq_zero`; the involution lemma holds for arbitrary `F`, covering both `polyF` (paper's polynomial case, used on p. 2) and the rectified Eq. (3). VPS build 8,941 jobs; 36 axiom reports, standard axioms only, no `sorryAx`; CI green.*
- [ ] **CP6c.2 — Expected gap.** Combine the restored exact `flipEnergyGap_signal_noise_decomposition` theorem with CP6c.1 to prove `E[ΔE | target] = N^n - (N-2)^n` for precisely stated finite parameters. Nonzero noise variance does not invalidate this identity. *Source-level on `cp6c-expected-gap`: `LeanDAM/ExpectedGap.lean`, main theorem `condMean_flipEnergyGap_eq_signal`, stated for `polyF n` only. Checked once the build and 40-report axiom audit pass (see `REPORT.md`).*
- [ ] **CP6c.3 — Exact second moment.** Derive a finite formula for cross-talk variance and justify all independence/cross-term cancellations. The paper's large-`N` variance formula is not an exact finite identity.
- [ ] **CP6c.4 — Tail bound.** Apply an explicitly justified finite-probability inequality (e.g. Cantelli or Chebyshev) to obtain a certified bound for one-flip retrieval error, with ties addressed.
- [ ] **CP6c.5 — Capacity bound.** Derive a finite threshold from the certified tail bound. Treat the paper's Gaussian approximation and asymptotic `K_max` separately, under their actual hypotheses.

Each checkpoint needs a precisely typed Lean statement, primary-source or explicitly new-result attribution, a clean build, an axiom audit and a deterministic/probabilistic/asymptotic classification.

## Track B — Numerical energy-update guarantees

This is independent of stochastic retrieval capacity: a numerical comparison needs an arithmetic-error certificate, not a probabilistic concentration theorem.

- [ ] **B1 — Gap sign agreement.** For exact `g`, computed `ĝ`, and `ε ≥ 0`, prove that `|ĝ-g| ≤ ε` and `ε < |ĝ|` imply equal nonzero signs. Also prove the design-time form with `ε < |g|`. Treat zero-gap ties explicitly.
- [ ] **B2 — Update agreement.** Prove that the certified comparison causes an approximate single-neuron update to match `stepAt` with its existing `+1` tie policy.
- [ ] **B3 — Traces and descent.** State a concrete asynchronous schedule; prove finite update-trace agreement under per-step certificates and distinguish non-increase, strict descent and convergence.
- [ ] **B4 — Quantization.** Obtain `ε` from stated rounding, overlap, polynomial evaluation and accumulation rules, including intermediate bounds.
- [ ] **B5 — Hardware boundary.** Interpret theorems conditionally; no undocumented circuit, chip, power or speed claim follows.

## Track C — Source-based architectural refinements

- [ ] **CP7 — Energy Transformer.** Read a primary Energy Transformer paper and specify attention energy, state variables, updates and hypotheses before any Lean correspondence proof.
- [ ] **CP8 — Physical implementation.** Read a primary analog-circuit source; identify the mapping from energy-landscape variables to physical quantities and the numerical/measurement assumptions.
- [ ] **CP9 — Evidence discipline.** Separate exact proofs, hypothesis-dependent consequences, source-reported experiments and untested implementation claims.

## Order

First `R0.1–R0.5`, then `CP6c.1 → CP6c.2 → CP6c.3 → CP6c.4`; `B1 → B2` may proceed independently once the restored baseline is sound. Track B uses new labels to avoid colliding with the pre-existing CP7–CP9 reading points.

## Supporting documents

[Specification](SPECIFICATION.md) · [Verification report](REPORT.md) · [Claude review](reviews/CLAUDE_REVIEW_2026-10-29.md) · [DeepSeek review](reviews/DEEPSEEK_REVIEW_2026-10-29.md) · [Reconciliation](reviews/RECONCILIATION_2026-10-29.md)
