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

- [ ] Specify finite neuron and memory index types.
- [ ] Specify dynamical state values.
- [ ] Specify memorized patterns.
- [ ] Define pattern-state overlap.
- [ ] Prove elementary overlap consequences needed by the energy layer.

## CP3 — Generalized DAM Energy

- [ ] Define a separation function.
- [ ] Define generalized DAM energy from overlaps.
- [ ] Define the quadratic separation function.
- [ ] State and prove that quadratic specialization recovers the displayed Hopfield overlap energy.

## CP4 — Hopfield Interaction Form

- [ ] Define the interaction matrix `Tᵢⱼ`.
- [ ] Expand the quadratic overlap energy.
- [ ] Prove equivalence with the displayed interaction-matrix form.
- [ ] Keep normalization and indexing conventions explicit.

## CP5 — Dynamics and Fixed-Point Boundary

Return to the seminar's energy-descent and fixed-point claims only after recovering their exact mathematical hypotheses from a primary source.

Candidate questions include:

- What update rule is assumed?
- Is the state discrete, continuous, or both in the relevant result?
- What conditions on `F` are required?
- In what sense is energy descending?
- What definition of stability is used?
- What hypotheses guarantee convergence or fixed-point stability?

No stronger convergence or stability theorem is inferred from RP1 alone.

## CP6 — Capacity Boundary

Use a primary source to specify the hypotheses behind the displayed capacity relations before encoding them as Lean propositions.

Distinguish:

```text
displayed scaling relation
≠ exact theorem statement
≠ empirical storage result
```

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
