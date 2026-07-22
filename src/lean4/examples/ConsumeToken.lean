/-
  Algorithm id: ConsumeToken
  Side: Lean 4 (classic) dual -- behavioral sketch + contracts
  Pair: Idris native mult-1 ConsumeToken at src/idris2/examples/ConsumeToken.idr
  Trust: examples/TRUST.md -- classic ahead-of-time still has managed runtime residual.
  Not freestanding. Not product C emit. Not PROVABLY.

  Spec (readable, separate from any future proof):
  - shareNat shows unrestricted ordinary data (MULT-OMEGA class).
  - Token is an abstract once-use resource (MULT-1 intent).
  - mkToken mints a token from unrestricted data.
  - consume uses the token once and returns the payload (Nat).
  - roundTrip composes mint then consume (unrestricted in/out).
  - polyId sketches erased type parameter (MULT-0 class) without claiming Idris (0 a) identity.
  - In Systems Lean freestanding host, Token use maps to multiplicity 1 (MULT-1).
  - In classic Lean today, the type system does not enforce linearity; names and
    module docs are the contract until freestanding checks exist under src/systems/.

  Intentional non-examples (do not add as theorems claiming LinearCheck):
  - double application of consume to the same resource
  - dropping a linear Token without use
  Idris LinearCheck rejects those; classic Lean will not.

  Classic Lean elaborator note:
  - Token, mkToken, and consume are `axiom`s (not `opaque`) because opaque
    constants over an abstract Token require a Nonempty instance that would
    force a fake model. Axioms keep those contracts abstract.
  - roundTrip is a noncomputable `def` composition of consume (mkToken n) so the
    elaborator checks the stated wiring (axioms are not code-generated);
    still no MULT-1 enforcement.
  - MULT-1 is not enforced by classic Lean; axioms are honesty markers only.

  Red/green: `./src/lean4/check.sh` presence gate always; Lake elaborator when
  lean+lake and the pinned lean-toolchain are already installed (no network).
  Module must stay ASCII.
-/

namespace SystemsLean.LeanBridge.ConsumeToken

/-- Unrestricted ordinary data (MULT-OMEGA class). May be used more than once. -/
def shareNat (n : Nat) : Nat := n + n

/-- Abstract once-use resource. Freestanding map: MULT-1. Not enforced here. -/
axiom Token : Type

/-- Mint a token from unrestricted data (MULT-OMEGA in, Token out). -/
axiom mkToken : Nat -> Token

/--
  consume t -- use the token once (contract); return payload.
  Classic Lean does not reject double application of consume to the same
  proof-relevant value the way Idris LinearCheck would; Systems Lean will.
-/
axiom consume : Token -> Nat

/--
  Unrestricted in, linear middle (by contract), unrestricted out.
  Elaborator-checked composition of the axiom contracts; not a linearity proof.
  noncomputable: mkToken/consume are axioms (no code generator support).
-/
noncomputable def roundTrip (n : Nat) : Nat := consume (mkToken n)

/--
  Erased-parameter sketch (MULT-0 class): type parameter present for typing.
  Not identical to Idris `{0 a : Type}` (see ERASE-PROP / EDGE-PROP).
-/
def polyId {a : Type} (x : a) : a := x

end SystemsLean.LeanBridge.ConsumeToken
