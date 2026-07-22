/-
  Algorithm id: UnrestrictedShare
  Side: Lean 4 (classic) dual -- behavioral sketch + contracts
  Pair: Idris native MULT-OMEGA UnrestrictedShare at
        src/idris2/examples/UnrestrictedShare.idr
  Trust: examples/TRUST.md -- classic ahead-of-time still has managed runtime residual.
  Not freestanding. Not product C emit. Not PROVABLY.

  Spec (readable, separate from any future proof):
  - Focus MULT-OMEGA: ordinary data may be copied, dropped, and multi-used.
  - shareNat / fanOut / dropLeft show unrestricted scalar use.
  - Point record fields may be read many times (duplicatePoint, pointSum).
  - shareHead / mapAdd1 show unrestricted list data.
  - Contrast: MULT-1 Token in ConsumeToken is once-use by contract; classic Lean
    does not enforce that either -- Systems Lean freestanding host will.

  Red/green: ./src/lean4/check.sh presence gate; Lake when toolchain installed.
  Module must stay ASCII. Follow AGENTS.md language rules (no banned metaphor names).
-/

namespace SystemsLean.LeanBridge.UnrestrictedShare

/-- Unrestricted Nat used more than once (MULT-OMEGA class). -/
def shareNat (n : Nat) : Nat := n + n

/-- Fan-out: one input, three uses. Nested Prod keeps ASCII (no Unicode product). -/
def fanOut (n : Nat) : Prod Nat (Prod Nat Nat) := (n, (n + 1, n + n))

/-- Drop first argument; unrestricted allows discard. -/
def dropLeft (_x : Nat) (y : Nat) : Nat := y

/-- Ordinary product data (unrestricted fields). -/
structure Point where
  x : Nat
  y : Nat

/-- Two derived points from one (field multi-read). -/
def duplicatePoint (p : Point) : Prod Point Point :=
  ({ x := p.x, y := p.y }, { x := p.x + 1, y := p.y + 1 })

/-- Multiple field reads (MULT-OMEGA). -/
def pointSum (p : Point) : Nat := p.x + p.y + p.x

/-- Unrestricted list head shared into a sum. -/
def shareHead : List Nat -> Nat
  | [] => 0
  | h :: _ => h + h

/-- Map over unrestricted list cells. -/
def mapAdd1 : List Nat -> List Nat
  | [] => []
  | h :: t => (h + 1) :: mapAdd1 t

def demoFan : Nat :=
  match fanOut 3 with
  | (a, (b, c)) => a + b + c

def demoPoint : Nat :=
  match duplicatePoint { x := 2, y := 5 } with
  | (p, q) => pointSum p + pointSum q

end SystemsLean.LeanBridge.UnrestrictedShare
