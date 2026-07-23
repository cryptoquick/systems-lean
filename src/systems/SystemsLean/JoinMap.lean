/-
  SYSTEMS_LEAN_HOST partial -- host-side dual / JOIN map into compile-path readiness.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Dual cite inventory (read-only; do not reimplement duals here):
    src/idris2/examples/{ConsumeToken,ErasedIndex,UnrestrictedShare}.idr
    src/lean4/examples/{ConsumeToken,ErasedIndex,UnrestrictedShare}.lean
  Companion map: src/systems/join-map.md (stated dual -> Slake use table).

  Stated map (dual algorithm -> Systems / Slake use; dual-cite alone is not enough):
  | Dual algorithm     | Host use (executable pin)                     | Product wire (honesty)              |
  |--------------------|-----------------------------------------------|-------------------------------------|
  | ConsumeToken       | HostCompose mint/consume + LinearHost empty   | slake_consume_token_* / linear_token|
  | ErasedIndex        | Erasure mark / isRuntimeAbsent + MULT-0       | slake_erasure_is_runtime_absent     |
  | UnrestrictedShare  | Mult multOmega / name MULT-OMEGA + shareNat   | MULT-OMEGA grade surface            |
  Note: Linear.Token / mkToken / consume / roundTrip remain dual-cite axioms on
  Linear.lean (classic elaborator cannot enforce MULT-1); joinAlgUseOk does NOT
  pin those axioms (noncomputable). ConsumeToken use evidence is HostCompose
  live-flag mint/consume only. shareNat is UnrestrictedShare only (not
  ConsumeToken).

  Spec (readable, separate from any future proof):
  - SLAKE_JOIN_MAP_V0 / HOST-JOIN-MAP / JOIN-MAP: host map from dual-pair
    JOIN-ALG honesty into Slake compile-path readiness composition.
  - joinDualCiteOk: surface dual-path inventory for all three JOIN-ALG examples.
    Not a filesystem walk of dual trees.
  - joinAlgUseOk: host module *use* pins (HostCompose, Erasure, Mult +
    Linear.shareNat for UnrestrictedShare only), not dual-example path strings
    alone. Greppable: joinAlgUseOk, JOIN-ALG-USE.
  - joinAlgContractOk: joinDualCiteOk && joinAlgUseOk && stage/map ids.
    Surface canary, not formal dual-bridge theorems.
  - joinUnitCompileReady hc: CompilePath.unitCompileReady && joinAlgContractOk
    (FAIL-CLOSED composition; reuses unit bar APIs; no parallel type zoo).
  - joinProgramCompileReady p: CompilePath.programCompileReady && joinAlgContractOk
    (sibling API; EMPTY-PROGRAM-FAIL-CLOSED preserved; empty host OK != empty program OK).
  - joinCompileReady hc: alias of joinUnitCompileReady (HOST-JOIN-MAP unit bar).
  - Verdict records joinOk / unitReady / ok for inventory (ok == both).

  Theorems (JOIN-MAP-THEOREM / HOST-JOIN-MAP-THEOREM -- partial JoinMap only):
  - joinAlgContractOk_true / joinAlgUseOk_true / stageId_eq / hostJoinMapId_eq
  - joinUnitCompileReady_empty_true / joinProgramCompileReady_empty_false
  - joinCompileReady_eq_joinUnitCompileReady
  - empty_host_ok_ne_empty_program_ok (join sibling bars)
  - joinUnitCompileReady_eq / joinProgramCompileReady_eq (definitional composition)
  - joinUnitCompileReady_mult1_unminted_false / joinUnitCompileReady_mult1_minted_true
  - joinProgramCompileReady_single_value (non-empty well-typed program path)
  These JoinMap theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial path contracts != formal dual-bridge theorems != residual free.

  Intentional non-claims / partial parity:
  - PARTIAL: host Bool map inventory vs formal dual-bridge theorems inventing
    duals; this module cites duals read-only and composes existing host APIs.
  - PARTIAL: joinAlgContractOk is surface-level (cite inventory + host use pins),
    not a structure walk of dual sources or full bridge proof.
  - Classic Lean cannot enforce MULT-1 / LINEAR-EXACT-ONCE; Linear axioms +
    HostCompose live flag remain the contract (see Linear.lean / HostCompose).
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Not a full Slake compiler body. Not residual free.
  - Does not fold program bar into unit bar (sibling APIs; P3 residual lesson).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_JOIN_MAP_V0, HOST-JOIN-MAP, JOIN-MAP,
  JOIN-ALG, JOIN-ALG-USE, ConsumeToken, ErasedIndex, UnrestrictedShare,
  LINEAR-EXACT-ONCE, MULT-1, MULT-0, MULT-OMEGA, HOST-COMPILE-PATH,
  SLAKE_COMPILE_PATH_V1, joinUnitCompileReady, joinProgramCompileReady,
  joinCompileReady, joinAlgContractOk, joinAlgUseOk, joinDualCiteOk,
  JOIN-MAP-SMOKE, EMPTY-PROGRAM-FAIL-CLOSED, FAIL-CLOSED,
  JOIN-MAP-THEOREM, HOST-JOIN-MAP-THEOREM,
  joinUnitCompileReady_empty_true, joinProgramCompileReady_empty_false,
  joinUnitCompileReady_eq, joinProgramCompileReady_eq,
  joinUnitCompileReady_mult1_unminted_false, joinUnitCompileReady_mult1_minted_true,
  joinProgramCompileReady_single_value, joinAlgUseOk_true,
  consumeTokenHostUseOk, erasedIndexHostUseOk, unrestrictedShareHostUseOk
  UNIT_SURFACE host surface. Module: SystemsLean.JoinMap
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Linear
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.Erasure
import SystemsLean.HostCompose
import SystemsLean.CompilePath

namespace SystemsLean.JoinMap

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind typeTagInit)
open SystemsLean.IrProgram (Program)
open SystemsLean.HostCompose (Host)

/-- Greppable primary stage id for host join map (P4). -/
def stageId : String := "SLAKE_JOIN_MAP_V0"

/-- Greppable host alias for join-map honesty (HOST-JOIN-MAP). -/
def hostJoinMapId : String := "HOST-JOIN-MAP"

/-- Greppable short map id (JOIN-MAP). -/
def joinMapId : String := "JOIN-MAP"

/-- JOIN-ALG algorithm family id (three dual-pair examples). -/
def joinAlgId : String := "JOIN-ALG"

/-- JOIN-ALG-USE: host *use* surface id (distinct from dual-path inventory). -/
def joinAlgUseId : String := "JOIN-ALG-USE"

/-- ConsumeToken dual algorithm name. -/
def consumeTokenAlgId : String := "ConsumeToken"

/-- ErasedIndex dual algorithm name. -/
def erasedIndexAlgId : String := "ErasedIndex"

/-- UnrestrictedShare dual algorithm name. -/
def unrestrictedShareAlgId : String := "UnrestrictedShare"

/-! ### Dual path inventory (read-only cites; not host use evidence alone) -/

/-- Read-only dual path cite (Idris ConsumeToken). Not a filesystem read. -/
def dualConsumeTokenIdris : String := "src/idris2/examples/ConsumeToken.idr"

/-- Read-only dual path cite (Lean ConsumeToken). -/
def dualConsumeTokenLean : String := "src/lean4/examples/ConsumeToken.lean"

/-- Read-only dual path cite (Idris ErasedIndex). -/
def dualErasedIndexIdris : String := "src/idris2/examples/ErasedIndex.idr"

/-- Read-only dual path cite (Lean ErasedIndex). -/
def dualErasedIndexLean : String := "src/lean4/examples/ErasedIndex.lean"

/-- Read-only dual path cite (Idris UnrestrictedShare). -/
def dualUnrestrictedShareIdris : String := "src/idris2/examples/UnrestrictedShare.idr"

/-- Read-only dual path cite (Lean UnrestrictedShare). -/
def dualUnrestrictedShareLean : String := "src/lean4/examples/UnrestrictedShare.lean"

/-- Legacy alias: ConsumeToken Idris path (kept for prior greppable surface). -/
def dualIdrisPath : String := dualConsumeTokenIdris

/-- Legacy alias: ConsumeToken Lean path. -/
def dualLeanPath : String := dualConsumeTokenLean

/-- joinLinearCiteOk -- ConsumeToken dual path inventory only (legacy name).
    Prefer joinDualCiteOk for the three-algorithm inventory. -/
def joinLinearCiteOk : Bool :=
  (dualConsumeTokenIdris == "src/idris2/examples/ConsumeToken.idr")
    && (dualConsumeTokenLean == "src/lean4/examples/ConsumeToken.lean")

/-- joinDualCiteOk -- three JOIN-ALG dual-pair path cites match layout.
    Surface inventory only (not FS walk; not host use).
    Greppable: joinDualCiteOk, ConsumeToken, ErasedIndex, UnrestrictedShare. -/
def joinDualCiteOk : Bool :=
  joinLinearCiteOk
    && (dualErasedIndexIdris == "src/idris2/examples/ErasedIndex.idr")
    && (dualErasedIndexLean == "src/lean4/examples/ErasedIndex.lean")
    && (dualUnrestrictedShareIdris == "src/idris2/examples/UnrestrictedShare.idr")
    && (dualUnrestrictedShareLean == "src/lean4/examples/UnrestrictedShare.lean")
    && (consumeTokenAlgId == "ConsumeToken")
    && (erasedIndexAlgId == "ErasedIndex")
    && (unrestrictedShareAlgId == "UnrestrictedShare")

/-! ### Host use pins (stated map into Slake -- not dual path strings alone)

  Each pin composes existing host defs used by Systems / Slake. Dual-example
  paths stay inventory; use evidence is host HostCompose / Erasure / Mult
  (plus Linear.shareNat only under UnrestrictedShare) that product wire already
  mirrors. Linear.Token / mkToken / consume axioms stay dual-cite on Linear.lean
  -- not folded into joinAlgUseOk (noncomputable; not the HostCompose use path).
-/

/-- Product API name honesty (HOST-EMIT-LINEAR ConsumeToken surface). -/
def productConsumeTokenMintApi : String := "slake_consume_token_mint"

/-- Product API name honesty (erasure runtime-absent). -/
def productErasureRuntimeAbsentApi : String := "slake_erasure_is_runtime_absent"

/-- Product grade name honesty (MULT-OMEGA unrestricted). -/
def productMultOmegaGrade : String := "MULT-OMEGA"

/-- HostCompose mint then consume once succeeds with payload (ConsumeToken use).
    Live-flag model only; not MULT-1 elaborator enforcement. -/
def hostMintConsumeOnceOk : Bool :=
  match HostCompose.mint HostCompose.empty 7 with
  | HostCompose.MintResult.ok hc =>
    match HostCompose.consume hc with
    | HostCompose.ConsumeResult.ok hc' p =>
        (p == 7) && (!hc'.linear.live)
    | HostCompose.ConsumeResult.notLive => false
  | HostCompose.MintResult.badId => false
  | HostCompose.MintResult.alreadyLive => false

/-- consumeTokenHostUseOk -- ConsumeToken used via HostCompose live-flag path.
    Empty LinearHost is not live; mint then consume once returns payload and
    clears live. Product mint API string pin. Does NOT pin Linear.Token /
    mkToken / consume / roundTrip axioms (dual-cite on Linear.lean only;
    noncomputable). Does NOT use Linear.shareNat (that is UnrestrictedShare).
    Greppable: consumeTokenHostUseOk, hostMintConsumeOnceOk, ConsumeToken,
    JOIN-ALG-USE. -/
def consumeTokenHostUseOk : Bool :=
  (!HostCompose.LinearHost.empty.live)
    && hostMintConsumeOnceOk
    && (productConsumeTokenMintApi == "slake_consume_token_mint")

/-- erasedIndexHostUseOk -- ErasedIndex side used via Erasure host module.
    isRuntimeAbsent fail-closed unmarked; mark -> runtime-absent; MULT-0 grade.
    Product erasure API string pin. Greppable: erasedIndexHostUseOk, ErasedIndex. -/
def erasedIndexHostUseOk : Bool :=
  (Erasure.isRuntimeAbsent Erasure.unmarked == false)
    && (Erasure.isRuntimeAbsent (Erasure.mark Erasure.unmarked) == true)
    && (Erasure.isErasureGrade Mult.mult0 == true)
    && (Erasure.checkFailClosed Mult.mult0 (Erasure.mark Erasure.unmarked) == true)
    && (productErasureRuntimeAbsentApi == "slake_erasure_is_runtime_absent")

/-- unrestrictedShareHostUseOk -- UnrestrictedShare via Mult omega + shareNat.
    Mult.name multOmega and Mult.isValid; Linear.shareNat unrestricted sketch
    (shareNat lives only here -- not under consumeTokenHostUseOk).
    Product MULT-OMEGA grade pin. Greppable: unrestrictedShareHostUseOk,
    UnrestrictedShare, MULT-OMEGA. -/
def unrestrictedShareHostUseOk : Bool :=
  (Mult.name Mult.multOmega == "MULT-OMEGA")
    && Mult.isValid Mult.multOmega
    && (Linear.shareNat 3 == 6)
    && (productMultOmegaGrade == "MULT-OMEGA")

/-- joinAlgUseOk -- three dual algorithms have host *use* pins (not path cite only).
    Greppable: joinAlgUseOk, JOIN-ALG-USE, ConsumeToken, ErasedIndex,
    UnrestrictedShare. -/
def joinAlgUseOk : Bool :=
  (joinAlgUseId == "JOIN-ALG-USE")
    && consumeTokenHostUseOk
    && erasedIndexHostUseOk
    && unrestrictedShareHostUseOk

/-- joinAlgContractOk -- JOIN-ALG dual-cite inventory + host use into Slake.
    Surface-level: algorithm ids + dual path cites + host module use pins.
    Does not elaborate dual .idr/.lean sources. Does not enforce MULT-1
    (Linear axioms + HostCompose live flag; classic elaborator gap).
    Greppable: joinAlgContractOk, JOIN-ALG, joinAlgUseOk, joinDualCiteOk. -/
def joinAlgContractOk : Bool :=
  (joinAlgId == "JOIN-ALG")
    && (stageId == "SLAKE_JOIN_MAP_V0")
    && (hostJoinMapId == "HOST-JOIN-MAP")
    && (joinMapId == "JOIN-MAP")
    && joinDualCiteOk
    && joinAlgUseOk

/-- JOIN-MAP readiness verdict (inventory; not product C).
    ok is the overall fail-closed bar used by joinUnitCompileReady. -/
structure Verdict where
  joinOk : Bool
  unitReady : Bool
  ok : Bool
  deriving DecidableEq, Repr

/-- Fail-closed zeroed verdict. -/
def Verdict.failClosed : Verdict := {
  joinOk := false
  unitReady := false
  ok := false
}

/-- joinUnitCompileReady hc -- join-informed unit compile-path bar.
    FAIL-CLOSED: CompilePath.unitCompileReady && joinAlgContractOk.
    Reuses unit bar (extractOkFs + gradeSurfaceOk); no parallel type zoo.
    Does not fold programCompileReady (sibling API).
    Greppable: joinUnitCompileReady, HOST-JOIN-MAP, HOST-COMPILE-PATH. -/
def joinUnitCompileReady (hc : Host) : Bool :=
  CompilePath.unitCompileReady hc && joinAlgContractOk

/-- joinCompileReady hc -- HOST-JOIN-MAP unit bar alias of joinUnitCompileReady.
    Empty HostCompose is OK when unit bar holds (vacuous mult pre-scan).
    Does not emit C. Does not claim freestanding residual free. -/
def joinCompileReady (hc : Host) : Bool :=
  joinUnitCompileReady hc

/-- joinProgramCompileReady p -- join-informed program compile-path bar (sibling).
    FAIL-CLOSED: CompilePath.programCompileReady && joinAlgContractOk.
    EMPTY-PROGRAM-FAIL-CLOSED: empty ordered program is not program-ready
    (distinct from empty HostCompose, which is unit-ready under join map).
    Greppable: joinProgramCompileReady, EMPTY-PROGRAM-FAIL-CLOSED. -/
def joinProgramCompileReady (p : Program) : Bool :=
  CompilePath.programCompileReady p && joinAlgContractOk

/-- verdictOf hc -- inventory Verdict from join map + unit compile readiness.
    ok == joinUnitCompileReady hc. Does not fold program bar. -/
def verdictOf (hc : Host) : Verdict :=
  let joinOk := joinAlgContractOk
  let unitReady := CompilePath.unitCompileReady hc
  {
    joinOk := joinOk
    unitReady := unitReady
    ok := joinOk && unitReady
  }

/-! ### JOIN-MAP-THEOREM / HOST-JOIN-MAP-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is join surface
  canaries, host use pins, empty-host unit readiness, and empty-program
  fail-closed only. Does not complete SpecProof; does not claim residual free /
  formal dual-bridge theorems / freestanding product self-host complete /
  PROVABLY.
-/

/-- Primary stage id is greppable SLAKE_JOIN_MAP_V0.
    Greppable: stageId_eq, JOIN-MAP-THEOREM, HOST-JOIN-MAP-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_JOIN_MAP_V0" := rfl

/-- Host alias id is greppable HOST-JOIN-MAP.
    Greppable: hostJoinMapId_eq, JOIN-MAP-THEOREM. -/
theorem hostJoinMapId_eq : hostJoinMapId = "HOST-JOIN-MAP" := rfl

/-- Host use pins for three JOIN-ALG dual algorithms hold.
    Greppable: joinAlgUseOk_true, JOIN-ALG-USE, JOIN-MAP-THEOREM,
    HOST-JOIN-MAP-THEOREM. -/
theorem joinAlgUseOk_true : joinAlgUseOk = true := by decide

/-- JOIN-ALG dual-cite + host-use surface canary holds.
    Greppable: joinAlgContractOk_true, JOIN-ALG, JOIN-MAP-THEOREM,
    HOST-JOIN-MAP-THEOREM. -/
theorem joinAlgContractOk_true : joinAlgContractOk = true := by decide

/-- joinCompileReady is definitionally joinUnitCompileReady.
    Greppable: joinCompileReady_eq_joinUnitCompileReady, JOIN-MAP-THEOREM. -/
theorem joinCompileReady_eq_joinUnitCompileReady (hc : Host) :
    joinCompileReady hc = joinUnitCompileReady hc := rfl

/-- Empty HostCompose is join-unit-ready (unit bar + join surface).
    Greppable: joinUnitCompileReady_empty_true, JOIN-MAP-THEOREM,
    HOST-JOIN-MAP-THEOREM. -/
theorem joinUnitCompileReady_empty_true :
    joinUnitCompileReady HostCompose.empty = true := by decide

/-- EMPTY-PROGRAM-FAIL-CLOSED on join program bar.
    Greppable: joinProgramCompileReady_empty_false, EMPTY-PROGRAM-FAIL-CLOSED,
    JOIN-MAP-THEOREM, HOST-JOIN-MAP-THEOREM. -/
theorem joinProgramCompileReady_empty_false :
    joinProgramCompileReady IrProgram.empty = false := by decide

/-- Honesty: empty host join-unit OK is not empty program join-program OK.
    Greppable: empty_host_ok_ne_empty_program_ok, JOIN-MAP-THEOREM,
    HOST-JOIN-MAP-THEOREM. -/
theorem empty_host_ok_ne_empty_program_ok :
    (joinUnitCompileReady HostCompose.empty = true)
      /\ (joinProgramCompileReady IrProgram.empty = false) :=
  And.intro joinUnitCompileReady_empty_true joinProgramCompileReady_empty_false

/-- joinUnitCompileReady is definitionally unitCompileReady && joinAlgContractOk.
    Greppable: joinUnitCompileReady_eq, JOIN-MAP-THEOREM, HOST-JOIN-MAP-THEOREM. -/
theorem joinUnitCompileReady_eq (hc : Host) :
    joinUnitCompileReady hc =
      (CompilePath.unitCompileReady hc && joinAlgContractOk) := rfl

/-- joinProgramCompileReady is definitionally programCompileReady && joinAlgContractOk.
    Greppable: joinProgramCompileReady_eq, JOIN-MAP-THEOREM. -/
theorem joinProgramCompileReady_eq (p : Program) :
    joinProgramCompileReady p =
      (CompilePath.programCompileReady p && joinAlgContractOk) := rfl

/-! ### Non-empty path contracts (beyond empty host vs empty program canaries) -/

private def thmValueNode : IrNode :=
  { ty := typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

private def thmLinearNode : IrNode :=
  { ty := typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }

private def thmSingleValueProg : Program := { nodes := [thmValueNode] }

private def thmHostMult1Unminted : Host := {
  graph := { prog := { nodes := [thmLinearNode] }, edges := [] }
  linear := HostCompose.LinearHost.empty
  erased := Erasure.unmarked
}

private def thmHostMult1Minted : Host := {
  graph := { prog := { nodes := [thmLinearNode] }, edges := [] }
  linear := { live := true, id := 4 }
  erased := Erasure.unmarked
}

/-- MULT-1 host without mint fails join-unit-ready (unit bar fail-closed).
    Greppable: joinUnitCompileReady_mult1_unminted_false, MULT-1,
    JOIN-MAP-THEOREM, HOST-JOIN-MAP-THEOREM. -/
theorem joinUnitCompileReady_mult1_unminted_false :
    joinUnitCompileReady thmHostMult1Unminted = false := by decide

/-- MULT-1 host with mint is join-unit-ready (unit bar + join surface).
    Greppable: joinUnitCompileReady_mult1_minted_true, MULT-1,
    JOIN-MAP-THEOREM, HOST-JOIN-MAP-THEOREM. -/
theorem joinUnitCompileReady_mult1_minted_true :
    joinUnitCompileReady thmHostMult1Minted = true := by decide

/-- One well-typed VALUE node is join-program-ready (sibling of empty fail).
    Greppable: joinProgramCompileReady_single_value, JOIN-MAP-THEOREM,
    HOST-JOIN-MAP-THEOREM. -/
theorem joinProgramCompileReady_single_value :
    joinProgramCompileReady thmSingleValueProg = true := by decide

/-! ### Join-map smoke (behavioral; lake build fails if an example does not hold)
    Greppable: JOIN-MAP-SMOKE. Exercises dual-cite surface, host use pins,
    empty host OK, empty program fail-closed, MULT-1 mint path, sibling bars. -/

private def smokeLinearNode : IrNode :=
  { ty := typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }

private def smokeErasedNode : IrNode :=
  { ty := typeTagInit 0, mult := Mult.mult0, kind := NodeKind.erased }

private def smokeValueNode : IrNode :=
  { ty := typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

private def smokePush (hc : Host) (n : IrNode) : Host :=
  match HostCompose.pushHostNode hc n with
  | HostCompose.HostPushNodeResult.ok hc' => hc'
  | _ => hc

private def smokeMint (hc : Host) (id : Nat) : Host :=
  match HostCompose.mint hc id with
  | HostCompose.MintResult.ok hc' => hc'
  | _ => hc

private def smokePushProg (p : Program) (n : IrNode) : Program :=
  match IrProgram.push p n with
  | IrProgram.PushResult.ok p' => p'
  | _ => p

/-- JOIN-MAP-SMOKE: stage / map ids are greppable honesty strings. -/
example : stageId = "SLAKE_JOIN_MAP_V0" := by decide
example : hostJoinMapId = "HOST-JOIN-MAP" := by decide
example : joinMapId = "JOIN-MAP" := by decide
example : joinAlgId = "JOIN-ALG" := by decide
example : joinAlgUseId = "JOIN-ALG-USE" := by decide
example : consumeTokenAlgId = "ConsumeToken" := by decide
example : erasedIndexAlgId = "ErasedIndex" := by decide
example : unrestrictedShareAlgId = "UnrestrictedShare" := by decide

/-- JOIN-MAP-SMOKE: three dual path cites match dual-pair layout (inventory). -/
example : dualConsumeTokenIdris = "src/idris2/examples/ConsumeToken.idr" := by decide
example : dualConsumeTokenLean = "src/lean4/examples/ConsumeToken.lean" := by decide
example : dualErasedIndexIdris = "src/idris2/examples/ErasedIndex.idr" := by decide
example : dualErasedIndexLean = "src/lean4/examples/ErasedIndex.lean" := by decide
example : dualUnrestrictedShareIdris = "src/idris2/examples/UnrestrictedShare.idr" :=
  by decide
example : dualUnrestrictedShareLean = "src/lean4/examples/UnrestrictedShare.lean" :=
  by decide
example : dualIdrisPath = "src/idris2/examples/ConsumeToken.idr" := by decide
example : dualLeanPath = "src/lean4/examples/ConsumeToken.lean" := by decide
example : joinLinearCiteOk = true := by decide
example : joinDualCiteOk = true := by decide

/-- JOIN-MAP-SMOKE: host use pins (use vs dual-cite distinction). -/
example : consumeTokenHostUseOk = true := by decide
example : erasedIndexHostUseOk = true := by decide
example : unrestrictedShareHostUseOk = true := by decide
example : joinAlgUseOk = true := by decide
example : joinAlgContractOk = true := by decide
example : hostMintConsumeOnceOk = true := by decide
example : Mult.name Mult.multOmega = "MULT-OMEGA" := by decide
example : Erasure.isRuntimeAbsent Erasure.unmarked = false := by decide
example : productConsumeTokenMintApi = "slake_consume_token_mint" := by decide
example : productErasureRuntimeAbsentApi = "slake_erasure_is_runtime_absent" :=
  by decide
example : productMultOmegaGrade = "MULT-OMEGA" := by decide

/-- JOIN-MAP-SMOKE: empty HostCompose is join-unit-ready (unit bar + join). -/
example : joinCompileReady HostCompose.empty = true := by decide
example : joinUnitCompileReady HostCompose.empty = true := by decide
example :
    (let v := verdictOf HostCompose.empty
     v.ok && v.joinOk && v.unitReady) = true := by decide

/-- JOIN-MAP-SMOKE: empty ordered program is NOT join-program-ready.
    Sibling bar: empty host OK != empty program OK (P3 residual lesson). -/
example : joinProgramCompileReady IrProgram.empty = false := by decide

/-- JOIN-MAP-SMOKE: MULT-OMEGA-only host is join-unit-ready without mint. -/
example :
    joinUnitCompileReady (smokePush HostCompose.empty smokeValueNode) = true := by
  decide

/-- JOIN-MAP-SMOKE: MULT-1 without mint fails join-unit-ready (multPreScan). -/
example :
    joinCompileReady (smokePush HostCompose.empty smokeLinearNode) = false := by
  decide
example :
    (let v := verdictOf (smokePush HostCompose.empty smokeLinearNode)
     !v.ok && v.joinOk && !v.unitReady) = true := by decide

/-- JOIN-MAP-SMOKE: MULT-1 with mint is join-unit-ready. -/
example :
    joinUnitCompileReady
      (smokeMint (smokePush HostCompose.empty smokeLinearNode) 4) = true := by
  decide

/-- JOIN-MAP-SMOKE: MULT-0 without mark fails; with markErased ok. -/
example :
    joinCompileReady (smokePush HostCompose.empty smokeErasedNode) = false := by
  decide
example :
    joinCompileReady
      (HostCompose.markErased (smokePush HostCompose.empty smokeErasedNode))
      = true := by decide

/-- JOIN-MAP-SMOKE: well-typed non-empty program is join-program-ready. -/
example :
    (let p := smokePushProg IrProgram.empty smokeValueNode
     joinProgramCompileReady p) = true := by decide

/-- JOIN-MAP-SMOKE: failClosed verdict is not ok. -/
example : Verdict.failClosed.ok = false := by decide

/-- JOIN-MAP-SMOKE: unit bar does not imply program bar on empty program
    (sibling APIs; do not conflate). -/
example :
    (joinUnitCompileReady HostCompose.empty
      && !joinProgramCompileReady IrProgram.empty) = true := by decide

end SystemsLean.JoinMap
