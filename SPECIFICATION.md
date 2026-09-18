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

### Energy-normalization refinement

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

The primary source separately displays the conventional standard associative-memory energy with normalization

```text
E_standard
= - 1/2 Σᵢ Σⱼ Tᵢⱼ σᵢ σⱼ.
```

The paper states that its polynomial `n = 2` model reduces to the standard associative-memory model.

RP2 therefore refines the RP1 wording: CP4 proves the interaction-matrix expansion of the quadratic generalized energy. Literal identification with the separately displayed standard energy requires accounting for its normalization convention.

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

### First theorem target

Prove

```text
E(updateᵢ(σ)) ≤ E(σ).
```

The structural reason is that the current binary state already has either `−1` or `+1` at neuron `i`; it is therefore one of the two candidate configurations considered by the update.

### Source-correspondence target

After proving abstract energy monotonicity, specialize the construction to the DAM energy and recover the energy comparison represented by Eq. (4).

The exact Lean representation of binary states, tie behavior, and the Eq. (4) correspondence should be fixed before implementation.

Do not substitute an induced-field update.

### CP5 stopping condition

CP5 is complete where Lean verifies:

1. a binary-state representation compatible with CP2–CP4;
2. replacement of one neuron by either binary value;
3. the energy-based single-neuron update;
4. non-increase of energy under that update;
5. the justified Eq. (4) correspondence, if it belongs naturally in this checkpoint.

Fixed-point stability and capacity are not prerequisites for CP5.

## CP6 — Stability and Capacity Boundary

CP6 begins only after CP5 establishes the source-specific binary dynamics.

The next specification must distinguish

```text
deterministic one-step energy monotonicity
≠ stability of a stored pattern
≠ probabilistic storage capacity
≠ asymptotic capacity scaling.
```

Any formalization of the paper's capacity results must make explicit the random-pattern model, equiprobable binary components, stability criterion, asymptotic regime, Gaussian approximation, and error threshold.

No capacity theorem is inferred from CP2–CP5 alone.

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
