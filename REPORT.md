# Dense Associative Memory — Verification Report

**October 29, 2026 · Documentation-only checkpoint**

The supplied repository snapshot is `f52348e`. No Lean source was repaired or modified in this documentation update. No current kernel-checked build or axiom audit is claimed.

## Findings

- `LeanDAM/Basic.lean` contains the overlap, generalized energy, quadratic interaction expansion, energy-based asynchronous update, and deterministic stability declarations.
- Imported `LeanDAM/Capacity.lean` at HEAD contains HTML beginning `<!doctype html>` and cannot be parsed as Lean.
- Claude's Git-history audit reports recoverable historical capacity proofs at `0077024`: one-flip energy, exact signal/noise decomposition, and finite random-pattern coordinate marginals. Those are absent from the supplied HEAD.
- `SPECIFICATION.md` describes further research targets beyond the current verified state.

## Verification gates not yet completed

1. Preserve the HTML report elsewhere and restore the previous Lean source after reviewing the historical diff.
2. Run `lake build DenseAssociativeMemory` with the pinned toolchain and dependencies; record revision and output.
3. Audit critical theorems with `#print axioms`, check for `sorryAx`, and record the actual axiom footprint.
4. Add CI and a source-integrity guard.

## Mathematical boundary

Historical source reportedly proves an exact decomposition:

\[
\Delta E_i^\mu=\bigl[N^n-(N-2)^n\bigr]+\eta_i^\mu.
\]

Conditional mean-zero noise under independent uniform non-target spin patterns is **proposed**, not yet established in Lean. Once proved, linearity yields the full conditional expected gap equal to the deterministic signal, even if the noise has nonzero variance. For fixed `n`, the signal has leading growth `2n N^(n-1)`.

The variance asymptotic, Gaussian retrieval-error estimate, and capacity scalings remain source claims, not checked theorems. No Energy Transformer architecture, circuit, energy-per-token metric, or Dynamical Mind hardware property has been formally verified here.

## Provenance

See [Claude's review](reviews/CLAUDE_REVIEW_2026-10-29.md), [DeepSeek's review](reviews/DEEPSEEK_REVIEW_2026-10-29.md), [editorial reconciliation](reviews/RECONCILIATION_2026-10-29.md), and the adopted [roadmap](ROADMAP.md). The attributed review files are retained without rewriting their conclusions.
