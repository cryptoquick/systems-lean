/-
  SYSTEMS_LEAN_HOST partial -- Extract / emit boundary on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): Extract.slake, extract.md,
    emit FAIL_CLOSED_CHECKER_V1 / slake_extract_with_checks (frozen wire honesty only).

  Spec (readable, separate from any future proof):
  - EMIT-BOUNDARY: host elaborator / proofs vs product extract stay distinct.
  - Three runtime stories: Idris RefC; classic Lean AOT (RUNTIME-CLASSIC /
    EDGE-RUNTIME managed residual); freestanding product goal (RUNTIME-FS).
  - RuntimeClaim is closed: runtimeFs | runtimeClassic | edgeRuntime.
  - Product extract accepts only RUNTIME-FS (runtimeClassic / edgeRuntime reject).
  - extractOk / checkFailClosed are PARTIAL FAIL_CLOSED_CHECKER_V1 host honesty
    (not full C checker parity; not full host compose).
  - Rules enforced here (fail closed, not residual free):
      MULT-0 needs marked erased; claimed runtime must be freestanding (RUNTIME-FS);
      unknown mult/runtime tags fail on raw-tag path.
  - MULT-1 / MULT-OMEGA under RUNTIME-FS: host passes grade alone (no live-token
    evidence). Frozen C slake_check_fail_closed requires a live token for MULT-1;
    fuller host path is SystemsLean.HostCompose (intentional Extract thinning).

  Theorems (EXTRACT-THEOREM / HOST-EXTRACT-THEOREM -- partial Extract only):
  - isFreestandingGoal_runtimeFs / isFreestandingGoal_classic_false /
    isFreestandingGoal_edge_false (RUNTIME-FS only is freestanding goal)
  - extractOk_classic_reject / extractOk_edge_reject (EMIT-BOUNDARY reject)
  - extractOk_mult1_fs_true / extractOk_omega_fs_true (intentional MULT-1 gap)
  - extractOk_mult0_unmarked_false / extractOk_mult0_marked_fs_true
  - ofRuntimeTag?_zero/one/two / ofRuntimeTag?_fail_closed /
    isValidRuntimeTag_fail_closed / isValidRuntimeTag_zero/one/two
    (FAIL-CLOSED-UNKNOWN-RUNTIME)
  - ofRuntimeTag?_some_implies_isValidRuntimeTag (success implies valid tag)
  - extractOkFromTags? known-tag success/fail paths + unknown none
  - extractOk_eq_checkFailClosed / RuntimeClaim.name_* honesty
  These Extract theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on Extract != host proof complete != residual free.
  Intentional MULT-1 thinning remains (no live-token evidence here).

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not a full compiler body. Not HOST_COMPOSE_V0 reimplementation.
  - Not full FAIL_CLOSED_CHECKER_V1 / slake_extract_with_checks parity (MULT-1 gap).
  - Not residual free.
  - Frozen C enum collapses CLASSIC / EDGE-RUNTIME into one wire tag; host keeps
    three claims for honesty (raw tag 1 classic, 2 edge; both fail product extract).

  Greppable: SYSTEMS_LEAN_HOST, EMIT-BOUNDARY, RUNTIME-FS, EDGE-RUNTIME, RUNTIME-CLASSIC,
  FAIL-CLOSED, FAIL_CLOSED_CHECKER_V1, EXTRACT-THEOREM, HOST-EXTRACT-THEOREM,
  isFreestandingGoal_runtimeFs, extractOk_classic_reject, ofRuntimeTag?_fail_closed,
  ofRuntimeTag?_some_implies_isValidRuntimeTag, extractOkFromTags?_mult1_fs_true,
  extractOkFromTags?_mult0_marked_fs_true, isValidRuntimeTag_zero
  UNIT_SURFACE host surface. Module: SystemsLean.Extract
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Erasure

namespace SystemsLean.Extract

open SystemsLean.Mult (Mult)
open SystemsLean.Erasure (Erased)

/-- Runtime claim for extract / emit boundary honesty (EMIT-BOUNDARY).
    runtimeFs = RUNTIME-FS freestanding product goal (no Lean managed runtime).
    runtimeClassic = RUNTIME-CLASSIC stock-host managed residual.
    edgeRuntime = EDGE-RUNTIME stock-host / bridge managed residual.
    Product extract accepts only runtimeFs. -/
inductive RuntimeClaim where
  | runtimeFs
  | runtimeClassic
  | edgeRuntime
  deriving DecidableEq, Repr

/-- Human-facing runtime claim ids (greppable contract surface). -/
def RuntimeClaim.name : RuntimeClaim -> String
  | RuntimeClaim.runtimeFs => "RUNTIME-FS"
  | RuntimeClaim.runtimeClassic => "RUNTIME-CLASSIC"
  | RuntimeClaim.edgeRuntime => "EDGE-RUNTIME"

/-- True when claim is the freestanding product goal (RUNTIME-FS).
    EDGE-RUNTIME / RUNTIME-CLASSIC are not accepted on product extract. -/
def isFreestandingGoal (c : RuntimeClaim) : Bool :=
  match c with
  | RuntimeClaim.runtimeFs => true
  | RuntimeClaim.runtimeClassic => false
  | RuntimeClaim.edgeRuntime => false

/-- Raw tag decode for host RuntimeClaim.
    0 = RUNTIME-FS; 1 = RUNTIME-CLASSIC; 2 = EDGE-RUNTIME.
    Frozen C slake_runtime_class only exposes FS=0 and CLASSIC=1 (edge collapsed
    into classic on the wire); host keeps three claims for honesty.
    FAIL-CLOSED-UNKNOWN-RUNTIME: unknown tags return none. -/
def ofRuntimeTag? : Nat -> Option RuntimeClaim
  | 0 => some RuntimeClaim.runtimeFs
  | 1 => some RuntimeClaim.runtimeClassic
  | 2 => some RuntimeClaim.edgeRuntime
  | _ => none

/-- FAIL-CLOSED-UNKNOWN-RUNTIME on raw tags: true only for known 0/1/2. -/
def isValidRuntimeTag (n : Nat) : Bool := (ofRuntimeTag? n).isSome

/-- checkFailClosed m e claim -- PARTIAL FAIL_CLOSED_CHECKER_V1 host honesty
    (not full C checker; not residual free).
    Fail closed when:
      - MULT-0 without marked erased (ERASE-RULE-MULT-0 / ERASE-NO-RUNTIME)
      - claimed runtime is not RUNTIME-FS (EDGE-RUNTIME / RUNTIME-CLASSIC reject)
    MULT-1 / MULT-OMEGA under RUNTIME-FS: always true here (erasure handle ignored).
    Intentional gap: frozen C slake_check_fail_closed requires a live linear token
    for MULT-1; this Extract path does not. Fuller host: HostCompose.checkFailClosed.
    EMIT-BOUNDARY honesty only. -/
def checkFailClosed (m : Mult) (e : Erased) (claim : RuntimeClaim) : Bool :=
  if !isFreestandingGoal claim then
    false
  else
    match m with
    | Mult.mult0 => SystemsLean.Erasure.checkFailClosed m e
    | Mult.mult1 => true
    | Mult.multOmega => true

/-- extractOk -- same bar as checkFailClosed (PARTIAL host extract path honesty).
    Not full C slake_extract_with_checks parity: MULT-1 always passes when claim is
    RUNTIME-FS (no live-token evidence). Fuller host: HostCompose.extractOk requires
    RuntimeClaim.runtimeFs and HostCompose.checkFailClosed, which runs multPreScan:
    any MULT-1 graph node needs a live LinearHost (hc.linear.live); any MULT-0 needs
    marked erased; empty compose / MULT-OMEGA-only may extract without mint.
    Emit map name only: wire checker also needs live token for MULT-1; this path does not.
    On OK product wire sets out_rt to RUNTIME-FS (not modeled as mutation here). -/
def extractOk (m : Mult) (e : Erased) (claim : RuntimeClaim) : Bool :=
  checkFailClosed m e claim

/-- Raw-tag extract path: fail closed on unknown mult or runtime tags.
    Erased marked flag is host Bool (no null pointer on host).
    none = unknown tag (cannot decide); some false = known inputs that fail closed;
    some true = partial host extract OK under RUNTIME-FS (same MULT-1 gap as extractOk). -/
def extractOkFromTags? (multTag : Nat) (erasedMarked : Bool) (runtimeTag : Nat) : Option Bool :=
  match Mult.ofNat? multTag, ofRuntimeTag? runtimeTag with
  | some m, some claim =>
    some (extractOk m { marked := erasedMarked } claim)
  | _, _ => none

/-! ### EXTRACT-THEOREM / HOST-EXTRACT-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is RUNTIME-FS-only
  extract / FAIL-CLOSED-UNKNOWN-RUNTIME and intentional MULT-1 thinning honesty
  only. Does not complete SpecProof; does not claim residual free / freestanding
  product self-host complete / PROVABLY. Fuller MULT-1 live path is HostCompose.
-/

/-- RUNTIME-FS is the freestanding product goal.
    Greppable: isFreestandingGoal_runtimeFs, RUNTIME-FS, EXTRACT-THEOREM,
    HOST-EXTRACT-THEOREM. -/
theorem isFreestandingGoal_runtimeFs :
    isFreestandingGoal RuntimeClaim.runtimeFs = true := rfl

/-- RUNTIME-CLASSIC is not freestanding product goal.
    Greppable: isFreestandingGoal_classic_false, RUNTIME-CLASSIC, EXTRACT-THEOREM. -/
theorem isFreestandingGoal_classic_false :
    isFreestandingGoal RuntimeClaim.runtimeClassic = false := rfl

/-- EDGE-RUNTIME is not freestanding product goal.
    Greppable: isFreestandingGoal_edge_false, EDGE-RUNTIME, EXTRACT-THEOREM. -/
theorem isFreestandingGoal_edge_false :
    isFreestandingGoal RuntimeClaim.edgeRuntime = false := rfl

/-- extractOk is definitionally checkFailClosed.
    Greppable: extractOk_eq_checkFailClosed, EXTRACT-THEOREM. -/
theorem extractOk_eq_checkFailClosed (m : Mult) (e : Erased) (c : RuntimeClaim) :
    extractOk m e c = checkFailClosed m e c := rfl

/-- RUNTIME-CLASSIC rejects product extract for any mult/erasure (EMIT-BOUNDARY).
    Greppable: extractOk_classic_reject, RUNTIME-CLASSIC, EXTRACT-THEOREM,
    HOST-EXTRACT-THEOREM. -/
theorem extractOk_classic_reject (m : Mult) (e : Erased) :
    extractOk m e RuntimeClaim.runtimeClassic = false := by
  unfold extractOk checkFailClosed isFreestandingGoal
  simp

/-- EDGE-RUNTIME rejects product extract for any mult/erasure (EMIT-BOUNDARY).
    Greppable: extractOk_edge_reject, EDGE-RUNTIME, EXTRACT-THEOREM,
    HOST-EXTRACT-THEOREM. -/
theorem extractOk_edge_reject (m : Mult) (e : Erased) :
    extractOk m e RuntimeClaim.edgeRuntime = false := by
  unfold extractOk checkFailClosed isFreestandingGoal
  simp

/-- MULT-1 under RUNTIME-FS always passes on thin Extract path (intentional gap).
    Greppable: extractOk_mult1_fs_true, MULT-1, EXTRACT-THEOREM. -/
theorem extractOk_mult1_fs_true (e : Erased) :
    extractOk Mult.mult1 e RuntimeClaim.runtimeFs = true := rfl

/-- MULT-OMEGA under RUNTIME-FS always passes on thin Extract path.
    Greppable: extractOk_omega_fs_true, MULT-OMEGA, EXTRACT-THEOREM. -/
theorem extractOk_omega_fs_true (e : Erased) :
    extractOk Mult.multOmega e RuntimeClaim.runtimeFs = true := rfl

/-- MULT-0 unmarked fails closed under RUNTIME-FS (ERASE-NO-RUNTIME).
    Greppable: extractOk_mult0_unmarked_false, MULT-0, EXTRACT-THEOREM,
    HOST-EXTRACT-THEOREM. -/
theorem extractOk_mult0_unmarked_false :
    extractOk Mult.mult0 Erasure.unmarked RuntimeClaim.runtimeFs = false := rfl

/-- MULT-0 marked under RUNTIME-FS extracts OK.
    Greppable: extractOk_mult0_marked_fs_true, MULT-0, EXTRACT-THEOREM. -/
theorem extractOk_mult0_marked_fs_true :
    extractOk Mult.mult0 (Erasure.mark Erasure.unmarked) RuntimeClaim.runtimeFs =
      true := rfl

/-- Known raw tag 0 decodes to RUNTIME-FS.
    Greppable: ofRuntimeTag?_zero, EXTRACT-THEOREM. -/
theorem ofRuntimeTag?_zero :
    ofRuntimeTag? 0 = some RuntimeClaim.runtimeFs := rfl

/-- Known raw tag 1 decodes to RUNTIME-CLASSIC.
    Greppable: ofRuntimeTag?_one, EXTRACT-THEOREM. -/
theorem ofRuntimeTag?_one :
    ofRuntimeTag? 1 = some RuntimeClaim.runtimeClassic := rfl

/-- Known raw tag 2 decodes to EDGE-RUNTIME.
    Greppable: ofRuntimeTag?_two, EXTRACT-THEOREM. -/
theorem ofRuntimeTag?_two :
    ofRuntimeTag? 2 = some RuntimeClaim.edgeRuntime := rfl

/-- FAIL-CLOSED-UNKNOWN-RUNTIME: raw tags with n > 2 reject to none.
    Greppable: ofRuntimeTag?_fail_closed, FAIL-CLOSED-UNKNOWN-RUNTIME,
    EXTRACT-THEOREM, HOST-EXTRACT-THEOREM. -/
theorem ofRuntimeTag?_fail_closed (n : Nat) (h : 2 < n) : ofRuntimeTag? n = none := by
  cases n with
  | zero =>
    exact absurd h (by decide : Not (2 < 0))
  | succ n1 =>
    cases n1 with
    | zero =>
      exact absurd h (by decide : Not (2 < 1))
    | succ n2 =>
      cases n2 with
      | zero =>
        exact absurd h (by decide : Not (2 < 2))
      | succ _ =>
        rfl

/-- isValidRuntimeTag is definitionally ofRuntimeTag? isSome.
    Greppable: isValidRuntimeTag_eq_ofRuntimeTag?_isSome, EXTRACT-THEOREM. -/
theorem isValidRuntimeTag_eq_ofRuntimeTag?_isSome (n : Nat) :
    isValidRuntimeTag n = (ofRuntimeTag? n).isSome := rfl

/-- FAIL-CLOSED-UNKNOWN-RUNTIME on isValidRuntimeTag: n > 2 is false.
    Greppable: isValidRuntimeTag_fail_closed, FAIL-CLOSED-UNKNOWN-RUNTIME,
    EXTRACT-THEOREM, HOST-EXTRACT-THEOREM. -/
theorem isValidRuntimeTag_fail_closed (n : Nat) (h : 2 < n) :
    isValidRuntimeTag n = false := by
  unfold isValidRuntimeTag
  rw [ofRuntimeTag?_fail_closed n h]
  rfl

/-- RuntimeClaim.name honesty for freestanding product goal.
    Greppable: RuntimeClaim.name_runtimeFs, RUNTIME-FS, EXTRACT-THEOREM. -/
theorem RuntimeClaim.name_runtimeFs :
    RuntimeClaim.name RuntimeClaim.runtimeFs = "RUNTIME-FS" := rfl

/-- RuntimeClaim.name honesty for classic managed residual.
    Greppable: RuntimeClaim.name_runtimeClassic, RUNTIME-CLASSIC, EXTRACT-THEOREM. -/
theorem RuntimeClaim.name_runtimeClassic :
    RuntimeClaim.name RuntimeClaim.runtimeClassic = "RUNTIME-CLASSIC" := rfl

/-- RuntimeClaim.name honesty for edge managed residual.
    Greppable: RuntimeClaim.name_edgeRuntime, EDGE-RUNTIME, EXTRACT-THEOREM. -/
theorem RuntimeClaim.name_edgeRuntime :
    RuntimeClaim.name RuntimeClaim.edgeRuntime = "EDGE-RUNTIME" := rfl

/-- Unknown mult tag fails closed on raw-tag extract path.
    Greppable: extractOkFromTags?_unknown_mult_none, EXTRACT-THEOREM. -/
theorem extractOkFromTags?_unknown_mult_none :
    extractOkFromTags? 3 false 0 = none := rfl

/-- Unknown runtime tag fails closed on raw-tag extract path.
    Greppable: extractOkFromTags?_unknown_runtime_none, EXTRACT-THEOREM. -/
theorem extractOkFromTags?_unknown_runtime_none :
    extractOkFromTags? 1 false 3 = none := rfl

/-- Known raw tags 0/1/2 are valid runtime tags.
    Greppable: isValidRuntimeTag_zero, isValidRuntimeTag_one, isValidRuntimeTag_two,
    EXTRACT-THEOREM, HOST-EXTRACT-THEOREM. -/
theorem isValidRuntimeTag_zero : isValidRuntimeTag 0 = true := rfl
theorem isValidRuntimeTag_one : isValidRuntimeTag 1 = true := rfl
theorem isValidRuntimeTag_two : isValidRuntimeTag 2 = true := rfl

/-- Successful ofRuntimeTag? decode implies isValidRuntimeTag true
    (no soft unknown pass; mirrors Mult.ofNat?_some_implies_isValidTag).
    Greppable: ofRuntimeTag?_some_implies_isValidRuntimeTag,
    FAIL-CLOSED-UNKNOWN-RUNTIME, EXTRACT-THEOREM, HOST-EXTRACT-THEOREM. -/
theorem ofRuntimeTag?_some_implies_isValidRuntimeTag (n : Nat) (c : RuntimeClaim)
    (h : ofRuntimeTag? n = some c) : isValidRuntimeTag n = true := by
  unfold isValidRuntimeTag
  rw [h]
  rfl

/-- Known tags MULT-1 + RUNTIME-FS extract OK (intentional MULT-1 thinning).
    Greppable: extractOkFromTags?_mult1_fs_true, MULT-1, RUNTIME-FS,
    EXTRACT-THEOREM, HOST-EXTRACT-THEOREM. -/
theorem extractOkFromTags?_mult1_fs_true (erasedMarked : Bool) :
    extractOkFromTags? 1 erasedMarked 0 = some true := by
  cases erasedMarked <;> rfl

/-- Known tags MULT-OMEGA + RUNTIME-FS extract OK.
    Greppable: extractOkFromTags?_omega_fs_true, MULT-OMEGA, RUNTIME-FS,
    EXTRACT-THEOREM, HOST-EXTRACT-THEOREM. -/
theorem extractOkFromTags?_omega_fs_true (erasedMarked : Bool) :
    extractOkFromTags? 2 erasedMarked 0 = some true := by
  cases erasedMarked <;> rfl

/-- Known tags MULT-0 unmarked + RUNTIME-FS fails closed (some false).
    Greppable: extractOkFromTags?_mult0_unmarked_fs_false, MULT-0, ERASE-NO-RUNTIME,
    EXTRACT-THEOREM, HOST-EXTRACT-THEOREM. -/
theorem extractOkFromTags?_mult0_unmarked_fs_false :
    extractOkFromTags? 0 false 0 = some false := rfl

/-- Known tags MULT-0 marked + RUNTIME-FS extract OK.
    Greppable: extractOkFromTags?_mult0_marked_fs_true, MULT-0, RUNTIME-FS,
    EXTRACT-THEOREM, HOST-EXTRACT-THEOREM. -/
theorem extractOkFromTags?_mult0_marked_fs_true :
    extractOkFromTags? 0 true 0 = some true := rfl

/-- MULT-1 + RUNTIME-CLASSIC rejects product extract (some false; EMIT-BOUNDARY).
    Greppable: extractOkFromTags?_classic_reject, RUNTIME-CLASSIC, EXTRACT-THEOREM,
    HOST-EXTRACT-THEOREM. -/
theorem extractOkFromTags?_classic_reject :
    extractOkFromTags? 1 false 1 = some false := rfl

/-- MULT-1 + EDGE-RUNTIME rejects product extract (some false; EMIT-BOUNDARY).
    Greppable: extractOkFromTags?_edge_reject, EDGE-RUNTIME, EXTRACT-THEOREM,
    HOST-EXTRACT-THEOREM. -/
theorem extractOkFromTags?_edge_reject :
    extractOkFromTags? 1 false 2 = some false := rfl

/-- Both unknown mult and runtime tags fail closed (none).
    Greppable: extractOkFromTags?_both_unknown_none, EXTRACT-THEOREM. -/
theorem extractOkFromTags?_both_unknown_none :
    extractOkFromTags? 3 false 3 = none := rfl

end SystemsLean.Extract
