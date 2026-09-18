# jsp-000818-lean — JSP-000818 Lean formalization observation

Lean 4 formalization of a scoped observation related to
[JSP-000818](https://github.com/TheJustinSunPrize/awards) of
TheJustinSunPrize/awards:

> **Does every prime modulus have a relatively small prime primitive root?**
> (Number theory; current status: Open; Lean proof: No.)

For an odd prime `p`, the multiplicative group `(ZMod p)ˣ` is cyclic of order
`p - 1`; a generator (an element of multiplicative order exactly `p - 1`) is a
*primitive root* modulo `p`. A classical theorem of Gauss guarantees a
primitive root exists for every prime modulus, and the least *prime* primitive
root always exists for odd `p`. The open question asks whether such a prime
primitive root is always *relatively small* (e.g. bounded by a fixed power of
`log p`).

## What is formalized (and what is not)

This repository contains **only a finite, fully machine-checked instance
table** for the odd primes `p ≤ 19`, recording each modulus's *least prime
primitive root*:

| `p` | least prime primitive root | order check |
| --- | --- | --- |
| 3  | 2 | `2² = 4 ≡ 1 (mod 3)`, `2 ≢ 1` |
| 5  | 2 | `2⁴ = 16 ≡ 1 (mod 5)`, no smaller positive power is `1` |
| 7  | 3 | order of `3` mod `7` is `6`; the only smaller prime `2` has order `3 ≠ 6` (`2³ = 8 ≡ 1`) |
| 11 | 2 | `2, 4, 8, 5, 10, 9, 7, 3, 6, 1` walks all `10` nonzero residues |
| 13 | 2 | order of `2` mod `13` is `12` |
| 17 | 3 | order of `3` mod `17` is `16`; the only smaller prime `2` has order `8 ≠ 16` (`2⁸ = 256 ≡ 1`) |
| 19 | 2 | order of `2` mod `19` is `18` (`2⁹ ≡ -1`) |

For each pair `(p, g)` above, the corresponding theorem
`jsp000818_p3, …, jsp000818_p19` verifies the three components:

1. `p` is prime (`Nat.Prime p`);
2. `g` is a primitive root mod `p`, phrased directly as the multiplicative
   order condition (`PrimRootCond p g`): `g ^ (p - 1) = 1` in `ZMod p` and no
   smaller positive power of `g` equals `1`;
3. `g` is the **least** such prime: every prime `q < g` fails
   `PrimRootCond p q` (vacuous for `g = 2`; checks `q = 2` for `g = 3`).

The companion theorems `jsp000818_pX_primitive_root` repackage each instance
in Mathlib's `IsPrimitiveRoot` semantics
(`IsPrimitiveRoot (g : ZMod p) (p - 1)`), and `jsp000818_table` combines the
seven instances into a single conjunction.

**This does not solve JSP-000818.** The table covers only the finite list of
odd primes `≤ 19` (with `p = 2` degenerate: the only unit of `ZMod 2` is `1`,
not a prime, so it has no prime primitive root at all). No assertion is made
for arbitrary prime moduli, and the smallness question (e.g. an
`O((log p)^c)` bound) remains untouched. The original problem stays open, and
no award is claimed.

## Contents

* `JSP000818.lean` — the complete self-contained statements and proofs.
* All numeric facts are discharged by `decide`; the `IsPrimitiveRoot`
  repackaging theorems are structural term-mode proofs using
  `IsPrimitiveRoot.iff`. There is no `sorry`, `admit`, `native_decide`, or
  unproven assumption anywhere.

## Toolchain

* Lean: `leanprover/lean4:v4.35.0-rc2` (see `lean-toolchain`)
* Mathlib: `v4.35.0-rc2` (see `lakefile.toml` / `lake-manifest.json`)

## Build and verify

```bash
lake build                       # full build
lake env lean JSP000818.lean     # expected: only the axiom-audit info lines
```

## Axiom audit

`#print axioms` at the end of `JSP000818.lean` reports for each of the fifteen
theorems (seven instances, the combined table, and seven `IsPrimitiveRoot`
repackagings):

```text
'<theorem>' depends on axioms: [propext, Classical.choice, Quot.sound]
```

This is exactly the set of Lean's standard axioms permitted for award-related
formalizations; there is no `sorry`, `admit`, `native_decide`, or unproven
assumption anywhere in the file.

## Attribution

* Formalization author: **Yaohua-Leo** (AI-assisted via ZCode (GLM)).
* The underlying mathematical facts (the least prime primitive roots of the
  primes `≤ 19`) are classical, elementary computations belonging to the
  public number-theory literature/community (Gauss's primitive root theorem
  and standard tables of primitive roots); no mathematical novelty is claimed
  here.
* No claim is made on any award from TheJustinSunPrize/awards.

## License

MIT (see `LICENSE`).
