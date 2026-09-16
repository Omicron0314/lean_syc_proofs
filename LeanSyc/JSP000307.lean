/-
Copyright (c) 2026 The Formal Conjectures Authors, Omicron0314. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Formal Conjectures Authors, Omicron0314
-/
import Mathlib.Data.Nat.Factors
import Mathlib.Tactic

/-!
# JSP-000307 / Erdős problem: consecutive integers, decreasing largest prime factors

Original reference: P. Erdős and C. Pomerance, On the largest prime factors of `n` and
`n+1`, Aequationes Math. (1978), 311–321. See also J. Balzarotti, On triplets with
descending largest prime factors, Studia Sci. Math. Hungar. (2001), 45–50.

Official JSP-000307 statement: "Can three consecutive integers have strictly
decreasing largest prime factors?"  The problem is marked **Solved** in the
official problem bank (`TheJustinSunPrize/awards`, `problems/catalog-0301-0400.md`,
as of 2026-09-16), with no recorded Lean formalization at the time of writing.

Formalization strategy: a single explicit witness answers the existence question
affirmatively.  For the consecutive integers `13, 14, 15` the largest prime
factors are `13`, `7`, and `5`, which are strictly decreasing:
`13 = 13`, `14 = 2 · 7`, `15 = 3 · 5`.  (The witness pair `34, 35, 36` also works:
`17 > 7 > 3`.)

Definition correspondence:

- "largest prime factor of `n`" is modeled by `largestPrimeFactor n`, the
  maximum of `n.primeFactorsList` (Mathlib's sorted list of prime factors).
- The question "Can three consecutive integers have strictly decreasing largest
  prime factors?" is the existence statement `threeConsecutiveWithDecreasingP`,
  which preserves every quantifier of the original question.
- Natural numbers include zero; `largestPrimeFactor 0 = 0` and
  `largestPrimeFactor 1 = 0` are the degenerate cases, which do not matter for
  the witness `13 ≤ n`.

This file claims a complete affirmative answer with a constructive witness and
claims no mathematical discovery (the counterexample was known to Erdős and
Pomerance); it provides a machine-checkable Lean proof and a faithful,
quantifier-preserving formalization of the original question.
-/

namespace LeanSyc.JSP000307

/-- The largest prime factor of `n`, defined as the maximum of Mathlib's sorted
list of prime factors (`0` for `n = 0, 1`, where the list is empty). -/
def largestPrimeFactor (n : ℕ) : ℕ := n.primeFactorsList.foldr max 0

/-- The factorization `13 = 13`. -/
lemma primeFactorsList_13 : (13 : ℕ).primeFactorsList = [13] := by
  exact Nat.primeFactorsList_prime (by norm_num)

/-- The factorization `14 = 2 · 7`. -/
lemma primeFactorsList_14 : (14 : ℕ).primeFactorsList = [2, 7] := by
  norm_num [Nat.primeFactorsList]

/-- The factorization `15 = 3 · 5`. -/
lemma primeFactorsList_15 : (15 : ℕ).primeFactorsList = [3, 5] := by
  norm_num [Nat.primeFactorsList]

/-- The largest prime factor of `13` is `13`. -/
lemma largestPrimeFactor_13 : largestPrimeFactor 13 = 13 := by
  norm_num [largestPrimeFactor, Nat.primeFactorsList]

/-- The largest prime factor of `14` is `7`. -/
lemma largestPrimeFactor_14 : largestPrimeFactor 14 = 7 := by
  norm_num [largestPrimeFactor, Nat.primeFactorsList]

/-- The largest prime factor of `15` is `5`. -/
lemma largestPrimeFactor_15 : largestPrimeFactor 15 = 5 := by
  norm_num [largestPrimeFactor, Nat.primeFactorsList]

/-- For `13, 14, 15` the largest prime factors strictly decrease:
`13 > 7 > 5`. -/
theorem decreasing_largestPrimeFactor_13_14_15 :
    largestPrimeFactor 13 > largestPrimeFactor 14 ∧
    largestPrimeFactor 14 > largestPrimeFactor 15 := by
  rw [largestPrimeFactor_13, largestPrimeFactor_14, largestPrimeFactor_15]
  norm_num

/-- **The formal answer to JSP-000307.** There exist three consecutive integers
whose largest prime factors are strictly decreasing; the witness is
`n = 13`, with `largestPrimeFactor 13 = 13 > 7 = largestPrimeFactor 14`
and `largestPrimeFactor 14 = 7 > 5 = largestPrimeFactor 15`. -/
theorem threeConsecutiveWithDecreasingP :
    ∃ n : ℕ,
      largestPrimeFactor n > largestPrimeFactor (n + 1) ∧
      largestPrimeFactor (n + 1) > largestPrimeFactor (n + 2) := by
  refine ⟨13, ?_⟩
  exact decreasing_largestPrimeFactor_13_14_15

#print axioms largestPrimeFactor_13
#print axioms largestPrimeFactor_14
#print axioms largestPrimeFactor_15
#print axioms threeConsecutiveWithDecreasingP

end LeanSyc.JSP000307
