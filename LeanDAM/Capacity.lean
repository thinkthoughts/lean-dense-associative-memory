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

end LeanDAM
