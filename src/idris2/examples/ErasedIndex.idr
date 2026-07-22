||| Algorithm id: ErasedIndex
||| Side: Idris 2 (native Quantitative Type Theory grades)
||| Pair: Lean dual sketch at src/lean4/examples/ErasedIndex.lean
|||
||| Focus: MULT-0 -- erased length / index parameters that shape types
||| without becoming freestanding runtime arguments.
|||
||| Related grades (for contrast; see also ConsumeToken, UnrestrictedShare):
|||   MULT-0     -- erased binder (no runtime presence)
|||   MULT-1     -- linear; exact once (not the focus here)
|||   MULT-OMEGA -- unrestricted (default quantity)
|||
||| Trusted computing base honesty (not freestanding product):
|||   Typechecking under stock Idris 2 still leaves a managed backend runtime
|||   in the trust base. This file is a correspondence seed, not Slake emit.
|||
||| Prefer: idris2 --check examples/ErasedIndex.idr  (when idris2 is on PATH)
module Examples.ErasedIndex

import Data.Vect

%default total

------------------------------------------------------------------------
-- MULT-0 -- erased length on Vect (type-level; count from structure)
------------------------------------------------------------------------

||| Compute length by walking the vector. The length index `n` is multiplicity 0:
||| it is present for typing, not a separate runtime argument the caller loads.
public export
vLength : {0 n : Nat} -> Vect n a -> Nat
vLength [] = Z
vLength (_ :: xs) = S (vLength xs)

||| Head when the vector is non-empty at the type level. Length predecessor is
||| erased (`0 n`); only the cons cell is needed at runtime.
public export
vHead : {0 n : Nat} -> Vect (S n) a -> a
vHead (x :: _) = x

||| Zip two vectors that share an erased length index. Runtime only walks both
||| vectors' cons cells; length equality is a typing fact (MULT-0), not a compared Nat.
public export
vZip : {0 n : Nat} -> Vect n a -> Vect n b -> Vect n (a, b)
vZip [] [] = []
vZip (x :: xs) (y :: ys) = (x, y) :: vZip xs ys

------------------------------------------------------------------------
-- MULT-0 -- erased bound that must not be inspected at runtime
------------------------------------------------------------------------

||| Erased bound plus unrestricted payload. The bound cannot be returned or
||| matched at runtime; only the payload is used (same shape as consumeWithHint
||| in ConsumeToken, without a linear Token).
public export
payloadOnly : (0 bound : Nat) -> Nat -> Nat
payloadOnly _ payload = payload

||| Erased type parameter (MULT-0 class) -- identity at any type.
public export
erasedId : {0 a : Type} -> a -> a
erasedId x = x

------------------------------------------------------------------------
-- Small demos composed from the above
------------------------------------------------------------------------

||| Two-element demo: erased length 2 at the type level; runtime builds data.
public export
demoZipSum : Nat
demoZipSum =
  let xs : Vect 2 Nat
      xs = 1 :: 2 :: []
      ys : Vect 2 Nat
      ys = 10 :: 20 :: []
      zs = vZip xs ys
  in case zs of
       (a, b) :: (c, d) :: [] => a + b + c + d

||| vLength on a three-element vector (structure walk; not a runtime length arg).
public export
demoLength3 : Nat
demoLength3 = vLength (True :: False :: True :: [])
