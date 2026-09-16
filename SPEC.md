# Specification

## Reading point 0 — seminar abstract

### Available objects

- state space `X`
- update `F : X → X`
- energy `E : X → ℝ`
- fixed-point predicate `F x = x`
- recurrent dynamics
- fixed-point attractors
- Dense Associative Memory
- Energy Transformer
- eventual physical / analog implementation

### Leading distinctions

```text
energy function
≠ update rule
≠ fixed-point condition
≠ physical implementation
```

The initial Lean scaffold specifies generic mathematical objects only. It does not yet encode a DAM-specific energy formula, convergence theorem, storage-capacity theorem, or transformer correspondence.

## CP0 — scaffold

- [x] Define an update map.
- [x] Define fixed points.
- [x] Define an energy function.
- [x] Define iterated dynamics / orbit states.
- [x] Add elementary fixed-point consequences.

## CP1 — seminar equation acquisition

Identify the first explicit mathematical relation presented in the seminar that connects DAM energy, dynamics, and fixed points.

Candidate forms to distinguish rather than assume include:

- energy descent, such as `E (F x) ≤ E x`
- stationarity or local-minimum conditions
- convergence to fixed points
- storage-capacity results
- DAM / attention or Energy Transformer correspondence

The seminar reading point determines which statement becomes the first DAM-specific formalization target.

## Later checkpoints

- CP2 — encode the DAM-specific energy function and its hypotheses.
- CP3 — formalize one stated property of the dynamics.
- CP4 — separate mathematical architecture from computational implementation.
- CP5 — specify claims needed for an analog physical implementation.
