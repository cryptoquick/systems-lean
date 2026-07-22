/-
  SYSTEMS_LEAN_HOST partial -- Linear / ConsumeToken-class host contracts.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Dual cite (read-only; do not reimplement duals here):
    src/idris2/examples/ConsumeToken.idr
    src/lean4/examples/ConsumeToken.lean
  Emit map (read-only honesty): Linear.slake, CONSUME_TOKEN_HOST_V0 C host.

  Spec (readable, separate from any future proof):
  - Token is an abstract once-use resource (MULT-1 intent; LINEAR-EXACT-ONCE).
  - mkToken mints a token from unrestricted data (MULT-OMEGA in, Token out).
  - consume uses the token once and returns the payload (Nat).
  - roundTrip composes mint then consume (unrestricted in/out).
  - JOIN-ALG ConsumeToken is the dual algorithm on Idris side / Lean side.
  - Classic Lean cannot enforce multiplicity 1; names and module docs are the
    contract until freestanding checks and product wire enforce exact-once.

  Intentional non-examples (do not add as theorems claiming LinearCheck):
  - double application of consume to the same resource
  - dropping a linear Token without use
  Idris LinearCheck rejects those; classic Lean will not.

  Classic Lean elaborator note:
  - Token, mkToken, and consume are `axiom`s (not `opaque`) because opaque
    constants over an abstract Token require a Nonempty instance that would
    force a fake model. Axioms keep those contracts abstract.
  - roundTrip is a noncomputable `def` composition of consume (mkToken n);
    still no MULT-1 enforcement.
  - Not freestanding residual free. Not product C. Not PROVABLY.
  - Not freestanding emit residual free.

  Greppable: SYSTEMS_LEAN_HOST, JOIN-ALG, ConsumeToken, MULT-1, LINEAR-EXACT-ONCE
  UNIT_SURFACE host surface. Module: SystemsLean.Linear
  linear resource contract; exact-once fail closed by contract only here.
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

namespace SystemsLean.Linear

/-- Unrestricted ordinary data (MULT-OMEGA class). May be used more than once. -/
def shareNat (n : Nat) : Nat := n + n

/-- Abstract once-use resource. Freestanding map: MULT-1 / LINEAR-EXACT-ONCE.
    Classic Lean does not enforce exact-once use. -/
axiom Token : Type

/-- Mint a token from unrestricted data (MULT-OMEGA in, Token out).
    JOIN-ALG ConsumeToken mkToken shape. -/
axiom mkToken : Nat -> Token

/--
  consume t -- use the token once (contract); return payload.
  Classic Lean does not reject double application of consume to the same
  proof-relevant value the way Idris LinearCheck would; freestanding product
  wire and later host checks will.
  JOIN-ALG ConsumeToken consume shape.
-/
axiom consume : Token -> Nat

/--
  Unrestricted in, linear middle (by contract), unrestricted out.
  Elaborator-checked composition of the axiom contracts; not a linearity proof.
  noncomputable: mkToken/consume are axioms (no code generator support).
-/
noncomputable def roundTrip (n : Nat) : Nat := consume (mkToken n)

/-- Erased-parameter sketch (MULT-0 class): type parameter present for typing.
    Not identical to Idris `{0 a : Type}` (see ERASE-PROP / EDGE-PROP). -/
def polyId {a : Type} (x : a) : a := x

end SystemsLean.Linear
