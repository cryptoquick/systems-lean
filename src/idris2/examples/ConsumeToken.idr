||| Algorithm id: ConsumeToken
||| Side: Idris 2 (native Quantitative Type Theory grades)
||| Pair: Lean dual sketch at src/lean4/examples/ConsumeToken.lean
|||
||| Grades shown (minimum 0 / 1 / unrestricted == omega-class):
|||   MULT-0     -- erased binder (no runtime presence)
|||   MULT-1     -- linear; LinearCheck requires exact once use
|||   MULT-OMEGA -- unrestricted (default quantity; free copy/drop)
|||
||| Trusted computing base honesty (not freestanding product):
|||   Typechecking or running this under stock Idris 2 (Chez, Racket,
|||   Gambit, RefC, etc.) still leaves a managed backend runtime in the
|||   trust base. RefC is C plus reference-counting support -- not
|||   runtimeless freestanding Systems Lean product C (out/freestanding-c).
|||   This file is a correspondence seed, not Slake emit.
|||
||| Prefer: idris2 --check examples/ConsumeToken.idr  (when idris2 is on PATH)
module Examples.ConsumeToken

%default total

------------------------------------------------------------------------
-- MULT-OMEGA -- unrestricted ordinary data
------------------------------------------------------------------------

||| Unrestricted Nat: may be used more than once (omega-class).
public export
shareNat : Nat -> Nat
shareNat n = n + n

------------------------------------------------------------------------
-- MULT-1 -- once-use resource (algorithm ConsumeToken)
------------------------------------------------------------------------

||| Abstract once-use resource. Payload is unrestricted Nat under the
||| constructor; the *Token wrapper* is what we treat as linear at use sites.
public export
data Token : Type where
  MkToken : Nat -> Token

||| Mint a token from unrestricted data (MULT-OMEGA in, Token out).
public export
mkToken : Nat -> Token
mkToken n = MkToken n

||| Consume the token exactly once (MULT-1). Returns the payload.
public export
consume : (1 t : Token) -> Nat
consume (MkToken n) = n

||| Unrestricted in, linear middle, unrestricted out.
public export
roundTrip : Nat -> Nat
roundTrip n = consume (mkToken n)

||| Linear pair swap: both components multiplicity 1 end-to-end.
public export
swapLin : (1 p : LPair Token Token) -> LPair Token Token
swapLin (a # b) = b # a

------------------------------------------------------------------------
-- MULT-0 -- erased (compile-time only)
------------------------------------------------------------------------

||| Erased type parameter: present for typing, gone at runtime.
public export
polyId : {0 a : Type} -> a -> a
polyId x = x

||| Erased Nat hint plus linear token: hint cannot be inspected at runtime;
||| token still used exactly once.
public export
consumeWithHint : (0 hint : Nat) -> (1 t : Token) -> Nat
consumeWithHint _ t = consume t

------------------------------------------------------------------------
-- Intentional non-examples (do not uncomment -- LinearCheck must fail)
------------------------------------------------------------------------

-- doubleSpend : (1 t : Token) -> (Nat, Nat)
-- doubleSpend t = (consume t, consume t)
--
-- dropToken : (1 t : Token) -> Nat
-- dropToken t = Z
