# JSP-000998: statement correspondence and attribution

## Problem and scope

The [official catalog](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/problems/catalog-0901-1000.md#JSP-000998)
identifies this problem as Erdős #1193. Its index was Solved / Yes / Yes / Unclaimed
when checked on 2026-09-16. The catalog lists no historical bounty for this entry.
These screening flags are not an award decision.

Original reference: P. Erdős, *A survey of problems in combinatorial number theory*,
Ann. Discrete Math. (1980), 89–115. The exact mathematical wording used here is
documented in the [pinned Formal Conjectures statement](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjectures/ErdosProblems/1193.lean).
The original printed article was not independently inspected for this submission.

Given `A ⊆ ℕ` and a nondecreasing, everywhere positive `g : ℕ → ℕ`, let
`M = {n | (1_A * 1_A)(n) = g(n)}`. Part i asks whether the lower density of `M`
is always zero. Part ii asks whether there is a universal real `c < 1` such that
the upper density of `M` is always strictly less than `c`.

The reference explicitly records the elementary negative answer to both questions
and notes that additional restrictions may have been intended but were not recorded.
We address only the stated unrestricted problem; we do not infer missing hypotheses.

## Definitions and quantifiers

All declarations below are in `LeanSyc.JSP000998` in
[JSP000998.lean](LeanSyc/JSP000998.lean).

| Mathematical object | Lean expression and correspondence |
| --- | --- |
| Natural numbers | `ℕ`, including zero. |
| Ordered representation count | `sumRep A n` counts `Finset.antidiagonal n` filtered by membership of both coordinates in `A`; diagonal pairs are allowed. |
| Indicator convolution | `sumRep_eq_indicator_convolution` proves equality to the finite sum of the products of both indicators. |
| Partial density | `partialDensity S N = (S ∩ Set.Iio N).ncard / (N : ℝ)`. |
| Lower and upper densities | Real `Filter.atTop.liminf` and `limsup` of those partial densities. |
| Admissible function | `Monotone g` and `∀ n, 0 < g n`, separately verified for `n + 1`. |
| Both answers | `not_lower_density_zero` and `not_uniform_upper_density_bound`, with all set, function, and bound quantifiers retained. |

The reference's [convolution definitions](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjecturesForMathlib/Combinatorics/Additive/Convolution.lean)
give the same filtered-antidiagonal count in `sumRep_def`.
Its [density definitions](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjecturesForMathlib/Data/Set/Density.lean)
use `((S ∩ A) ∩ Iio N).ncard / (A ∩ Iio N).ncard` with ambient set `A = univ`.
Removing intersections with `univ` and using Mathlib's `Set.ncard_Iio_nat`
gives exactly our definition. At `N = 0` real division gives zero; densities
are unchanged because all positive `N` give one for the full set.

Our theorem statements negate exactly the propositions on the right of the
reference's `answer(False) ↔ ...`; no problem-specific hypothesis is assumed.
This correspondence is a submission-author explanation, not an official or
independent statement-equivalence attestation.

## Proof

For `A = univ`, the antidiagonal has `n + 1` members, so `sumRep A n = n + 1`.
The function `g(n) = n + 1` is monotone and positive. The matching set is `univ`,
whose partial density is one for every positive cutoff. Its liminf and limsup
are therefore one. This contradicts both proposed conclusions.

## Prior work and contribution

- The counterexample is already recorded in the Formal Conjectures statement above.
- Pietro Monticone and Aristotle (Harmonic) produced an earlier formalization;
  the [original source](https://gist.github.com/pitmonticone/c2658d464f8f5ca0e7fa40ed6fb78a5d/793317d6a959dca24f5f313364c49c4c75fc5c01)
  and the [catalog's pinned copy](https://github.com/plby/lean-proofs/blob/1268917deaaaa0d674f651287027baa26cea9920/src/latest/ErdosProblems/Erdos1193.lean)
  are acknowledged. That copy proves the representation identity using a filtered
  range; its comments describe the density consequences.
- The present implementation uses the antidiagonal and indicator-convolution
  definitions, explicitly formalizes both density-one results and both full
  quantified negations, and pins a reproducible Lean/Mathlib 4.34.0 build.
- A search of the pinned Mathlib source found no existing theorem for Erdős #1193.
  Standard antidiagonal and filter lemmas are reused. This is not a claim that no
  equivalent proof exists elsewhere.
- OpenAI Codex assisted proof construction, local checking, and submission.
  This is a self-submission; local checks are not independent review.

The adapted statement and definitions originate in the Formal Conjectures project
(copyright 2025/2026 The Formal Conjectures Authors, Apache 2.0).
The cited prior proof is also Apache 2.0. Its Lean proof body is not copied here.
The new development is released under Apache 2.0.

## Review still required

Please assess statement fidelity, whether these additions constitute an eligible
formalization contribution despite the prior proof, and any necessary independent
checking and permanent archival. No award amount, first-discovery priority,
confirmed recipient identity, or approval is asserted.
