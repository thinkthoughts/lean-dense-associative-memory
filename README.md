# Lean Dense Associative Memory

Lean 4 formalization of energy functions, binary asynchronous dynamics, and finite stability/capacity specifications in Dense Associative Memory. The primary mathematical reference is Krotov and Hopfield, [*Dense Associative Memory for Pattern Recognition*](https://arxiv.org/abs/1606.01164). The project began with Dmitry Krotov's September 16, 2026 CU Boulder Physics Colloquium.

The project follows the leading-specification and proof-boundary practices developed in related work at [translatepi.ai](https://translatepi.ai/).

## Status (October 29, 2026)

**The supplied HEAD `f52348e` is not a valid Lean build.** Imported `LeanDAM/Capacity.lean` contains HTML instead of Lean source. An independent historical audit identified commit `0077024` as the last Lean version. Restoration, a fresh build and an axiom audit remain pending. Previously reported successful builds do not verify the supplied HEAD.

| Layer | Source | Current status |
| --- | --- | --- |
| CP2–CP4: overlap, generalized energy, quadratic interaction identity | `LeanDAM/Basic.lean` | Proof source present; fresh build pending |
| CP5: asynchronous update and energy non-increase | `LeanDAM/Basic.lean` | Proof source present; fresh build pending |
| CP6a: stored-pattern stability | `LeanDAM/Basic.lean` | Proof source present; fresh build pending |
| CP6b: one-flip energy and signal/noise decomposition | Historical `LeanDAM/Capacity.lean@0077024` | Restore and verify |
| CP6c: finite random-pattern coordinate model | Historical `LeanDAM/Capacity.lean@0077024` | Restore and verify |
| CP6c.1+: conditional expectation, variance and tail bounds | — | Proposed |
| CP7–CP8: Energy Transformer and hardware-facing specifications | — | Reading-point work pending |

## Files

- [`SPECIFICATION.md`](SPECIFICATION.md): seminar and primary-paper reading points, mathematical assumptions and checkpoints.
- [`ROADMAP.md`](ROADMAP.md): restoration, verification, finite-capacity and numerical-refinement tasks.
- [`REPORT.md`](REPORT.md): current evidence and trust boundary.
- [`reviews/`](reviews/): Claude and DeepSeek's full reviews, preserved as attributed assessments, and the project's editorial reconciliation.
- `LeanDAM/Basic.lean`: overlap, energy, updates and deterministic stability.
- `LeanDAM/Capacity.lean`: **currently HTML; restoration pending**.
- `DenseAssociativeMemory.lean`: imports both Lean modules.
- `1606.01164v2.pdf`: included primary-source paper.

## Verification after repair

Proposed commands (not results of this documentation update):

```bash
git show 0077024:LeanDAM/Capacity.lean
lake exe cache get
lake build DenseAssociativeMemory
```

After a successful build, use `#print axioms` on critical theorems, check for `sorryAx`, and record the actual dependencies in `REPORT.md`. CI should then run the full build on push and pull request.

An exact finite energy identity does not alone establish probabilistic storage capacity; a numerical sign-preservation proof is distinct from a retrieval-error probability bound; and neither verifies hardware speed or power consumption. [Dynamical Mind](https://dynamicalmind.com/) provides relevant architecture–hardware research context, not an assumed implementation specification.

License: [Apache 2.0](LICENSE).
