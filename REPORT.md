# Dense Associative Memory — Verification Report

**October 29, 2026 · Gate R0 in progress (branch `gate-r0`)**

The documentation checkpoint reviewed snapshot `f52348e`; `main` is now at `a3b4b03`. Branch `gate-r0` restores the Lean source and adds CI and audit scripts. The kernel-checked build and axiom audit at the repaired commit are pending and are recorded below once run.

## Findings

- `LeanDAM/Basic.lean` contains the overlap, generalized energy, quadratic interaction expansion, energy-based asynchronous update, and deterministic stability declarations.
- Imported `LeanDAM/Capacity.lean` at HEAD contains HTML beginning `<!doctype html>` and cannot be parsed as Lean.
- Claude's Git-history audit reports recoverable historical capacity proofs at `0077024`: one-flip energy, exact signal/noise decomposition, and finite random-pattern coordinate marginals. Those are absent from the supplied HEAD.
- `SPECIFICATION.md` describes further research targets beyond the current verified state.

## Gate R0 — evidence on branch `gate-r0`

### Established on `gate-r0`

| Check | Method | Result |
| --- | --- | --- |
| Source restoration | `diff <(git show 0077024:LeanDAM/Capacity.lean) LeanDAM/Capacity.lean` | byte-identical (577 lines) |
| HTML preservation | `diff <(git show f52348e:LeanDAM/Capacity.lean) docs/index.html` | byte-identical (591 lines), moved with `git mv` |
| Unchanged Lean context | `git diff 0077024 -- LeanDAM/Basic.lean DenseAssociativeMemory.lean lakefile.toml lean-toolchain` | empty: the Lean tree equals commit `0077024` exactly |
| Theorem statements | restoration only | unchanged: 22 theorems/lemmas, 46 public declarations |
| Integrity guard, repaired tree | `bash scripts/check-lean-sources.sh` | exit 0: 3 Lean files pass |
| Integrity guard, original HEAD `a3b4b03` | same script | exit 1: flags `LeanDAM/Capacity.lean` (HTML markup; first line `<!doctype html>`) |
| Guard self-test | synthetic files | docstring/comment mentions pass; `by sorry` and `axiom bad : False` fail |
| `sorry` / `admit` / `axiom` tokens | guard, comments and strings stripped | none in `Basic.lean`, `Capacity.lean`, `DenseAssociativeMemory.lean` |

### Awaiting the pinned build

| Check | Command | Result |
| --- | --- | --- |
| Toolchain | `lean --version` with `leanprover/lean4:v4.35.0-rc2` | pending |
| Mathlib | pinned rev `a218e50f981942cba4fd060faff7cae680805062` | pending (`lake-manifest.json` is untracked; lake resolves the pinned commit) |
| Build | `lake build DenseAssociativeMemory` | pending: exit code, warnings, duration |
| Axiom footprint | `bash scripts/axiom-audit.sh` over all 22 theorems/lemmas | pending; pass requires axioms ⊆ {`propext`, `Classical.choice`, `Quot.sound`} and zero `sorryAx` |

The review environment for this branch had its Lean toolchain and Mathlib downloads blocked by network policy. These rows therefore await `bash scripts/r0-verify.sh` on a machine with `elan`, or the first run of `.github/workflows/lean.yml`; both write `build.log` and `axiom-audit.txt`.

### Verification machinery added

- `scripts/check-lean-sources.sh` — fails on HTML/XML markup, empty files, `sorry`/`admit`, `axiom` declarations, and unresolved `LeanDAM.*` imports.
- `scripts/AxiomAudit.lean` — `#print axioms` for every public theorem and lemma.
- `scripts/axiom-audit.sh` — runs the audit, saves raw output, and enforces the standard-axiom boundary and the report count.
- `scripts/r0-verify.sh` — one-command local run writing `verification/` evidence.
- `.github/workflows/lean.yml` — on push, PR and manual dispatch: guard → elan → Mathlib cache → build → axiom audit → evidence artifact.

## Mathematical boundary

Historical source reportedly proves an exact decomposition:

\[
\Delta E_i^\mu=\bigl[N^n-(N-2)^n\bigr]+\eta_i^\mu.
\]

Conditional mean-zero noise under independent uniform non-target spin patterns is **proposed**, not yet established in Lean. Once proved, linearity yields the full conditional expected gap equal to the deterministic signal, even if the noise has nonzero variance. For fixed `n`, the signal has leading growth `2n N^(n-1)`.

The variance asymptotic, Gaussian retrieval-error estimate, and capacity scalings remain source claims, not checked theorems. No Energy Transformer architecture, circuit, energy-per-token metric, or Dynamical Mind hardware property has been formally verified here.

## Provenance

See [Claude's review](reviews/CLAUDE_REVIEW_2026-10-29.md), [DeepSeek's review](reviews/DEEPSEEK_REVIEW_2026-10-29.md), [editorial reconciliation](reviews/RECONCILIATION_2026-10-29.md), and the adopted [roadmap](ROADMAP.md). The attributed review files are retained without rewriting their conclusions.
