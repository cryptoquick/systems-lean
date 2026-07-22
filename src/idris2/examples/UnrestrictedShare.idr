||| Algorithm id: UnrestrictedShare
||| Side: Idris 2 (native Quantitative Type Theory grades)
||| Pair: Lean dual sketch at src/lean4/examples/UnrestrictedShare.lean
|||
||| Focus: MULT-OMEGA -- unrestricted ordinary data (copy, drop, multi-use).
||| Contrast with MULT-1 Token in ConsumeToken (LinearCheck exact-once).
|||
||| Grades (minimum 0 / 1 / unrestricted == omega-class):
|||   MULT-0     -- erased (see ErasedIndex)
|||   MULT-1     -- linear (see ConsumeToken)
|||   MULT-OMEGA -- unrestricted (this file)
|||
||| Trusted computing base honesty (not freestanding product):
|||   Stock Idris backends leave a managed runtime in the trust base.
|||   Unrestricted sharing here is not freestanding product C.
|||
||| Prefer: idris2 --check examples/UnrestrictedShare.idr  (when idris2 is on PATH)
module Examples.UnrestrictedShare

%default total

------------------------------------------------------------------------
-- MULT-OMEGA -- unrestricted scalars
------------------------------------------------------------------------

||| Use the same Nat more than once (omega-class / unrestricted).
public export
shareNat : Nat -> Nat
shareNat n = n + n

||| Fan-out: one unrestricted input, three uses in the result tuple.
public export
fanOut : Nat -> (Nat, Nat, Nat)
fanOut n = (n, n + 1, n + n)

||| Drop the first argument; unrestricted allows discard without LinearCheck.
public export
dropLeft : Nat -> Nat -> Nat
dropLeft _ y = y

------------------------------------------------------------------------
-- MULT-OMEGA -- unrestricted records and lists
------------------------------------------------------------------------

||| Ordinary product data: fields may be read many times.
public export
record Point where
  constructor MkPoint
  x : Nat
  y : Nat

||| Build two derived points from one (unrestricted copy of fields).
public export
duplicatePoint : Point -> (Point, Point)
duplicatePoint p =
  (MkPoint p.x p.y, MkPoint (p.x + 1) (p.y + 1))

||| Sum coordinates; multiple field reads are fine under MULT-OMEGA.
public export
pointSum : Point -> Nat
pointSum p = p.x + p.y + p.x

||| Unrestricted list: head may be shared into multiple results.
public export
shareHead : List Nat -> Nat
shareHead [] = Z
shareHead (h :: _) = h + h

||| Map that reuses the function result shape; list cells are unrestricted data.
public export
mapAdd1 : List Nat -> List Nat
mapAdd1 [] = []
mapAdd1 (h :: t) = (h + 1) :: mapAdd1 t

------------------------------------------------------------------------
-- Composed demos
------------------------------------------------------------------------

public export
demoFan : Nat
demoFan =
  case fanOut 3 of
    (a, b, c) => a + b + c

public export
demoPoint : Nat
demoPoint =
  case duplicatePoint (MkPoint 2 5) of
    (p, q) => pointSum p + pointSum q

------------------------------------------------------------------------
-- Intentional contrast (do not treat as MULT-1)
------------------------------------------------------------------------

-- Unrestricted Nat can be "dropped" or double-used freely.
-- A MULT-1 Token from ConsumeToken cannot:
--   dropToken : (1 t : Token) -> Nat
--   dropToken t = Z
-- would fail LinearCheck. That gap is EDGE-AFFINE / MULT-1 vs MULT-OMEGA.
