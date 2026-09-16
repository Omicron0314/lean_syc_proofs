/-
Copyright (c) 2026 The Formal Conjectures Authors, Omicron0314. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Formal Conjectures Authors, Omicron0314
-/
import Mathlib.Data.Finset.NatAntidiagonal
import Mathlib.Order.Interval.Set.Nat
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Tactic

/-!
# JSP-000998 / Erdős problem 1193: densities of additive representation matches.
Original reference: P. Erdős, A survey of problems in combinatorial number theory,
Ann. Discrete Math. (1980), 89–115; https://www.erdosproblems.com/1193.

Statement and definition reference (Apache 2.0), adapted to a standalone Mathlib project:
https://github.com/google-deepmind/formal-conjectures/tree/40e7c98697de6f66b8cbdbf641749ab39ed9c152
  FormalConjectures/ErdosProblems/1193.lean
  FormalConjecturesForMathlib/Combinatorics/Additive/Convolution.lean
  FormalConjecturesForMathlib/Data/Set/Density.lean

Natural numbers include zero. Ordered pairs (a,b) with a+b=n are counted, including
a=b. Densities are the real liminf/limsup of |S ∩ [0,N)| / N as N tends to infinity.
The two final negations preserve the quantifiers of parts i and ii of the reference.

The known counterexample A=ℕ, g(n)=n+1 is recorded by the reference and by
Pietro Monticone / Aristotle's earlier formalization, cited in STATEMENT.md.
This development adds explicit density conclusions and both complete negations;
it claims neither mathematical discovery nor first formalization. Prepared with Codex.
-/

namespace LeanSyc.JSP000998

open Filter

/-- Ordered additive representations, in the finite-cardinality form of `sumRep_def`. -/
noncomputable def sumRep (A : Set ℕ) (n : ℕ) : ℕ := by
  classical
  exact ((Finset.antidiagonal n).filter fun p => p.1 ∈ A ∧ p.2 ∈ A).card

/-- Natural density approximant, with the same `[0,N)` convention as the reference. -/
noncomputable def partialDensity (S : Set ℕ) (N : ℕ) : ℝ :=
  (S ∩ Set.Iio N).ncard / (N : ℝ)

noncomputable def lowerDensity (S : Set ℕ) : ℝ :=
  atTop.liminf (partialDensity S)

noncomputable def upperDensity (S : Set ℕ) : ℝ :=
  atTop.limsup (partialDensity S)

/-- The definition is the indicator convolution, not an unordered-pair count. -/
theorem sumRep_eq_indicator_convolution (A : Set ℕ) (n : ℕ) :
    sumRep A n = ∑ p ∈ Finset.antidiagonal n,
      A.indicator (fun _ => (1 : ℕ)) p.1 * A.indicator (fun _ => (1 : ℕ)) p.2 := by
  classical
  simp only [sumRep, Finset.card_filter, Set.indicator_apply]
  apply Finset.sum_congr rfl
  intro p _
  split_ifs <;> simp_all

@[simp] theorem sumRep_univ (n : ℕ) : sumRep Set.univ n = n + 1 := by
  simp [sumRep]

theorem matching_set_univ : {n : ℕ | sumRep Set.univ n = n + 1} = Set.univ := by
  ext n
  simp

theorem partialDensity_univ_eventually :
    partialDensity Set.univ =ᶠ[atTop] fun _ => (1 : ℝ) := by
  filter_upwards [eventually_gt_atTop (0 : ℕ)] with N hN
  simp [partialDensity, ne_of_gt hN]

@[simp] theorem lowerDensity_univ : lowerDensity Set.univ = 1 := by
  rw [lowerDensity, Filter.liminf_congr partialDensity_univ_eventually]
  exact Filter.liminf_const _

@[simp] theorem upperDensity_univ : upperDensity Set.univ = 1 := by
  rw [upperDensity, Filter.limsup_congr partialDensity_univ_eventually]
  exact Filter.limsup_const _

/-- A single admissible example simultaneously has lower and upper density one. -/
theorem density_one_counterexample :
    ∃ (A : Set ℕ) (g : ℕ → ℕ), Monotone g ∧ (∀ n, 0 < g n) ∧
      lowerDensity {n | sumRep A n = g n} = 1 ∧
      upperDensity {n | sumRep A n = g n} = 1 := by
  refine ⟨Set.univ, fun n => n + 1, ?_, ?_, ?_, ?_⟩
  · intro a b hab
    exact Nat.add_le_add_right hab 1
  · intro n
    exact Nat.succ_pos n
  · rw [matching_set_univ, lowerDensity_univ]
  · rw [matching_set_univ, upperDensity_univ]

/-- Negative answer to part i, including its universal quantifiers. -/
theorem not_lower_density_zero :
    ¬ ∀ (A : Set ℕ) (g : ℕ → ℕ), Monotone g → (∀ n, 0 < g n) →
      lowerDensity {n | sumRep A n = g n} = 0 := by
  obtain ⟨A, g, hmono, hpos, hlo, _⟩ := density_one_counterexample
  intro h
  have hz := h A g hmono hpos
  rw [hlo] at hz
  norm_num at hz

/-- Negative answer to part ii: no universal real upper bound strictly below one. -/
theorem not_uniform_upper_density_bound :
    ¬ ∃ c < (1 : ℝ), ∀ (A : Set ℕ) (g : ℕ → ℕ), Monotone g →
      (∀ n, 0 < g n) → upperDensity {n | sumRep A n = g n} < c := by
  obtain ⟨A, g, hmono, hpos, _, hup⟩ := density_one_counterexample
  rintro ⟨c, hc, h⟩
  have hlt := h A g hmono hpos
  rw [hup] at hlt
  exact (lt_asymm hc hlt)

#print axioms sumRep_eq_indicator_convolution
#print axioms density_one_counterexample
#print axioms not_lower_density_zero
#print axioms not_uniform_upper_density_bound

end LeanSyc.JSP000998
