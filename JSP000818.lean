/- leanprover/lean4:v4.35.0-rc2  mathlib v4.35.0-rc2 -/
/-
# JSP-000818 — Lean formalization observation (least prime primitive roots)

**Problem (TheJustinSunPrize/awards, JSP-000818).** *Does every prime modulus have
a relatively small prime primitive root?* (Mathematical area: number theory;
status: open.)

**Scope of this file (honest, scoped observation).** The original question is
open: it asks whether *every* prime modulus has a prime primitive root that is
relatively small in general (e.g. bounded by some fixed power of `log p`).
This file only formalizes a finite, fully machine-checked instance table for
the odd primes `p ≤ 19`, recording for each such `p` its *least prime primitive
root* modulo `p`:

| `p`          | 3 | 5 | 7 | 11 | 13 | 17 | 19 |
|--------------|---|---|---|----|----|----|----|
| least prime primitive root | 2 | 2 | 3 | 2  | 2  | 3  | 2  |

For each of the seven pairs `(p, g)` below, the formal statement verifies the
three components:

* `p` is prime;
* `g` is a primitive root modulo `p`, phrased directly as the multiplicative
  order condition `g ^ (p - 1) = 1` in `ZMod p` with no smaller positive power
  equal to `1` (`PrimRootCond` below; the companion theorems
  `jsp000818_pX_primitive_root` also repackage each instance in Mathlib's
  `IsPrimitiveRoot` semantics);
* `g` is the *least* such prime: every prime `q < g` fails `PrimRootCond p q`
  (vacuous for `g = 2`, the smallest prime; for `g = 3` this checks `q = 2`,
  whose orders modulo 7 and 17 are 3 and 8, not 6 and 16).

This does **not** answer the original open question and is not a claim on any
award. Note that `p = 2` is degenerate: the unit group of `ZMod 2` is trivial
(its only unit is `1`, which is not prime), so it has no prime primitive root
at all; the seven odd primes above are all remaining primes `≤ 19`.

## Provenance / toolchain

* Lean `v4.35.0-rc2`, Mathlib `v4.35.0-rc2` (pinned in `lean-toolchain`).
* All numeric content is discharged by `decide`; the `IsPrimitiveRoot`
  repackaging theorems are structural term-mode proofs. No `sorry`, `admit`,
  `native_decide`, or unproven assumptions are used.
-/
import Mathlib

/-!
# JSP-000818 — Lean formalization observation (least prime primitive roots)

**Problem (TheJustinSunPrize/awards, JSP-000818).** *Does every prime modulus have
a relatively small prime primitive root?* (Mathematical area: number theory;
status: open.)

**Scope of this file (honest, scoped observation).** The original question is
open: it asks whether *every* prime modulus has a prime primitive root that is
relatively small in general (e.g. bounded by some fixed power of `log p`).
This file only formalizes a finite, fully machine-checked instance table for
the odd primes `p ≤ 19`, recording for each such `p` its *least prime primitive
root* modulo `p`:

| `p`          | 3 | 5 | 7 | 11 | 13 | 17 | 19 |
|--------------|---|---|---|----|----|----|----|
| least prime primitive root | 2 | 2 | 3 | 2  | 2  | 3  | 2  |

For each of the seven pairs `(p, g)` below, the formal statement verifies the
three components:

* `p` is prime;
* `g` is a primitive root modulo `p`, phrased directly as the multiplicative
  order condition `g ^ (p - 1) = 1` in `ZMod p` with no smaller positive power
  equal to `1` (`PrimRootCond` below; the companion theorems
  `jsp000818_pX_primitive_root` also repackage each instance in Mathlib's
  `IsPrimitiveRoot` semantics);
* `g` is the *least* such prime: every prime `q < g` fails `PrimRootCond p q`
  (vacuous for `g = 2`, the smallest prime; for `g = 3` this checks `q = 2`,
  whose orders modulo 7 and 17 are 3 and 8, not 6 and 16).

This does **not** answer the original open question and is not a claim on any
award. Note that `p = 2` is degenerate: the unit group of `ZMod 2` is trivial
(its only unit is `1`, which is not prime), so it has no prime primitive root
at all; the seven odd primes above are all remaining primes `≤ 19`.

## Provenance / toolchain

* Lean `v4.35.0-rc2`, Mathlib `v4.35.0-rc2` (pinned in `lean-toolchain`).
* All numeric content is discharged by `decide`; the `IsPrimitiveRoot`
  repackaging theorems are structural term-mode proofs. No `sorry`, `admit`,
  `native_decide`, or unproven assumptions are used.
-/

/-- The classical primitive-root condition for `x` modulo a prime `p`, phrased
directly by powers: `x ^ (p - 1) = 1` in `ZMod p` and no smaller positive power
of `x` equals `1`, i.e. the multiplicative order of `x` in `ZMod p` is exactly
`p - 1`. For prime `p` and `x ≠ 0 mod p` this is precisely the statement that
`x` is a primitive root modulo `p`. -/
abbrev PrimRootCond (p x : ℕ) : Prop :=
  (x : ZMod p) ^ (p - 1) = 1 ∧ ∀ j : ℕ, j < p - 1 → 1 ≤ j → (x : ZMod p) ^ j ≠ 1

/-- **JSP-000818 instance `(p, g) = (3, 2)`.** `3` is prime, `2` is a primitive
root mod `3` (order `2`), and no prime is smaller than `2`, so `2` is the least
prime primitive root mod `3`. -/
theorem jsp000818_p3 :
    Nat.Prime 3 ∧ PrimRootCond 3 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 3 q) := by
  decide

/-- **JSP-000818 instance `(p, g) = (5, 2)`.** `5` is prime, `2` is a primitive
root mod `5` (order `4`), and no prime is smaller than `2`. -/
theorem jsp000818_p5 :
    Nat.Prime 5 ∧ PrimRootCond 5 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 5 q) := by
  decide

/-- **JSP-000818 instance `(p, g) = (7, 3)`.** `7` is prime, `3` is a primitive
root mod `7` (order `6`), and the only smaller prime `q = 2` is not: `2³ = 8 ≡ 1
(mod 7)`, so the order of `2` mod `7` is `3 ≠ 6`. -/
theorem jsp000818_p7 :
    Nat.Prime 7 ∧ PrimRootCond 7 3 ∧ (∀ q : ℕ, q < 3 → Nat.Prime q → ¬PrimRootCond 7 q) := by
  decide

/-- **JSP-000818 instance `(p, g) = (11, 2)`.** `11` is prime, the powers
`2, 4, 8, 5, 10, 9, 7, 3, 6, 1` of `2` mod `11` walk through all `10` nonzero
residues (order `10`), and no prime is smaller than `2`. -/
theorem jsp000818_p11 :
    Nat.Prime 11 ∧ PrimRootCond 11 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 11 q) := by
  decide

/-- **JSP-000818 instance `(p, g) = (13, 2)`.** `13` is prime, `2` is a primitive
root mod `13` (order `12`; e.g. `2⁶ = 64 ≡ 12 ≢ 1` and `2¹² = 4096 ≡ 1`), and no
prime is smaller than `2`. -/
theorem jsp000818_p13 :
    Nat.Prime 13 ∧ PrimRootCond 13 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 13 q) := by
  decide

/-- **JSP-000818 instance `(p, g) = (17, 3)`.** `17` is prime, `3` is a primitive
root mod `17` (order `16`), and the only smaller prime `q = 2` is not: `2⁸ = 256
= 15 · 17 + 1 ≡ 1 (mod 17)`, so the order of `2` mod `17` is `8 ≠ 16`. -/
theorem jsp000818_p17 :
    Nat.Prime 17 ∧ PrimRootCond 17 3 ∧ (∀ q : ℕ, q < 3 → Nat.Prime q → ¬PrimRootCond 17 q) := by
  decide

/-- **JSP-000818 instance `(p, g) = (19, 2)`.** `19` is prime, `2` is a primitive
root mod `19` (order `18`; e.g. `2⁹ = 512 = 26 · 19 + 18 ≡ -1 ≢ 1`), and no prime
is smaller than `2`. -/
theorem jsp000818_p19 :
    Nat.Prime 19 ∧ PrimRootCond 19 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 19 q) := by
  decide

/-- **JSP-000818 observation (combined finite table).** The seven instance
statements above, combined: for every odd prime `p ≤ 19` the pair
`(p, least prime primitive root mod p)` is `(3, 2)`, `(5, 2)`, `(7, 3)`,
`(11, 2)`, `(13, 2)`, `(17, 3)`, or `(19, 2)`, with each `g` verified prime,
a primitive root mod `p`, and the least such prime. This is a finite verified
table only; it does not address the general open question. -/
theorem jsp000818_table :
    (Nat.Prime 3 ∧ PrimRootCond 3 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 3 q)) ∧
    (Nat.Prime 5 ∧ PrimRootCond 5 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 5 q)) ∧
    (Nat.Prime 7 ∧ PrimRootCond 7 3 ∧ (∀ q : ℕ, q < 3 → Nat.Prime q → ¬PrimRootCond 7 q)) ∧
    (Nat.Prime 11 ∧ PrimRootCond 11 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 11 q)) ∧
    (Nat.Prime 13 ∧ PrimRootCond 13 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 13 q)) ∧
    (Nat.Prime 17 ∧ PrimRootCond 17 3 ∧ (∀ q : ℕ, q < 3 → Nat.Prime q → ¬PrimRootCond 17 q)) ∧
    (Nat.Prime 19 ∧ PrimRootCond 19 2 ∧ (∀ q : ℕ, q < 2 → Nat.Prime q → ¬PrimRootCond 19 q)) :=
  ⟨jsp000818_p3, jsp000818_p5, jsp000818_p7, jsp000818_p11, jsp000818_p13,
    jsp000818_p17, jsp000818_p19⟩

/-! ### Repackaging in Mathlib's `IsPrimitiveRoot` semantics -/

/-- Instance `(p, g) = (3, 2)` in Mathlib semantics: `2` is a primitive root of
unity of order `2` in `ZMod 3`. -/
theorem jsp000818_p3_primitive_root : IsPrimitiveRoot (2 : ZMod 3) 2 :=
  let h : PrimRootCond 3 2 := jsp000818_p3.2.1
  (IsPrimitiveRoot.iff (by norm_num : 0 < 2)).mpr
    ⟨h.1, fun l hl0 hl => h.2 l hl (Nat.succ_le_of_lt hl0)⟩

/-- Instance `(p, g) = (5, 2)` in Mathlib semantics. -/
theorem jsp000818_p5_primitive_root : IsPrimitiveRoot (2 : ZMod 5) 4 :=
  let h : PrimRootCond 5 2 := jsp000818_p5.2.1
  (IsPrimitiveRoot.iff (by norm_num : 0 < 4)).mpr
    ⟨h.1, fun l hl0 hl => h.2 l hl (Nat.succ_le_of_lt hl0)⟩

/-- Instance `(p, g) = (7, 3)` in Mathlib semantics. -/
theorem jsp000818_p7_primitive_root : IsPrimitiveRoot (3 : ZMod 7) 6 :=
  let h : PrimRootCond 7 3 := jsp000818_p7.2.1
  (IsPrimitiveRoot.iff (by norm_num : 0 < 6)).mpr
    ⟨h.1, fun l hl0 hl => h.2 l hl (Nat.succ_le_of_lt hl0)⟩

/-- Instance `(p, g) = (11, 2)` in Mathlib semantics. -/
theorem jsp000818_p11_primitive_root : IsPrimitiveRoot (2 : ZMod 11) 10 :=
  let h : PrimRootCond 11 2 := jsp000818_p11.2.1
  (IsPrimitiveRoot.iff (by norm_num : 0 < 10)).mpr
    ⟨h.1, fun l hl0 hl => h.2 l hl (Nat.succ_le_of_lt hl0)⟩

/-- Instance `(p, g) = (13, 2)` in Mathlib semantics. -/
theorem jsp000818_p13_primitive_root : IsPrimitiveRoot (2 : ZMod 13) 12 :=
  let h : PrimRootCond 13 2 := jsp000818_p13.2.1
  (IsPrimitiveRoot.iff (by norm_num : 0 < 12)).mpr
    ⟨h.1, fun l hl0 hl => h.2 l hl (Nat.succ_le_of_lt hl0)⟩

/-- Instance `(p, g) = (17, 3)` in Mathlib semantics. -/
theorem jsp000818_p17_primitive_root : IsPrimitiveRoot (3 : ZMod 17) 16 :=
  let h : PrimRootCond 17 3 := jsp000818_p17.2.1
  (IsPrimitiveRoot.iff (by norm_num : 0 < 16)).mpr
    ⟨h.1, fun l hl0 hl => h.2 l hl (Nat.succ_le_of_lt hl0)⟩

/-- Instance `(p, g) = (19, 2)` in Mathlib semantics. -/
theorem jsp000818_p19_primitive_root : IsPrimitiveRoot (2 : ZMod 19) 18 :=
  let h : PrimRootCond 19 2 := jsp000818_p19.2.1
  (IsPrimitiveRoot.iff (by norm_num : 0 < 18)).mpr
    ⟨h.1, fun l hl0 hl => h.2 l hl (Nat.succ_le_of_lt hl0)⟩

-- Axiom audit: every theorem below depends only on the standard permitted
-- axioms [propext, Classical.choice, Quot.sound] (no sorryAx or others).
#print axioms jsp000818_p3
#print axioms jsp000818_p5
#print axioms jsp000818_p7
#print axioms jsp000818_p11
#print axioms jsp000818_p13
#print axioms jsp000818_p17
#print axioms jsp000818_p19
#print axioms jsp000818_table
#print axioms jsp000818_p3_primitive_root
#print axioms jsp000818_p5_primitive_root
#print axioms jsp000818_p7_primitive_root
#print axioms jsp000818_p11_primitive_root
#print axioms jsp000818_p13_primitive_root
#print axioms jsp000818_p17_primitive_root
#print axioms jsp000818_p19_primitive_root
