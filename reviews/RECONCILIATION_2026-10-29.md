# Editorial reconciliation — October 29, 2026

The Claude and DeepSeek reviews are retained verbatim in this directory. They are independent, attributed technical assessments, **not** fresh Lean kernel checks. This document records which conclusions are adopted in `ROADMAP.md`.

## Agreed findings

- Imported `LeanDAM/Capacity.lean` at `f52348e` contains HTML and blocks normal Lean compilation. The historical review identifies `0077024` as the last Lean source; restoration and verification are still pending.
- Existing deterministic overlap/energy/update mathematics provides a useful foundation, but source inspection does not establish a current successful build or an axiom footprint.
- The paper's variance asymptotic, Gaussian error estimate and capacity scaling are separate from exact finite identities.
- A mathematical energy landscape is not a measured analog or chip implementation.

## Correction: mean versus variance

DeepSeek's criticism of the full mean energy gap conflicts with its own stated mean-zero noise hypothesis. If `ΔE = S + η` and `E[η | target] = 0`, linearity gives `E[ΔE | target] = S` even when the variance of `η` is positive. The roadmap therefore asks for a mean-zero proof first and the expected-gap identity second. Both remain proposed. For fixed positive degree `n`, `N^n - (N-2)^n` has leading growth `2n N^(n-1)`, not `N^n`.

## Two distinct sign theorems

- **Probabilistic retrieval:** bound the probability that the *exact* gap has the wrong sign. Requires variance/tail bounds, not just expectation.
- **Numerical sign preservation:** show that a *computed* gap has the exact gap's sign when its certified absolute error is less than an appropriate nonzero margin. This is deterministic and independent of the expectation theorem.

The roadmap uses `CP6c.4` for stochastic error bounds and `B1–B4` for numerical refinement. The earlier use of “CP8a” for both is not retained.

## Further proof boundaries

- Retain the conventional Hopfield `1/2` normalization and diagonal terms when comparing exact energies.
- The Lean update selects `+1` on ties; one-flip local minimality and fixed-point stability need not agree at `−1` tie states.
- Compare historical `polyF` against the paper's rectified polynomial before claiming source-level equivalence.
- The reviews' zero-`sorry` source inspection is provisional until the restored code builds and `#print axioms` confirms there is no `sorryAx`.

**Decision:** Preserve both original reviews, repair the source and verify the baseline, then prioritize exact conditional mean-zero noise. Keep numerical update agreement as a separate hardware-relevant mathematical track, without claims about proprietary implementations.
