# Specification

## Reading Point 0 — Seminar Abstract

**Speaker:** Dmitry Krotov
**Title:** *Dense Associative Memory: physical systems for novel AI architectures*
**Event:** CU Boulder Physics Colloquium
**Date:** September 16, 2026

This reading point uses the public seminar abstract as its source. It introduces only objects and relationships licensed by that abstract. DAM-specific mathematical relations are reserved for subsequent reading points.

### Available objects

* state space `X`
* update `F : X → X`
* energy `E : X → ℝ`
* fixed-point predicate `F x = x`
* recurrent dynamics
* fixed-point attractors
* Dense Associative Memory
* Energy Transformer
* PDE applications
* eventual physical / analog implementation

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

* [x] Define an update map.
* [x] Define fixed points.
* [x] Define an energy function.
* [x] Define iterated dynamics / orbit states.
* [x] Add elementary fixed-point consequences.

## Reading Point 1 — Seminar

The seminar provides the first opportunity to acquire an explicit DAM-specific mathematical specification.

### Acquisition targets

Record the equation together with its stated assumptions and surrounding context.

Priority targets include:

1. DAM energy function;
2. state / update equation;
3. fixed-point or attractor condition;
4. energy-descent or Lyapunov-type relation;
5. convergence statement and hypotheses;
6. storage-capacity formula or theorem;
7. DAM / attention correspondence;
8. Energy Transformer equation;
9. PDE formulation;
10. relation between the computational architecture and analog hardware.

A photographed equation should, where possible, include the preceding and following slides or notes needed to recover its assumptions.

## CP1 — Seminar Equation Acquisition

Identify an explicit mathematical relation presented in the seminar that connects at least two of:

```text
energy
dynamics
fixed points
associative memory
transformer architecture
physical implementation
```

Candidate forms to distinguish rather than assume include:

* energy descent, such as `E (F x) ≤ E x`;
* stationarity or local-minimum conditions;
* convergence to fixed points;
* storage-capacity results;
* DAM / attention correspondence;
* Energy Transformer relations.

The seminar reading point determines which statement becomes the first DAM-specific formalization target.

## CP1 Triage

After the seminar, classify the acquired target by the formal machinery it requires.

### A — Compact target

A quantitative identity, bound, or implication with modest prerequisites.

Expected route:

```text
specification
→ Lean statement
→ proof
→ report
```

### B — Structural target

An energy / dynamics / fixed-point result requiring supporting definitions and lemmas.

Expected route:

```text
specification
→ supporting mathematical layer
→ theorem
→ proof
→ report
```

### C — Extended target

A convergence, capacity, transformer, PDE, or physical-implementation result requiring substantial additional machinery.

Expected route:

```text
specification
→ prerequisite map
→ staged checkpoints
→ principal theorem
→ report
```

The classification specifies project scope rather than result importance.

## Later Checkpoints

The exact checkpoints remain conditional on CP1.

* **CP2 — DAM specification:** encode the selected DAM-specific mathematical objects and hypotheses.
* **CP3 — First stated result:** formalize one relationship licensed by the acquired source.
* **CP4 — Architecture boundary:** distinguish mathematical properties from computational implementation.
* **CP5 — Physical boundary:** specify the additional claims and measurements required for an analog physical implementation.
* **CP6 — Report boundary:** state what follows constructively from the formalization and what remains empirical.

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

Leading specifications constrain admissible generalizations.

Admissible generalizations trail leading specifications.
