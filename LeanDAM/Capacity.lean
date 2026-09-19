import LeanDAM.Basic

namespace LeanDAM

/-- Polynomial separation function `F(x) = x^n`. -/
def polyF (n : ℕ) : Separation :=
  fun x => x ^ n

/-- State obtained by negating coordinate `i`. -/
def flip
    {Neuron : Type}
    [DecidableEq Neuron]
    (σ : State Neuron)
    (i : Neuron) : State Neuron :=
  Function.update σ i (-σ i)
/--
Energy change produced by flipping neuron `i`.

At a stored memory and for polynomial separation, this is the
deterministic energy difference used in the paper's stability analysis.
-/
def flipEnergyGap
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (σ : State Neuron)
    (i : Neuron) : ℝ :=
  energy F ξ (flip σ i) - energy F ξ σ

/--
At a stored memory, the flip-energy gap for polynomial separation
is the difference between the current-overlap power sum and the
flipped-overlap power sum.
-/
theorem flipEnergyGap_stored_memory
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (n : ℕ)
    (ξ : Patterns Memory Neuron)
    (μ₀ : Memory)
    (i : Neuron) :
    flipEnergyGap (polyF n) ξ (patternState ξ μ₀) i =
      (∑ ν, (overlap ξ (patternState ξ μ₀) ν) ^ n) -
      (∑ ν, (overlap ξ
        (flip (patternState ξ μ₀) i) ν) ^ n) := by
  unfold flipEnergyGap energy polyF
  ring

/--
For a positive stored bit, flipping the bit produces the negative
candidate, so the flip-energy gap equals the Eq. (4) update gap.
-/
theorem flipEnergyGap_eq_updateGap_of_pos
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (i : Neuron)
    (h : patternState ξ μ i = 1) :
    flipEnergyGap F ξ (patternState ξ μ) i =
      updateGap F ξ (patternState ξ μ) i := by
  rw [updateGap_eq_energy_difference]
  unfold flipEnergyGap flip
  have hflip :
      Function.update (patternState ξ μ) i
          (-patternState ξ μ i) =
        candidateNeg (patternState ξ μ) i := by
    unfold candidateNeg
    rw [h]
  have hcurrent :
      candidatePos (patternState ξ μ) i =
        patternState ξ μ := by
    unfold candidatePos
    rw [← h]
    exact Function.update_eq_self i (patternState ξ μ)
  rw [hflip, hcurrent]

/--
For a negative stored bit, flipping the bit produces the positive
candidate, so the flip-energy gap is the negative of the Eq. (4)
update gap.
-/
theorem flipEnergyGap_eq_neg_updateGap_of_neg
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    (F : Separation)
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (i : Neuron)
    (h : patternState ξ μ i = -1) :
    flipEnergyGap F ξ (patternState ξ μ) i =
      -updateGap F ξ (patternState ξ μ) i := by
  rw [updateGap_eq_energy_difference]
  unfold flipEnergyGap flip
  have hflip :
      Function.update (patternState ξ μ) i
          (-patternState ξ μ i) =
        candidatePos (patternState ξ μ) i := by
    unfold candidatePos
    rw [h]
    norm_num
  have hcurrent :
      candidateNeg (patternState ξ μ) i =
        patternState ξ μ := by
    unfold candidateNeg
    rw [← h]
    exact Function.update_eq_self i (patternState ξ μ)
  rw [hflip, hcurrent]
  ring

/--
A binary stored pattern has self-overlap equal to the number of neurons.
This is the exact `N` appearing in the capacity calculation.
-/
theorem overlap_self_of_binary
    {Neuron Memory : Type}
    [Fintype Neuron]
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (hbinary : IsBinaryPattern ξ μ) :
    overlap ξ (patternState ξ μ) μ =
      (Fintype.card Neuron : ℝ) := by
  have hbinary' : ∀ i, ξ μ i = 1 ∨ ξ μ i = -1 := by
    intro i
    simpa [patternState] using hbinary i
  unfold overlap patternState
  have hterm : ∀ i, ξ μ i * ξ μ i = (1 : ℝ) := by
    intro i
    rcases hbinary' i with hpos | hneg
    · rw [hpos]
      norm_num
    · rw [hneg]
      norm_num
  simp_rw [hterm]
  simp

/--
Flipping one coordinate of a binary stored pattern changes its
self-overlap from `N` to `N - 2`.
-/
theorem overlap_self_flip_of_binary
    {Neuron Memory : Type}
    [Fintype Neuron]
    [DecidableEq Neuron]
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (i : Neuron)
    (hbinary : IsBinaryPattern ξ μ) :
    overlap ξ (flip (patternState ξ μ) i) μ =
      (Fintype.card Neuron : ℝ) - 2 := by
  have hbit : ξ μ i * ξ μ i = (1 : ℝ) := by
    rcases hbinary i with hpos | hneg
    · have hi : ξ μ i = 1 := by
        simpa [patternState] using hpos
      rw [hi]
      norm_num
    · have hi : ξ μ i = -1 := by
        simpa [patternState] using hneg
      rw [hi]
      norm_num

  have hrest :
      ∑ j ∈ Finset.univ.erase i,
          ξ μ j *
            Function.update (ξ μ) i (-ξ μ i) j =
        ∑ j ∈ Finset.univ.erase i,
          ξ μ j * ξ μ j := by
    apply Finset.sum_congr rfl
    intro j hj
    have hji : j ≠ i := by
      simpa using hj
    simp [Function.update, hji]

  have hflipped :
      overlap ξ (flip (patternState ξ μ) i) μ =
        (-1 : ℝ) +
          ∑ j ∈ Finset.univ.erase i,
            ξ μ j * ξ μ j := by
    unfold overlap flip patternState
    rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i)]
    rw [hrest]
    simp [Function.update, hbit]

  have hself :
      overlap ξ (patternState ξ μ) μ =
        (1 : ℝ) +
          ∑ j ∈ Finset.univ.erase i,
            ξ μ j * ξ μ j := by
    unfold overlap patternState
    rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i)]
    rw [hbit]

  calc
    overlap ξ (flip (patternState ξ μ) i) μ
        = (-1 : ℝ) +
            ∑ j ∈ Finset.univ.erase i,
              ξ μ j * ξ μ j := hflipped
    _ = overlap ξ (patternState ξ μ) μ - 2 := by
          rw [hself]
          ring
    _ = (Fintype.card Neuron : ℝ) - 2 := by
          rw [overlap_self_of_binary ξ μ hbinary]

/--
For polynomial separation `F(x) = x^n`, the selected stored memory
contributes exactly `N^n - (N - 2)^n` to the one-flip energy gap.
This is the exact signal term used before the paper's asymptotic
approximation.
-/
theorem self_signal_term
    {Neuron Memory : Type}
    [Fintype Neuron]
    [DecidableEq Neuron]
    (n : ℕ)
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (i : Neuron)
    (hbinary : IsBinaryPattern ξ μ) :
    (overlap ξ (patternState ξ μ) μ) ^ n -
        (overlap ξ (flip (patternState ξ μ) i) μ) ^ n =
      (Fintype.card Neuron : ℝ) ^ n -
        ((Fintype.card Neuron : ℝ) - 2) ^ n := by
  rw [overlap_self_of_binary ξ μ hbinary]
  rw [overlap_self_flip_of_binary ξ μ i hbinary]

/--
The energy-gap contribution from memories other than the selected one.
-/
def noiseTerm
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    [DecidableEq Memory]
    (n : ℕ)
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (i : Neuron) : ℝ :=
  ∑ ν ∈ Finset.univ.erase μ,
    ((overlap ξ (patternState ξ μ) ν) ^ n -
      (overlap ξ (flip (patternState ξ μ) i) ν) ^ n)

/--
The one-flip energy gap splits exactly into the selected memory's
signal contribution and the contribution from every other stored memory.
-/
theorem flipEnergyGap_signal_noise_decomposition
    {Neuron Memory : Type}
    [Fintype Neuron]
    [Fintype Memory]
    [DecidableEq Neuron]
    [DecidableEq Memory]
    (n : ℕ)
    (ξ : Patterns Memory Neuron)
    (μ : Memory)
    (i : Neuron)
    (hbinary : IsBinaryPattern ξ μ) :
    flipEnergyGap (polyF n) ξ (patternState ξ μ) i =
      ((Fintype.card Neuron : ℝ) ^ n -
        ((Fintype.card Neuron : ℝ) - 2) ^ n) +
        noiseTerm n ξ μ i := by
  rw [flipEnergyGap_stored_memory]
  unfold noiseTerm
  rw [Finset.sum_sub_distrib]
  rw [← self_signal_term n ξ μ i hbinary]
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ μ)]
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ μ)]
  ring

/--
All stored patterns are binary spin states.
-/
def AreBinaryPatterns
    {Neuron Memory : Type}
    (ξ : Patterns Memory Neuron) : Prop :=
  ∀ μ, IsBinaryPattern ξ μ

/--
A globally binary pattern collection gives a binary selected memory.
-/
theorem selected_memory_binary
    {Neuron Memory : Type}
    (ξ : Patterns Memory Neuron)
    (hbinary : AreBinaryPatterns ξ)
    (μ : Memory) :
    IsBinaryPattern ξ μ :=
  hbinary μ

/--
A pattern-collection sample: one Boolean outcome for each
(memory, neuron) coordinate.
-/
abbrev Omega (Memory Neuron : Type) :=
  Memory → Neuron → Bool

/--
The finite Boolean sample space inherits a finite enumeration from
the finite memory and neuron index types.
-/
noncomputable instance omegaFintype
    (Memory Neuron : Type)
    [Fintype Memory]
    [Fintype Neuron] :
    Fintype (Omega Memory Neuron) :=
  Fintype.ofFinite _

/-- Map a Boolean sample coordinate to a spin value in `{−1, +1}`. -/
def toPM (b : Bool) : ℝ :=
  if b then 1 else -1

/-- The real-valued pattern collection induced by a Boolean sample. -/
def patternsOf
    {Memory Neuron : Type}
    (ω : Omega Memory Neuron) :
    Patterns Memory Neuron :=
  fun μ i => toPM (ω μ i)

/--
Every sample induces an entirely binary collection of stored patterns.
This is deterministic and requires no probability assumptions.
-/
theorem areBinaryPatterns_patternsOf
    {Memory Neuron : Type}
    (ω : Omega Memory Neuron) :
    AreBinaryPatterns (patternsOf ω) := by
  intro μ i
  change toPM (ω μ i) = 1 ∨ toPM (ω μ i) = -1
  cases ω μ i <;> simp [toPM]

/-- Uniform probability law on the finite Boolean sample space. -/
noncomputable def uniformSamples
    (Memory Neuron : Type)
    [Fintype Memory]
    [Fintype Neuron] :
    PMF (Omega Memory Neuron) := by
  letI : Nonempty (Omega Memory Neuron) :=
    ⟨fun _ _ => false⟩
  exact PMF.uniformOfFintype (Omega Memory Neuron)

/--
The marginal probability law of one Boolean pattern coordinate
under the uniform sample-space distribution.
-/
noncomputable def coordinatePMF
    (Memory Neuron : Type)
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (i : Neuron) :
    PMF Bool :=
  PMF.map (fun ω : Omega Memory Neuron => ω μ i)
    (uniformSamples Memory Neuron)

/--
For a fixed coordinate `(μ, i)`, exactly half of all Boolean samples
have value `true` at that coordinate.
-/
theorem coordinate_true_fiber_card
    (Memory Neuron : Type)
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (i : Neuron) :
    Fintype.card {ω : Omega Memory Neuron // ω μ i = true} * 2 =
      Fintype.card (Omega Memory Neuron) := by
  classical
  let toggle : Omega Memory Neuron → Omega Memory Neuron :=
    fun ω μ' i' =>
      if μ' = μ ∧ i' = i then !(ω μ' i') else ω μ' i'

  have hinvol : Function.Involutive toggle := by
    intro ω
    funext μ' i'
    by_cases h : μ' = μ ∧ i' = i
    · simp [toggle, h]
    · simp [toggle, h]

  let e :
      {ω : Omega Memory Neuron // ω μ i = true} ≃
        {ω : Omega Memory Neuron // ω μ i = false} :=
    { toFun := fun ω =>
        ⟨toggle ω.1, by
          simp [toggle, ω.2]⟩
      invFun := fun ω =>
        ⟨toggle ω.1, by
          simp [toggle, ω.2]⟩
      left_inv := by
        intro ω
        apply Subtype.ext
        exact hinvol ω.1
      right_inv := by
        intro ω
        apply Subtype.ext
        exact hinvol ω.1 }

  have heq :
      Fintype.card {ω : Omega Memory Neuron // ω μ i = true} =
        Fintype.card {ω : Omega Memory Neuron // ω μ i = false} :=
    Fintype.card_congr e

  have hsplit :
      Fintype.card (Omega Memory Neuron) =
        Fintype.card {ω : Omega Memory Neuron // ω μ i = true} +
        Fintype.card {ω : Omega Memory Neuron // ω μ i = false} := by
    classical
    let f : Omega Memory Neuron → Bool := fun ω => ω μ i
    simpa [f] using
      (Fintype.card_congr
        (Equiv.sigmaFiberEquiv f)).symm

  omega

/--
A fixed Boolean coordinate is `true` with probability one half
under the uniform sample distribution.
-/
theorem coordinatePMF_true
    (Memory Neuron : Type)
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (i : Neuron) :
    coordinatePMF Memory Neuron μ i true = (2 : ENNReal)⁻¹ := by
  classical

  let FiberTrue :=
    {ω : Omega Memory Neuron // ω μ i = true}

  have hcard :
      Fintype.card (Omega Memory Neuron) =
        Fintype.card FiberTrue * 2 := by
    simpa [FiberTrue] using
      (coordinate_true_fiber_card Memory Neuron μ i).symm

  have hfiber : Nonempty FiberTrue := by
    exact ⟨⟨fun _ _ => true, rfl⟩⟩

  have hpos : 0 < Fintype.card FiberTrue := by
    exact Fintype.card_pos_iff.mpr hfiber

  have hA0 :
      ((Fintype.card FiberTrue : ℕ) : ENNReal) ≠ 0 := by
    exact_mod_cast Nat.ne_of_gt hpos

  have hAtop :
      ((Fintype.card FiberTrue : ℕ) : ENNReal) ≠ ⊤ := by
    simp

  have hcardENN :
      (Fintype.card (Omega Memory Neuron) : ENNReal) =
        (Fintype.card FiberTrue : ENNReal) * 2 := by
    exact_mod_cast hcard

  calc
    coordinatePMF Memory Neuron μ i true
        =
        (coordinatePMF Memory Neuron μ i).toOuterMeasure {true} := by
          exact
            (PMF.toOuterMeasure_apply_singleton
              (coordinatePMF Memory Neuron μ i) true).symm

    _ =
        (uniformSamples Memory Neuron).toOuterMeasure
          {ω : Omega Memory Neuron | ω μ i = true} := by
          unfold coordinatePMF
          rw [PMF.toOuterMeasure_map_apply]
          congr 1

    _ =
        (Fintype.card
            {ω : Omega Memory Neuron // ω μ i = true} : ENNReal) /
          Fintype.card (Omega Memory Neuron) := by
          unfold uniformSamples
          exact
            PMF.toOuterMeasure_uniformOfFintype_apply
              (s := {ω : Omega Memory Neuron | ω μ i = true})

    _ =
        (Fintype.card FiberTrue : ENNReal) /
          Fintype.card (Omega Memory Neuron) := by
          rfl

    _ =
        (Fintype.card FiberTrue : ENNReal) /
          ((Fintype.card FiberTrue : ENNReal) * 2) := by
          rw [hcardENN]

    _ = (2 : ENNReal)⁻¹ := by
          rw [div_eq_mul_inv]
          rw [ENNReal.mul_inv
            (Or.inl hA0)
            (Or.inl hAtop)]
          exact ENNReal.mul_inv_cancel_left hA0 hAtop

/--
A fixed Boolean coordinate is `false` with probability one half
under the uniform sample distribution.
-/
theorem coordinatePMF_false
    (Memory Neuron : Type)
    [Fintype Memory]
    [Fintype Neuron]
    (μ : Memory)
    (i : Neuron) :
    coordinatePMF Memory Neuron μ i false = (2 : ENNReal)⁻¹ := by
  let p := coordinatePMF Memory Neuron μ i

  have hsum : p true + p false = 1 := by
    simpa [p, tsum_bool] using PMF.tsum_coe p

  have htrue : p true = (2 : ENNReal)⁻¹ := by
    simpa [p] using coordinatePMF_true Memory Neuron μ i

  rw [htrue] at hsum

  apply (ENNReal.add_left_inj (by simp : (2 : ENNReal)⁻¹ ≠ ⊤)).mp

  calc
    coordinatePMF Memory Neuron μ i false + (2 : ENNReal)⁻¹
        = 1 := by
          simpa [p, add_comm] using hsum
    _ = (2 : ENNReal)⁻¹ + (2 : ENNReal)⁻¹ := by
          symm
          exact ENNReal.inv_two_add_inv_two

end LeanDAM
