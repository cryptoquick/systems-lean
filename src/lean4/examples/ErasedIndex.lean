/-
  Algorithm id: ErasedIndex
  Side: Lean 4 (classic) dual -- behavioral sketch + contracts
  Pair: Idris native MULT-0 ErasedIndex at src/idris2/examples/ErasedIndex.idr
  Trust: examples/TRUST.md -- classic ahead-of-time still has managed runtime residual.
  Not freestanding. Not product C emit. Not PROVABLY.

  Spec (readable, separate from any future proof):
  - Focus MULT-0: length / index parameters that shape types without a separate
    runtime length argument the caller must supply as live data.
  - vLength counts by walking a list (structure), not by reading a Mult-0 binder.
  - vHead takes a non-empty list contract (head option).
  - vZip pairs equal-length lists by structure walk.
  - payloadOnly ignores an erased-style bound argument (contract: bound unused).
  - erasedId sketches a type-parameter identity (MULT-0 class).
  - Classic Lean does not erase Nat the way Idris quantity 0 does (ERASE-PROP).
    Names and docs are the contract until Systems Lean mult 0 is the host.

  Red/green: ./src/lean4/check.sh presence gate; Lake when toolchain installed.
  Module must stay ASCII. Follow AGENTS.md language rules (no banned metaphor names).
-/

namespace SystemsLean.LeanBridge.ErasedIndex

/-- Structure-walk length (MULT-0 class: no separate runtime length arg required). -/
def vLength {a : Type} : List a -> Nat
  | [] => 0
  | _ :: xs => vLength xs + 1

/-- Head when non-empty; none otherwise (Idris non-empty Vect is stronger). -/
def vHead {a : Type} : List a -> Option a
  | [] => none
  | x :: _ => some x

/--
  Zip by structure. Idris pairs Vect n a with shared erased n;
  classic Lean uses lists and stops at the shorter side (honest gap).
-/
def vZip {a b : Type} : List a -> List b -> List (Prod a b)
  | [], _ => []
  | _, [] => []
  | x :: xs, y :: ys => (x, y) :: vZip xs ys

/-- Erased-style bound: first argument unused at runtime (contract). -/
def payloadOnly (_bound : Nat) (payload : Nat) : Nat := payload

/-- Type-parameter identity sketch (MULT-0 class). -/
def erasedId {a : Type} (x : a) : a := x

/-- Demo matching Idris demoZipSum shape (1+10+2+20). -/
def demoZipSum : Nat :=
  let xs := [1, 2]
  let ys := [10, 20]
  let zs := vZip xs ys
  match zs with
  | (a, b) :: (c, d) :: _ => a + b + c + d
  | _ => 0

/-- Demo length of a three-element list. -/
def demoLength3 : Nat := vLength [true, false, true]

end SystemsLean.LeanBridge.ErasedIndex
