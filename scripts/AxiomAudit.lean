import DenseAssociativeMemory

/-! Axiom audit for Gate R0. Run with `lake env lean scripts/AxiomAudit.lean`. -/

#print axioms LeanDAM.energy_quadratic
#print axioms LeanDAM.energy_quadratic_interaction
#print axioms LeanDAM.energy_stepAt_le
#print axioms LeanDAM.stepAt_isSpinState
#print axioms LeanDAM.overlap_candidatePos
#print axioms LeanDAM.overlap_candidateNeg
#print axioms LeanDAM.updateGap_eq_energy_difference
#print axioms LeanDAM.stablePattern_of_candidate_energy
#print axioms LeanDAM.stablePattern_of_updateGap
#print axioms LeanDAM.flipEnergyGap_stored_memory
#print axioms LeanDAM.flipEnergyGap_eq_updateGap_of_pos
#print axioms LeanDAM.flipEnergyGap_eq_neg_updateGap_of_neg
#print axioms LeanDAM.overlap_self_of_binary
#print axioms LeanDAM.overlap_self_flip_of_binary
#print axioms LeanDAM.self_signal_term
#print axioms LeanDAM.flipEnergyGap_signal_noise_decomposition
#print axioms LeanDAM.selected_memory_binary
#print axioms LeanDAM.areBinaryPatterns_patternsOf
#print axioms LeanDAM.coordinate_true_fiber_card
#print axioms LeanDAM.coordinatePMF_true
#print axioms LeanDAM.coordinatePMF_false
#print axioms LeanDAM.patternCoordinate_pm_half
