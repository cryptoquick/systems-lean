/-
  SYSTEMS_LEAN_HOST partial -- emit apply tag buffer on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): extract.md EMIT_APPLY_V0 notes,
    emit slake_emit_apply / slake_emit_apply_from_compose / slake_emit_apply_is_valid
    (frozen wire honesty only; SLAKE_EMIT_APPLY_CAP = 32).

  Spec (readable, separate from any future proof):
  - Thin EMIT-APPLY host: fixed-capacity serialisation of live node mult/kind tags
    from a checked HostCompose (program order).
  - Tag packing honesty: mult high nibble (0/1/2), kind low nibble (0/1/2).
  - applyCap = 32 matching emit SLAKE_EMIT_APPLY_CAP (defensive headroom above
    programCap 8; honest mutators cannot hit overflow via public HostCompose APIs).
  - applyFromCompose is FAIL-CLOSED: requires HostCompose.checkFailClosed; count
    must not exceed applyCap; on fail valid=false and count=0 (tags empty).
  - Empty checked compose: count=0, valid=true.
  - applyIsValid: valid flag + count <= applyCap + count == tags.length
    (emit map: slake_emit_apply_is_valid; host strengthens inventory consistency).

  Open hygiene (name clash):
  - Prefer applyFromCompose and applyIsValid (primary). Greppable alias fromCompose
    is emit-map honesty only. Never open more than one SystemsLean.Emit* namespace
    at once; qualify when using several Emit* modules together.

  Theorems (EMIT-APPLY-THEOREM / HOST-EMIT-APPLY-THEOREM -- partial EmitApply only):
  - applyCap_eq_32 (SLAKE_EMIT_APPLY_CAP honesty)
  - applyOk_empty_true / applyFromCompose_empty_zero
  - applyOk_linear_without_mint_false / applyIsValid_failClosed_false
  - packTag_linear / packTag_erased / packTag_value / tagMult_kind unpack
  - applyOk_eq / fromCompose_eq_applyFromCompose
  - applyFromCompose_mult1_minted_tags / applyFromCompose_mult0_marked_tag
  - applyFromCompose_omega_tag / applyFromCompose_linear_and_erased_order
  - applyIsValid_count_tags_desync_false (inventory consistency)
  These EmitApply theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on EmitApply != host proof complete != residual free.
  Does not invent a second emit dialect; does not grow product C.

  Intentional non-claims / partial parity:
  - PARTIAL vs full C EMIT_APPLY_V0: host uses List Nat tags (no fixed C array,
    no null pointers, no exact -1 return codes).
  - APPLY_CAP is not a claim that apply supports 32 live nodes while the program
    still caps at 8.
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Not full product C body codegen. Not residual free.

  Greppable: SYSTEMS_LEAN_HOST, EMIT-APPLY, EMIT_APPLY_V0, APPLY_CAP,
  SLAKE_EMIT_APPLY_CAP, FAIL-CLOSED, HOST-COMPOSE, EMIT-PLAN, RUNTIME-FS,
  slake_emit_apply, applyFromCompose, fromCompose, applyIsValid, checkFailClosed,
  EMIT-APPLY-THEOREM, HOST-EMIT-APPLY-THEOREM, applyCap_eq_32, applyOk_empty_true,
  applyOk_linear_without_mint_false, packTag_linear,
  applyFromCompose_mult1_minted_tags, applyFromCompose_linear_and_erased_order,
  applyIsValid_count_tags_desync_false
  UNIT_SURFACE host surface. Module: SystemsLean.EmitApply
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.HostCompose

namespace SystemsLean.EmitApply

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind)
open SystemsLean.HostCompose (Host)

/-- Fixed apply capacity matching emit SLAKE_EMIT_APPLY_CAP (APPLY_CAP honesty). -/
def applyCap : Nat := 32

/-- EMIT-APPLY tag buffer (emit map: slake_emit_apply).
    tags: packed mult/kind bytes as Nat (0..255 range honesty).
    PARTIAL vs full C: List under applyCap, no fixed C array. -/
structure Apply where
  tags : List Nat
  count : Nat
  valid : Bool
  deriving DecidableEq, Repr

/-- Fail-closed empty apply (emit: on fail valid=0 count=0). -/
def Apply.failClosed : Apply := {
  tags := []
  count := 0
  valid := false
}

/-- Mult wire code (high nibble source): MULT-0=0, MULT-1=1, MULT-OMEGA=2. -/
def multCode : Mult -> Nat
  | Mult.mult0 => 0
  | Mult.mult1 => 1
  | Mult.multOmega => 2

/-- Kind wire code (low nibble source): VALUE=0, LINEAR=1, ERASED=2. -/
def kindCode : NodeKind -> Nat
  | NodeKind.value => 0
  | NodeKind.linear => 1
  | NodeKind.erased => 2

/-- packTag n -- one byte: (mult & 0xF) << 4 | (kind & 0xF).
    Emit map honesty: same packing as slake_emit_apply_from_compose. -/
def packTag (n : IrNode) : Nat :=
  (multCode n.mult) * 16 + kindCode n.kind

/-- Unpack mult nibble from packed tag (high nibble). -/
def tagMult (tag : Nat) : Nat := tag / 16

/-- Unpack kind nibble from packed tag (low nibble). -/
def tagKind (tag : Nat) : Nat := tag % 16

/-- applyFromCompose hc -- serialise live node tags from HostCompose.
    FAIL-CLOSED: HostCompose.checkFailClosed required; count > applyCap rejects.
    Empty checked compose: count=0, valid=true.
    Greppable: EMIT-APPLY, FAIL-CLOSED, HOST-COMPOSE, APPLY_CAP, applyFromCompose. -/
def applyFromCompose (hc : Host) : Apply :=
  if !HostCompose.checkFailClosed hc then
    Apply.failClosed
  else
    let nodes := hc.graph.prog.nodes
    let n := nodes.length
    if n > applyCap then
      Apply.failClosed
    else
      let tags := nodes.map packTag
      { tags := tags, count := n, valid := true }

/-- Greppable emit-map alias for applyFromCompose (slake_emit_apply_from_compose honesty).
    Prefer applyFromCompose when opening multiple Emit* modules (open-clash hygiene). -/
def fromCompose (hc : Host) : Apply := applyFromCompose hc

/-- applyIsValid a -- true when apply inventory is consistent (emit map honesty:
    slake_emit_apply_is_valid). Host strengthens beyond a.valid alone:
      - count <= applyCap
      - count == tags.length
    Hand-built Apply with valid=true but desynced count/tags fails closed.
    Primary name (avoids open clash with EmitBody.bodyIsValid / short isValid). -/
def applyIsValid (a : Apply) : Bool :=
  a.valid
    && decide (a.count <= applyCap)
    && decide (a.count == a.tags.length)

/-- applyOk hc -- applyFromCompose + applyIsValid convenience. -/
def applyOk (hc : Host) : Bool :=
  applyIsValid (applyFromCompose hc)

/-! ### EMIT-APPLY-THEOREM / HOST-EMIT-APPLY-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is applyCap,
  empty-compose apply validity, fail-closed MULT-1 unminted, definitional tag
  packing, minted/marked tag inventory, multi-node program order, and
  applyIsValid count/tags consistency. Does not complete SpecProof; does not
  claim residual free / freestanding product self-host complete / PROVABLY.
  Does not invent a second emit dialect.
-/

/-- applyCap matches emit SLAKE_EMIT_APPLY_CAP (APPLY_CAP honesty).
    Greppable: applyCap_eq_32, SLAKE_EMIT_APPLY_CAP, EMIT-APPLY-THEOREM,
    HOST-EMIT-APPLY-THEOREM. -/
theorem applyCap_eq_32 : applyCap = 32 := rfl

/-- applyOk is definitionally applyIsValid (applyFromCompose hc).
    Greppable: applyOk_eq, EMIT-APPLY-THEOREM. -/
theorem applyOk_eq (hc : Host) :
    applyOk hc = applyIsValid (applyFromCompose hc) := rfl

/-- fromCompose is definitionally applyFromCompose (emit-map alias honesty).
    Greppable: fromCompose_eq_applyFromCompose, EMIT-APPLY-THEOREM. -/
theorem fromCompose_eq_applyFromCompose (hc : Host) :
    fromCompose hc = applyFromCompose hc := rfl

/-- Fail-closed empty apply is not applyIsValid.
    Greppable: applyIsValid_failClosed_false, FAIL-CLOSED, EMIT-APPLY-THEOREM,
    HOST-EMIT-APPLY-THEOREM. -/
theorem applyIsValid_failClosed_false :
    applyIsValid Apply.failClosed = false := by decide

/-- Empty compose apply is valid with count 0.
    Greppable: applyOk_empty_true, EMIT-APPLY-THEOREM, HOST-EMIT-APPLY-THEOREM. -/
theorem applyOk_empty_true : applyOk HostCompose.empty = true := by decide

/-- Empty compose apply inventory is zero tags / count 0 / valid.
    Greppable: applyFromCompose_empty_zero, EMIT-APPLY-THEOREM,
    HOST-EMIT-APPLY-THEOREM. -/
theorem applyFromCompose_empty_zero :
    (let a := applyFromCompose HostCompose.empty
     a.valid && a.count == 0 && a.tags.isEmpty) = true := by decide

/-- Tag packing: MULT-1 LINEAR -> mult=1 kind=1 -> 0x11 = 17.
    Greppable: packTag_linear, EMIT-APPLY-THEOREM, HOST-EMIT-APPLY-THEOREM. -/
theorem packTag_linear :
    packTag { ty := Types.typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }
      = 17 := rfl

/-- Tag packing: MULT-0 ERASED -> mult=0 kind=2 -> 0x02 = 2.
    Greppable: packTag_erased, EMIT-APPLY-THEOREM. -/
theorem packTag_erased :
    packTag { ty := Types.typeTagInit 0, mult := Mult.mult0, kind := NodeKind.erased }
      = 2 := rfl

/-- Tag packing: MULT-OMEGA VALUE -> mult=2 kind=0 -> 0x20 = 32.
    Greppable: packTag_value, EMIT-APPLY-THEOREM. -/
theorem packTag_value :
    packTag { ty := Types.typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }
      = 32 := rfl

/-- Unpack mult nibble of packed linear tag 17.
    Greppable: tagMult_linear_17, EMIT-APPLY-THEOREM. -/
theorem tagMult_linear_17 : tagMult 17 = 1 := rfl

/-- Unpack kind nibble of packed linear tag 17.
    Greppable: tagKind_linear_17, EMIT-APPLY-THEOREM. -/
theorem tagKind_linear_17 : tagKind 17 = 1 := rfl

/-- Unpack mult/kind nibbles of packed erased tag 2.
    Greppable: tagMult_erased_2, tagKind_erased_2, EMIT-APPLY-THEOREM. -/
theorem tagMult_erased_2 : tagMult 2 = 0 := rfl
theorem tagKind_erased_2 : tagKind 2 = 2 := rfl

/-- Unpack mult/kind nibbles of packed value tag 32.
    Greppable: tagMult_value_32, tagKind_value_32, EMIT-APPLY-THEOREM. -/
theorem tagMult_value_32 : tagMult 32 = 2 := rfl
theorem tagKind_value_32 : tagKind 32 = 0 := rfl

/-! ### Non-empty apply fixtures (theorem surface, not only smoke)
    Concrete hosts so tag inventory claims reduce without push/mint match escapes. -/

private def thmLinearNode : IrNode :=
  { ty := Types.typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }

private def thmErasedNode : IrNode :=
  { ty := Types.typeTagInit 0, mult := Mult.mult0, kind := NodeKind.erased }

private def thmValueNode : IrNode :=
  { ty := Types.typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

/-- One MULT-1 node, unminted linear host (checkFailClosed fails). -/
private def thmHostMult1Unminted : Host :=
  { HostCompose.empty with
    graph := { prog := { nodes := [thmLinearNode] }, edges := [] } }

/-- One MULT-1 node with live token (mint evidence). -/
private def thmHostMult1Minted : Host :=
  { HostCompose.empty with
    graph := { prog := { nodes := [thmLinearNode] }, edges := [] }
    linear := { live := true, id := 1 } }

/-- One MULT-0 node with markErased. -/
private def thmHostMult0Marked : Host :=
  HostCompose.markErased
    { HostCompose.empty with
      graph := { prog := { nodes := [thmErasedNode] }, edges := [] } }

/-- One MULT-OMEGA value node (no mint/mark required). -/
private def thmHostOmega : Host :=
  { HostCompose.empty with
    graph := { prog := { nodes := [thmValueNode] }, edges := [] } }

/-- MULT-1 (minted) then MULT-0 (marked): tags [17, 2] in program order. -/
private def thmHostLinearAndErased : Host :=
  HostCompose.markErased
    { HostCompose.empty with
      graph := { prog := { nodes := [thmLinearNode, thmErasedNode] }, edges := [] }
      linear := { live := true, id := 9 } }

/-- MULT-1 without mint fails apply (fail-closed).
    Greppable: applyOk_linear_without_mint_false, MULT-1, FAIL-CLOSED,
    EMIT-APPLY-THEOREM, HOST-EMIT-APPLY-THEOREM. -/
theorem applyOk_linear_without_mint_false :
    applyOk thmHostMult1Unminted = false := by decide

/-- MULT-1 with mint packs tag mult=1 kind=1 -> 0x11 = 17.
    Greppable: applyFromCompose_mult1_minted_tags, MULT-1, EMIT-APPLY-THEOREM,
    HOST-EMIT-APPLY-THEOREM. -/
theorem applyFromCompose_mult1_minted_tags :
    (let a := applyFromCompose thmHostMult1Minted
     a.valid && a.count == 1 && a.tags == [17]
       && tagMult 17 == 1 && tagKind 17 == 1) = true := by decide

/-- MULT-0 marked packs mult=0 kind=2 -> 0x02 = 2.
    Greppable: applyFromCompose_mult0_marked_tag, MULT-0, EMIT-APPLY-THEOREM,
    HOST-EMIT-APPLY-THEOREM. -/
theorem applyFromCompose_mult0_marked_tag :
    (let a := applyFromCompose thmHostMult0Marked
     a.valid && a.count == 1 && a.tags == [2]
       && tagMult 2 == 0 && tagKind 2 == 2) = true := by decide

/-- MULT-OMEGA packs mult=2 kind=0 -> 0x20 = 32.
    Greppable: applyFromCompose_omega_tag, MULT-OMEGA, EMIT-APPLY-THEOREM,
    HOST-EMIT-APPLY-THEOREM. -/
theorem applyFromCompose_omega_tag :
    (let a := applyFromCompose thmHostOmega
     a.valid && a.count == 1 && a.tags == [32]
       && tagMult 32 == 2 && tagKind 32 == 0) = true := by decide

/-- Multi-node program order tags [linear=17, erased=2].
    Greppable: applyFromCompose_linear_and_erased_order, EMIT-APPLY-THEOREM,
    HOST-EMIT-APPLY-THEOREM. -/
theorem applyFromCompose_linear_and_erased_order :
    (let a := applyFromCompose thmHostLinearAndErased
     applyIsValid a && a.count == 2 && a.tags == [17, 2]) = true := by decide

/-- Hand-built Apply with valid=true but count/tags desync fails closed.
    Greppable: applyIsValid_count_tags_desync_false, FAIL-CLOSED,
    EMIT-APPLY-THEOREM, HOST-EMIT-APPLY-THEOREM. -/
theorem applyIsValid_count_tags_desync_false :
    (let a1 : Apply := { tags := [17], count := 2, valid := true }
     let a2 : Apply := { tags := [17, 2], count := 1, valid := true }
     !applyIsValid a1 && !applyIsValid a2) = true := by decide

/-! ### Emit apply smoke (behavioral; lake build fails if an example does not hold)
    Greppable: EMIT-APPLY-SMOKE. Exercises empty ok, tag packing, multi-node order. -/

private def smokeLinearNode : IrNode :=
  { ty := Types.typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }

private def smokeErasedNode : IrNode :=
  { ty := Types.typeTagInit 0, mult := Mult.mult0, kind := NodeKind.erased }

private def smokeValueNode : IrNode :=
  { ty := Types.typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

private def smokePush (hc : Host) (n : IrNode) : Host :=
  match HostCompose.pushHostNode hc n with
  | HostCompose.HostPushNodeResult.ok hc' => hc'
  | _ => hc

private def smokeMint (hc : Host) (id : Nat) : Host :=
  match HostCompose.mint hc id with
  | HostCompose.MintResult.ok hc' => hc'
  | _ => hc

/-- MULT-1 (minted) then MULT-0 (marked): tags [17, 2] in program order. -/
private def smokeLinearAndErased : Host :=
  HostCompose.markErased
    (smokeMint
      (smokePush (smokePush HostCompose.empty smokeLinearNode) smokeErasedNode) 9)

/-- EMIT-APPLY-SMOKE: applyCap is 32 (SLAKE_EMIT_APPLY_CAP honesty). -/
example : applyCap = 32 := by decide

/-- EMIT-APPLY-SMOKE: empty compose apply is valid with count 0. -/
example : applyOk HostCompose.empty = true := by decide
example :
    (let a := applyFromCompose HostCompose.empty
     a.valid && a.count == 0 && a.tags.isEmpty) = true := by decide

/-- EMIT-APPLY-SMOKE: MULT-1 without mint fails apply (fail-closed). -/
example : applyOk (smokePush HostCompose.empty smokeLinearNode) = false := by decide

/-- EMIT-APPLY-SMOKE: MULT-1 with mint packs tag mult=1 kind=1 -> 0x11 = 17. -/
example :
    (let a := applyFromCompose (smokeMint (smokePush HostCompose.empty smokeLinearNode) 3)
     a.valid && a.count == 1 && a.tags == [17]
       && tagMult 17 == 1 && tagKind 17 == 1) = true := by decide

/-- EMIT-APPLY-SMOKE: MULT-0 marked packs mult=0 kind=2 -> 0x02 = 2. -/
example :
    (let a := applyFromCompose (HostCompose.markErased (smokePush HostCompose.empty smokeErasedNode))
     a.valid && a.count == 1 && a.tags == [2]
       && tagMult 2 == 0 && tagKind 2 == 2) = true := by decide

/-- EMIT-APPLY-SMOKE: MULT-OMEGA packs mult=2 kind=0 -> 0x20 = 32. -/
example :
    (let a := applyFromCompose (smokePush HostCompose.empty smokeValueNode)
     a.valid && a.count == 1 && a.tags == [32]
       && tagMult 32 == 2 && tagKind 32 == 0) = true := by decide

/-- EMIT-APPLY-SMOKE: packTag table for closed mult/kind. -/
example : packTag smokeLinearNode = 17 := by decide
example : packTag smokeErasedNode = 2 := by decide
example : packTag smokeValueNode = 32 := by decide

/-- EMIT-APPLY-SMOKE: multi-node program order tags [linear=17, erased=2]. -/
example :
    (let a := applyFromCompose smokeLinearAndErased
     applyIsValid a && a.count == 2 && a.tags == [17, 2]) = true := by decide

/-- EMIT-APPLY-SMOKE: hand-built Apply with valid=true but count/tags desync fails. -/
example :
    (let a : Apply := { tags := [17], count := 2, valid := true }
     !applyIsValid a) = true := by decide
example :
    (let a : Apply := { tags := [17, 2], count := 1, valid := true }
     !applyIsValid a) = true := by decide

end SystemsLean.EmitApply
