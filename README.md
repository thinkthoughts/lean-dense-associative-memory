# Lean Dense Associative Memory

Kernel-checked Lean 4 results on the finite Krotov–Hopfield Dense Associative Memory: the one-flip energy gap at a stored memory, its exact signal/cross-talk decomposition, and its exact conditional expectation under uniform ±1 patterns.

**Current report: [translatepi.ai/dam](https://translatepi.ai/dam/)** · Verification record: [`REPORT.md`](REPORT.md) · Next steps: [`ROADMAP.md`](ROADMAP.md)

Primary source: D. Krotov and J. J. Hopfield, [*Dense Associative Memory for Pattern Recognition*](https://arxiv.org/abs/1606.01164) (included as `1606.01164v2.pdf`). The project began with Dmitry Krotov's September 16, 2026 CU Boulder Physics Colloquium.

## Main results

Let `N` be the number of neurons, `μ` a stored memory, `i` a neuron, and `ΔE_i^μ` the energy change from flipping neuron `i` of stored pattern `ξ^μ`.

| Result | Statement | Scope | Lean declaration |
| --- | --- | --- | --- |
| 1. Exact one-flip decomposition | `ΔE_i^μ = [Nⁿ − (N−2)ⁿ] + η_i^μ` whenever the target pattern `ξ^μ` is binary | deterministic; `F = xⁿ` | [`flipEnergyGap_signal_noise_decomposition`](LeanDAM/Capacity.lean) |
| 2. Conditional mean-zero cross-talk | `E[η_i^μ \| ξ^μ] = 0` | finite uniform ±1 model; **every separation function `F`** | [`condMean_crossTalk_eq_zero`](LeanDAM/CrossTalk.lean), specialized as [`condMean_noiseTerm_eq_zero`](LeanDAM/CrossTalk.lean) |
| 3. Exact expected one-flip gap | `E[ΔE_i^μ \| ξ^μ] = Nⁿ − (N−2)ⁿ` | finite uniform ±1 model; **polynomial `F = xⁿ`** | [`condMean_flipEnergyGap_eq_signal`](LeanDAM/ExpectedGap.lean) |

The expectation in results 2 and 3 is the finite average over the target fiber `{ω | ω μ = t}` (`condMeanGivenTarget`), which is the conditional expectation given the target pattern under the uniform law on Boolean samples. Every fiber is nonempty (`targetFiber_card_pos`), and `N − 2` is computed in `ℝ`.

**Two different scopes.** The cancellation in result 2 holds for an arbitrary separation function: toggling coordinate `(ν, i)` of a non-target pattern reverses its contribution `F(a + b) − F(−a + b)` (`crossSummand_neg_of_coord_negation`, `crossSummand_toggleAt`). It therefore covers both the paper's polynomial and rectified-polynomial energies. The closed form `Nⁿ − (N−2)ⁿ` in result 3 is specific to the polynomial energy `polyF n`.

These are exact finite identities for every `N`, number of memories and power `n`. The paper's large-`N` approximation `≈ 2nNⁿ⁻¹`, its variance formula, the Gaussian error estimate and the capacity scaling `K_max = αₙNⁿ⁻¹` remain source claims. The exact finite second moment is the next checkpoint, CP6c.3.

## Verification

At `main` (`d13c271`), pinned to Lean `v4.35.0-rc2` and Mathlib `a218e50`:

- `lake build DenseAssociativeMemory`: 8,942 jobs, success.
- `bash scripts/axiom-audit.sh`: 40 of 40 declarations audited; only `propext`, `Classical.choice` and `Quot.sound`; zero `sorryAx`.
- GitHub Actions ([`.github/workflows/lean.yml`](.github/workflows/lean.yml)): integrity guard, build and axiom audit, green on `main`.
- Raw evidence: [`verification/`](verification/).

Reproduce:

```bash
lake exe cache get
bash scripts/check-lean-sources.sh
lake build DenseAssociativeMemory
bash scripts/axiom-audit.sh
```

Exact brute-force model checks of results 2 and 3 on small networks: `python3 -I scripts/cp6c1_model_check.py` and `python3 -I scripts/cp6c2_model_check.py`.

## Modules

| Module | Contents |
| --- | --- |
| [`LeanDAM/Basic.lean`](LeanDAM/Basic.lean) | overlap, generalized energy `E = −Σ F(ξ^μ·σ)`, interaction-matrix form, energy-based asynchronous update (Eq. 4) with energy non-increase for every `F`, stored-pattern stability criteria |
| [`LeanDAM/Capacity.lean`](LeanDAM/Capacity.lean) | `polyF`, one-flip energy gap, exact signal `Nⁿ − (N−2)ⁿ`, signal/noise decomposition, finite Boolean sample space and ±1 coordinate marginals |
| [`LeanDAM/CrossTalk.lean`](LeanDAM/CrossTalk.lean) | cross-talk for general `F`, coordinate-toggle involution, target-fiber conditional average, mean-zero cross-talk (CP6c.1) |
| [`LeanDAM/ExpectedGap.lean`](LeanDAM/ExpectedGap.lean) | `oneFlipSignal`, averaging over a target fiber, exact expected one-flip gap (CP6c.2) |
| [`DenseAssociativeMemory.lean`](DenseAssociativeMemory.lean) | library root importing all modules |

## Documents

- [`SPECIFICATION.md`](SPECIFICATION.md): reading points (seminar, primary paper), mathematical assumptions and checkpoint history.
- [`ROADMAP.md`](ROADMAP.md): finite-capacity track (CP6c.3 onward), numerical-update track, Energy Transformer and physical-implementation reading points.
- [`REPORT.md`](REPORT.md): verification record and trust boundary.
- [`reviews/`](reviews/): attributed Claude and DeepSeek reviews and their editorial reconciliation.
- [`docs/index.html`](docs/index.html): historical lab report, also published at [labreports.app/dam](https://labreports.app/dam/).

## Boundary

The results concern the abstract energy model. Numerical implementation guarantees (sign agreement under certified error, quantization) form a separate track in the roadmap, and hardware speed or power is an empirical question outside these proofs. [Dynamical Mind](https://dynamicalmind.com/) provides relevant architecture–hardware research context, not an implementation specification assumed here.

The project follows the leading-specification and proof-boundary practices developed at [translatepi.ai](https://translatepi.ai/).

License: [Apache 2.0](LICENSE).
