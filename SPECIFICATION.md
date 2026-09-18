# Specification

## Reading Point 0 — Seminar Abstract

**Speaker:** Dmitry Krotov  
**Title:** *Dense Associative Memory: physical systems for novel AI architectures*  
**Event:** CU Boulder Physics Colloquium  
**Date:** September 16, 2026

This reading point uses the public seminar abstract as its source. It introduces only objects and relationships licensed by that abstract. DAM-specific mathematical relations are reserved for subsequent reading points.

### Available objects

- state space `X`
- update `F : X → X`
- energy `E : X → ℝ`
- fixed-point predicate `F x = x`
- recurrent dynamics
- fixed-point attractors
- Dense Associative Memory
- Energy Transformer
- PDE applications
- eventual physical / analog implementation

### Leading distinctions

```text
energy function
≠ update rule
≠ fixed-point condition
≠ computational architecture
≠ physical implementation
```

The initial Lean scaffold specifies generic mathematical objects. DAM-specific energy formulas, convergence results, storage-capacity results, transformer correspondences, and physical implementation claims require additional reading points.

## CP0 — Generic Scaffold

- [x] Define an update map.
- [x] Define fixed points.
- [x] Define an energy function.
- [x] Define iterated dynamics / orbit states.
- [x] Add elementary fixed-point consequences.

## Reading Point 1 — Seminar

**Source:** photographs from the September 16, 2026 CU Boulder Physics Colloquium.

RP1 supplies explicit mathematical relations and stated conceptual connections that were left open at RP0.

### Acquired mathematical specification

The seminar repeatedly compared the classical Hopfield energy with Dense Associative Memory.

For dynamical variables `σᵢ ∈ {±1}`, memorized patterns `ξᵢᵘ`, `D` neurons, and `K` memories, the displayed Hopfield energy was

```text
E = - Σᵤ (Σᵢ ξᵢᵘ σᵢ)²
```

together with an interaction-matrix representation using

```text
Tᵢⱼ = Σᵤ ξᵢᵘ ξⱼᵘ.
```

The Dense Associative Memory generalization was displayed as

```text
E = - Σᵤ F(Σᵢ ξᵢᵘ σᵢ),
```

with the example separation function

```text
F(x) = xⁿ.
```

This supplies a DAM-specific energy specification for the next formalization layer.

### Energy, dynamics, and memories

The seminar described energy-based associative memory through energy minimization:

- local minima are called memories;
- memory recall proceeds through nonlinear dynamics of energy descent;
- a query with missing or noisy data evolves toward low-energy states;
- association occurs through the nonlinear dynamics between the initial state and the final state at convergence.

The conclusion slide separately stated mathematically guaranteed fixed-point stability.

RP1 therefore supplies relationships among energy, dynamics, memories, and fixed points, while the exact hypotheses required for a formal stability or convergence theorem remain to be recovered from a primary source.

### Capacity statements

The comparison slides displayed the classical Hopfield capacity as approximately

```text
Kmax ≈ 0.14 D
```

and displayed DAM capacity forms including

```text
Kmax ≈ αₙ Dⁿ⁻¹
```

and

```text
Kmax ≈ 2^(D/2).
```

These are retained as RP1 seminar statements. Their precise regimes, asymptotic meanings, constants, and hypotheses require a primary-source reading point before formalization as mathematical theorems.

### Energy Transformer

The seminar characterized the Energy Transformer simultaneously as:

- a transformer that evolves tokens using attention;
- an energy-based model in which inference minimizes energy;
- an associative memory with attractor and error-correcting capabilities.

A later slide compared attention energy, which is low where keys align with queries, with Hopfield energy, which is low where tokens resemble memories, and presented Energy Transformer dynamics in terms of energy minimization.

This establishes an RP1 architecture connection. Exact Energy Transformer formulas and hypotheses are reserved for a primary-source reading point.

### Applications

The seminar presented applications including:

- image processing;
- language modeling;
- physical simulation / operator learning;
- analog physical implementation.

These applications establish scope and motivation at RP1. Technical claims about each application require their cited primary sources before becoming Lean targets.

### Physical implementation and efficiency boundary

The analog-hardware slide stated:

```text
Energy landscape = computational program
implemented on an analog chip
```

and connected the energy formulation to an analog circuit implementation.

The speaker also identified computational efficiency as an important motivation in the context of increasing token demand.

RP1 therefore establishes the proposed chain

```text
mathematical energy specification
→ computational architecture
→ physical implementation
```

while hardware efficiency remains a measurable engineering property requiring explicit metrics, workloads, devices, and empirical evidence.

## CP1 — Seminar Equation Acquisition

- [x] Acquire an explicit DAM energy function.
- [x] Acquire the Hopfield / DAM mathematical comparison.
- [x] Identify the separation-function generalization `F(x) = xⁿ`.
- [x] Acquire an energy-minimization interpretation of associative recall.
- [x] Acquire a stated fixed-point stability claim.
- [x] Acquire capacity statements for Hopfield and DAM models.
- [x] Acquire a DAM / Energy Transformer connection.
- [x] Acquire a physical / analog implementation connection.
- [x] Identify efficiency as an engineering motivation.

CP1 is complete as an acquisition checkpoint.

## CP1 Triage

**Classification: B — Structural target, with an A-sized initial mathematical core.**

The seminar supplies enough structure for an energy / dynamics / fixed-point project, but the first deliverable can remain a compact algebraic formalization.

The classification specifies project scope rather than result importance.

### Initial formalization boundary

The first formal target is the DAM energy hierarchy rather than capacity, transformer behavior, or hardware efficiency.

Define the pattern-state overlap

```text
overlap μ σ = Σᵢ ξᵢᵘ σᵢ
```

and generalized DAM energy

```text
E_F(σ) = - Σᵤ F(overlap μ σ).
```

Then specialize to

```text
F(x) = x².
```

Candidate first result:

> The quadratic specialization of the generalized DAM energy recovers the displayed quadratic Hopfield energy.

A second algebraic target is the interaction-matrix expansion

```text
- Σᵤ (Σᵢ ξᵢᵘ σᵢ)²
=
- Σᵢⱼ σᵢ (Σᵤ ξᵢᵘ ξⱼᵘ) σⱼ.
```

The exact finite-index representation used in Lean may refine the notation while preserving this mathematical specification.

## CP2 — Pattern / State Overlap

- [x] Specify finite neuron and memory index types.
- [x] Specify dynamical state values.
- [x] Specify memorized patterns.
- [x] Define pattern-state overlap.
- [x] Prove elementary overlap consequences needed by the energy layer.

CP2 is complete.

The algebraic layer uses real-valued states and patterns. This is a deliberate generalization of the binary state space presented at RP1. Its admissibility for CP2–CP4 follows from the algebraic statements proved there; source-specific dynamics are revisited at RP2.

## CP3 — Generalized DAM Energy

- [x] Define a separation function.
- [x] Define generalized DAM energy from overlaps.
- [x] Define the quadratic separation function.
- [x] State and prove that quadratic specialization recovers the displayed quadratic overlap energy.

CP3 is complete.

## CP4 — Interaction-Matrix Expansion

- [x] Define the interaction matrix `Tᵢⱼ`.
- [x] Expand the quadratic overlap energy.
- [x] Prove equivalence with the interaction-matrix form.
- [x] Keep normalization and indexing conventions explicit.

CP4 is complete.

Lean verifies

```text
E_F
→ F(x) = x²
→ E₂ = - Σᵤ (Σᵢ ξᵢᵘ σᵢ)²
→ Tᵢⱼ = Σᵤ ξᵢᵘ ξⱼᵘ
→ E₂ = - Σᵢ Σⱼ σᵢ Tᵢⱼ σⱼ.
```

This is the interaction-matrix expansion of the quadratic generalized energy.

RP2 refines the relationship between this identity and the conventional Hopfield normalization.

## Reading Point 2 — Krotov–Hopfield Dense Associative Memory

**Source:** Dmitry Krotov and John J. Hopfield, *Dense Associative Memory for Pattern Recognition*, arXiv:1606.01164v2.

RP2 recovers the primary-source hypotheses needed to refine the dynamics, stability, and capacity boundaries left open at RP1.

### Binary state-space refinement

The source begins with `N` binary neurons whose states take values in

```text
{−1, +1}.
```

Stored memories are initially binary patterns as well.

CP2–CP4 use real-valued states and patterns. That representation is sufficient for the algebraic identities proved there. RP2 narrows the admissible state space for source-specific asynchronous dynamics, stability, and capacity statements.

Thus

```text
real-valued algebraic state
≠ source-specific binary dynamical state.
```

The former remains the verified CP2–CP4 layer. The latter is introduced where required beginning at CP5.

### Quadratic-energy convention refinement

The generalized DAM energy in the primary source is

```text
E_F(σ) = - Σᵤ F(Σᵢ ξᵢᵘ σᵢ).
```

For the polynomial choice

```text
F(x) = x²,
```

CP3 and CP4 verify

```text
E₂(σ)
= - Σᵤ (Σᵢ ξᵢᵘ σᵢ)²
= - Σᵢ Σⱼ σᵢ Tᵢⱼ σⱼ,
```

where

```text
Tᵢⱼ = Σᵤ ξᵢᵘ ξⱼᵘ.
```

The primary source separately displays the conventional standard associative-memory energy as

```text
E_standard
= - 1/2 Σᵢ Σⱼ Tᵢⱼ σᵢ σⱼ.
```

RP2 therefore records two distinct convention boundaries.

First, the displayed standard energy carries a factor `1/2`, while the direct CP4 expansion of the generalized quadratic energy does not. This is a multiplicative normalization difference.

Second, the CP4 expansion includes same-index terms `i = j`. For binary spin states,

```text
σᵢ² = 1,
```

so the diagonal contribution is state-independent. It therefore changes the energy by an additive constant rather than changing the ordering of binary configurations.

These distinctions leave the qualitative CP5 energy-comparison result unchanged: positive rescaling and addition of a state-independent constant preserve energy ordering.

They must nevertheless remain explicit for CP6, where exact energy differences, mean gaps, variances, and capacity coefficients depend on the precise Hamiltonian and update conventions.

The paper states that its polynomial `n = 2` model reduces to the standard associative-memory model. CP4 should therefore be described as the interaction-matrix expansion of the quadratic generalized energy, with normalization and same-index conventions tracked separately from the conventional displayed form.

### Asynchronous energy-based dynamics

After defining the generalized energy, the source specifies an asynchronous update rule in which one neuron is updated at a time.

For a selected neuron `i`, all other neuron states remain fixed while the energy is compared between the two candidate configurations

```text
σ[i ↦ −1]
```

and

```text
σ[i ↦ +1].
```

Equation (4) expresses the selected binary value using the sign of this energy difference.

The update chooses a neuron value so that the energy of the entire configuration decreases or remains unchanged.

The source explicitly distinguishes this energy-difference rule from updates based on induced magnetic fields. The rules differ slightly because self-coupling terms are present.

Therefore CP5 must formalize the source's energy-based update rather than substitute a conventional Hopfield field update.

### Stability and capacity assumptions

The source's capacity analysis introduces additional assumptions:

- stored memories are random binary patterns;
- each memory component takes `−1` or `+1` with equal probability;
- the system is initialized at one of the stored memories;
- stability is examined against a one-neuron flip;
- the calculation separates a mean energy gap from fluctuations;
- the stated error estimate uses an effectively Gaussian noise approximation in the large-`N`, large-`K` regime.

For a selected error threshold, the paper gives the scaling

```text
Kmax = αₙ Nⁿ⁻¹,
```

where `αₙ` depends on that threshold.

For the stronger perfect-recovery condition it uses

```text
Perror < 1/N
```

and derives a corresponding asymptotic expression.

These probabilistic and asymptotic statements require specifications beyond the deterministic CP2–CP5 algebra.

## CP5 — Binary Asynchronous Energy Update

### Formalization target

Introduce the smallest binary-state layer required by RP2 without replacing the verified real-valued CP2–CP4 API.

For a binary state `σ` and neuron `i`, specify the candidate states

```text
σ[i ↦ −1]
σ[i ↦ +1].
```

Define an asynchronous single-neuron update by comparing their energies and selecting a lower-energy candidate.

### Verified binary dynamics

Lean defines the binary-state predicate

```text
IsSpinState σ
```

together with the two candidate configurations

```text
candidateNeg σ i = σ[i ↦ −1]
candidatePos σ i = σ[i ↦ +1].
```

The update `stepAt` compares the energies of these candidates and selects the positive candidate where

```text
E(candidatePos σ i) ≤ E(candidateNeg σ i),
```

and the negative candidate otherwise.

Thus the implementation fixes the tie convention explicitly:

```text
equal candidate energies → +1.
```

Lean verifies

```text
E(stepAt F ξ σ i) ≤ E(σ)
```

for every binary spin state `σ`.

Lean also verifies that a single asynchronous update preserves the binary-state constraint.

### Equation (4) correspondence

Define the clamped overlap excluding neuron `i` by

```text
clampedOverlap μ σ i
= Σ_{j ≠ i} ξⱼᵘ σⱼ.
```

Lean verifies the two candidate-overlap identities

```text
overlap μ (σ[i ↦ +1])
= ξᵢᵘ + clampedOverlap μ σ i
```

and

```text
overlap μ (σ[i ↦ −1])
= -ξᵢᵘ + clampedOverlap μ σ i.
```

Define

```text
updateGap
= Σᵤ [
    F(ξᵢᵘ + clampedOverlap μ σ i)
    -
    F(-ξᵢᵘ + clampedOverlap μ σ i)
  ].
```

This is the energy-comparison expression appearing inside the sign in Krotov–Hopfield Eq. (4).

Lean verifies

```text
updateGap
=
E(candidateNeg σ i)
-
E(candidatePos σ i).
```

Therefore the sign comparison in Eq. (4) is recovered directly from the generalized DAM energy: a positive `updateGap` means the `+1` candidate has lower energy, while a negative `updateGap` means the `−1` candidate has lower energy.

The Lean update uses the explicit tie convention `updateGap = 0 → +1` rather than adding an independent convention for `Sign(0)`.

No induced-field update is substituted.

### CP5 stopping condition

- [x] Specify a binary-state representation compatible with CP2–CP4.
- [x] Specify replacement of one neuron by either binary value.
- [x] Define the energy-based single-neuron update.
- [x] Prove non-increase of energy under that update.
- [x] Recover the energy comparison represented by Krotov–Hopfield Eq. (4).

CP5 is complete.

Lean verifies the source-specific chain

```text
binary state
→ two single-neuron candidate states
→ energy comparison
→ asynchronous update
→ non-increasing energy
→ Eq. (4) energy-gap correspondence.
```

Fixed-point stability and capacity remain separate specifications and are not inferred from CP5.

## CP6 — Stability and Capacity Boundary

CP6 begins only after CP5 establishes the source-specific binary dynamics.

The specification distinguishes

```text
deterministic one-step energy monotonicity
≠ deterministic stability of a stored pattern
≠ probability that random stored patterns satisfy a stability criterion
≠ probabilistic storage capacity
≠ asymptotic capacity scaling.
```

### CP6a — Deterministic stored-pattern stability

A stored pattern `μ` is viewed as the network state

```text
patternState ξ μ = ξ μ.
```

The source-specific binary restriction is recorded by

```text
IsBinaryPattern ξ μ.
```

Lean defines deterministic stability under the verified asynchronous update by

```text
IsStablePattern F ξ μ
:= ∀ i, stepAt F ξ (patternState ξ μ) i = patternState ξ μ.
```

Thus stability is a fixed-point property of every single-neuron update, rather than a consequence inferred merely from non-increase of energy.

Because `stepAt` resolves equal candidate energies toward `+1`, the exact candidate-energy criterion is asymmetric. For a binary stored pattern, Lean verifies stability where every neuron satisfies

```text
patternState ξ μ i = +1
→ E(candidatePos) ≤ E(candidateNeg)

patternState ξ μ i = -1
→ E(candidateNeg) < E(candidatePos).
```

The strict inequality in the second branch is a consequence of the explicit tie convention, rather than an additional physical assumption.

Using the CP5 identity

```text
updateGap = E(candidateNeg) - E(candidatePos),
```

Lean also verifies the equivalent sufficient gap criterion

```text
patternState ξ μ i = +1
→ 0 ≤ updateGap

patternState ξ μ i = -1
→ updateGap < 0.
```

Therefore the verified deterministic chain is

```text
binary stored pattern
→ Eq. (4) update-gap sign at each neuron
→ local candidate-energy preference
→ fixed stored pattern under each asynchronous update.
```

- [x] Represent a stored pattern as a network state.
- [x] Specify the binary stored-pattern condition.
- [x] Define stability under every asynchronous single-neuron update.
- [x] Prove a candidate-energy criterion sufficient for stored-pattern stability.
- [x] Translate that criterion into the Eq. (4) `updateGap` quantity.

CP6a is complete.

### CP6b — Probabilistic stability and capacity target

CP6b changes mathematical regimes. The deterministic CP6a theorem specifies what must hold at every neuron of a particular stored pattern. It does not specify how often that condition holds for randomly generated memories.

The primary source's capacity analysis adds a random-pattern model in which stored memories are binary and each component takes `−1` or `+1` with equal probability. The system is initialized at a stored memory and stability is examined through the energy change associated with a one-neuron flip.

Before a capacity theorem is admissible, the formalization must specify separately:

- the probability space for stored binary patterns;
- equiprobable and required independence assumptions for pattern components;
- the selected stored pattern and neuron used in the local stability calculation;
- the random energy gap or equivalent stability quantity;
- its mean and fluctuation terms under the source's assumptions;
- the large-`N`, large-`K` regime used for the approximation;
- the Gaussian approximation used in the error estimate;
- the chosen single-neuron error threshold;
- the stronger perfect-recovery criterion where applicable.

Only after those specifications may the source's capacity statements such as

```text
Kmax = αₙ Nⁿ⁻¹
```

or its perfect-recovery asymptotic expression become formalization targets.

The CP6 boundary is therefore

```text
verified deterministic gap criterion
→ specified random-pattern model
→ probabilistic stability calculation
→ stated approximation regime
→ capacity scaling.
```

No probabilistic capacity theorem is inferred from CP2–CP6a alone.

## CP6c — Random-pattern capacity model

### Reading point

CP6b.3 established the exact deterministic decomposition

\[
\Delta E_i^\mu
=
\left[N^n-(N-2)^n\right]
+
\operatorname{noiseTerm}.
\]

No probability assumptions are required for that identity.

### Random-pattern specification

For the capacity analysis, fix:

- a selected stored memory \(\mu\),
- a neuron \(i\),
- polynomial separation \(F(x)=x^n\).

Treat the stored pattern coordinates as independent equiprobable binary
random variables:

\[
\Pr(\xi_j^\nu=+1)
=
\Pr(\xi_j^\nu=-1)
=
\frac12.
\]

The network state is initialized exactly at the selected stored memory
\(\xi^\mu\).

### Stability event

The exact one-flip energy condition is

\[
\Delta E_i^\mu \ge 0.
\]

This local energy-stability condition is distinct from deterministic
`stepAt` fixed-point stability because `stepAt` resolves ties toward
`+1`.

### Exact signal

The selected-memory contribution is exactly

\[
S_N(n)=N^n-(N-2)^n.
\]

### Asymptotic signal

For large \(N\),

\[
S_N(n)
\sim
2nN^{n-1}.
\]

This is an asymptotic approximation, not an exact identity.

### Noise variance

Under the independent random-pattern model, the paper gives the
large-\(N\) variance

\[
\Sigma^2
=
\Omega_n(K-1)N^{n-1},
\qquad
\Omega_n
=
4n^2(2n-3)!!.
\]

This belongs to the probabilistic/asymptotic layer and is not implied
by CP6b.3 alone.

### Gaussian approximation

For large \(N\) and \(K\), the paper approximates the noise by a
Gaussian distribution and uses the corresponding tail probability
to estimate a one-neuron retrieval error.

The Gaussian approximation must remain explicitly marked as an
approximation rather than a theorem derived from the deterministic
energy identity.

### Capacity scaling

For a fixed single-neuron error threshold, the paper obtains

\[
K_{\max}
=
\alpha_n N^{n-1}.
\]

The coefficient \(\alpha_n\) depends on the chosen error threshold.

The stronger no-error criterion uses a different scaling:

\[
K_{\max}^{\mathrm{no\ errors}}
\approx
\frac{1}{2(2n-3)!!}
\frac{N^{n-1}}{\ln N}.
\]

### Specification boundary

Exact deterministic identity
\[
\neq
\]
random-pattern assumption
\[
\neq
\]
large-\(N\) variance formula
\[
\neq
\]
Gaussian approximation
\[
\neq
\]
capacity scaling.

## CP7 — Energy Transformer Boundary

Use the cited Energy Transformer primary source before formalizing attention-energy or transformer correspondence claims.

Preserve the distinction:

```text
DAM energy
≠ attention energy
≠ combined Energy Transformer energy
≠ implementation of inference dynamics
```

## CP8 — Physical Implementation and Efficiency

Use the cited analog-circuit primary source to specify the mapping from mathematical energy to circuit quantities.

Separate:

```text
specified energy landscape
→ specified computational architecture
→ specified physical circuit
→ measured efficiency
```

An efficiency comparison requires explicit engineering measurements or assumptions such as workload, energy or power, latency, accuracy, throughput, and hardware platform.

## CP9 — Report Boundary

State separately:

- what follows algebraically from the formalized energy specification;
- what follows from additional mathematical hypotheses;
- what is reported by the cited computational studies;
- what remains an empirical property of physical implementations.

## Reading Point 2+ — Primary Sources

RP2+ should be split by claim rather than treated as one undifferentiated literature layer.

Candidate primary-source tracks identified by the seminar include:

1. Dense Associative Memory / large associative memory.
2. Energy Transformer.
3. Energy-based language modeling.
4. Operator learning / physical simulation.
5. Dense Associative Memories with analog circuits.

Each source may refine, narrow, correct, or supersede an RP1 statement without rewriting RP1.

## Evidence Discipline

Each DAM-specific statement should identify its reading point.

```text
public abstract
→ RP0

seminar slide / speaker statement
→ RP1

paper or other primary source
→ RP2+

our derived Lean consequence
→ theorem / lemma
```

This gives two independent axes of separation:

```text
OBJECT
energy ≠ update ≠ fixed point ≠ architecture ≠ implementation

EVIDENCE
abstract → seminar → primary paper → derived theorem
   RP0       RP1          RP2+           Lean
```

### Revision rule

A later reading point may refine, narrow, correct, or supersede an earlier reading point.

Earlier statements remain attributed to their original reading points rather than being silently overwritten. A superseded statement is marked as superseded and linked to the reading point that changed its status.

```text
RP1 claim
→ RP2 refinement
→ current specification
```

A revision changes the admissible specification from that reading point forward; it does not rewrite the earlier reading point.

## Specification Grammar

The closing statements intentionally express the relation in two directions:

**Constraint:** leading specification → constraint on generalization.  
**Ordering:** generalization → must trail its specification.

Leading specifications constrain admissible generalizations.

Admissible generalizations trail leading specifications.
