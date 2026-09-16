# Lean proofs for Justin Sun Prize submissions

## JSP-000998 / Erdős #1193

[Lean source](LeanSyc/JSP000998.lean) proves both negative answers about the
lower and upper natural densities of additive representation matches.
For `A = ℕ` and `g(n) = n + 1`, every natural number matches; both densities are one.
Natural numbers include zero, and representations count ordered pairs.

This is a complete formalization of a known elementary counterexample, prepared
with OpenAI Codex assistance. It claims neither a new mathematical discovery nor
first formalization. The additional work explicitly connects the representation
count to indicator convolution and proves both quantified density conclusions.
See [statement correspondence and attribution](STATEMENT.md).

## Reproduce

- Lean: `leanprover/lean4:v4.34.0`.
- Mathlib: `v4.34.0`, commit `5ed2965256430c3649e86755f9576b54eca72435`.
- All transitive dependencies are pinned in `lake-manifest.json`.

With [elan](https://github.com/leanprover/elan) installed:

```sh
lake exe cache get
bash scripts/verify.sh
```

Set your network proxy environment variables first if your connection requires it.
The script builds with warnings treated as errors, prints theorem dependencies,
checks project Lean sources for prohibited declarations, and replays the new
declarations using the bundled `leanchecker`. The replay uses the same Lean kernel,
not an independently implemented checker. Mathlib's precompiled cache is used;
this is not a fresh, network-isolated rebuild of all dependencies.

Local results are in [the verification log](evidence/verification.txt).
Only the standard axioms `propext`, `Classical.choice`, and `Quot.sound` occur in
the audited theorem dependencies. Official review and award eligibility remain
pending. Passing these checks does not establish entitlement to a payment.

## License

Apache 2.0; see [LICENSE](LICENSE) and [attribution](STATEMENT.md).
