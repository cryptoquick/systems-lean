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

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not a full compiler body. Not HOST_COMPOSE_V0 reimplementation.
  - Not full FAIL_CLOSED_CHECKER_V1 / slake_extract_with_checks parity (MULT-1 gap).
  - Not residual free.
  - Frozen C enum collapses CLASSIC / EDGE-RUNTIME into one wire tag; host keeps
    three claims for honesty (raw tag 1 classic, 2 edge; both fail product extract).

  Greppable: SYSTEMS_LEAN_HOST, EMIT-BOUNDARY, RUNTIME-FS, EDGE-RUNTIME, RUNTIME-CLASSIC,
  FAIL-CLOSED, FAIL_CLOSED_CHECKER_V1
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

end SystemsLean.Extract
