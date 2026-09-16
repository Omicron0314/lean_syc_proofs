# JSP-000307: statement correspondence and attribution

## Problem and scope

Official catalog: [`TheJustinSunPrize/awards`](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0301-0400.md#JSP-000307).
Question: **Can three consecutive integers have strictly decreasing largest
prime factors?** Status at submission time: `Solved`, `Lean proof: No`,
`Eligible to claim: No`, `Claim status: Unavailable` — i.e. the mathematical
answer is known, no Lean formalization was recorded, and the problem was not
yet claimable. This file documents the faithful correspondence of the
formalization in [JSP000307.lean](LeanSyc/JSP000307.lean).

Original references: P. Erdős and C. Pomerance, *On the largest prime factors
of n and n+1*, Aequationes Math. (1978), 311–321; J. Balzarotti, *On triplets
with descending largest prime factors*, Studia Sci. Math. Hungar. (2001),
45–50.

## Statement and definitions

The original question is a yes/no existence question over the natural numbers.
It quantifies over the starting integer and asks whether the largest prime
factors of three consecutive integers can strictly decrease.

| Mathematical object | Lean expression and correspondence |
| --- | --- |
| Largest prime factor | `largestPrimeFactor n := n.primeFactorsList.foldr max 0`, the maximum of Mathlib's sorted prime-factor list `Nat.primeFactorsList` (0 for the empty-list cases `n = 0, 1`). |
| The question | `threeConsecutiveWithDecreasingP : ∃ n, largestPrimeFactor n > largestPrimeFactor (n+1) ∧ largestPrimeFactor (n+1) > largestPrimeFactor (n+2)` — a faithful, quantifier-preserving formalization of "Can three consecutive integers have strictly decreasing largest prime factors?". |

No hypotheses are added and none are dropped: the three consecutive integers are
`n, n+1, n+2` for an existentially quantified `n : ℕ`, and strict decrease is
the conjunction of the two strict inequalities. The degenerate values
`largestPrimeFactor 0 = 0` and `largestPrimeFactor 1 = 0` are consistent with
the definition and irrelevant for the witness `n = 13`.

## Proof

The witness is `n = 13`:

- `13 = 13` (prime), `14 = 2 · 7`, `15 = 3 · 5`, so
  `largestPrimeFactor 13 = 13`, `largestPrimeFactor 14 = 7`,
  `largestPrimeFactor 15 = 5`, and `13 > 7 > 5`.
- The factor lists are computed directly from `Nat.primeFactorsList`
  (`13.primeFactorsList = [13]`, `14.primeFactorsList = [2, 7]`,
  `15.primeFactorsList = [3, 5]`), each lemma closed by `norm_num` from the
  definition, with no `native_decide`, no custom axiom, and no `sorry`.

The same argument also works for `n = 34`: `34 = 2 · 17`, `35 = 5 · 7`,
`36 = 2² · 3²`, giving `17 > 7 > 3`.

## Axiom audit

`#print axioms largestPrimeFactor_13` etc. and
`#print axioms threeConsecutiveWithDecreasingP` report exactly
`[propext, Classical.choice, Quot.sound]`.

## Prior work and contribution

- The affirmative answer with consecutive witnesses was known to Erdős and
  Pomerance (1978); the problem record is solved. **No mathematical discovery
  or first-solution priority is claimed.**
- A search of the pinned Mathlib source found no formalization of this Erdős
  problem; `Nat.primeFactorsList` and the standard `max`/`foldr` lemmas are
  reused. This is not a claim that no equivalent proof exists elsewhere.
- At submission time, the official catalog recorded **no Lean proof** for
  JSP-000307; this file is the first Lean formalization submitted for it.
- OpenAI Codex assisted proof construction, local checking, and submission.
  This is a self-submission; local checks are not independent review.

## Reproduction

```sh
git clone https://github.com/Omicron0314/lean_syc_proofs.git
cd lean_syc_proofs
git checkout <pinned commit>
lake exe cache get
bash scripts/verify.sh   # builds, warning-as-error, source scan, leanchecker replay
sha256sum -c evidence/SHA256SUMS
```

Lean is pinned to 4.34.0 and Mathlib to v4.34.0 (lake-manifest.json,
lean-toolchain). The pinned immutable commit and the verification transcript
are referenced from the submission README.
