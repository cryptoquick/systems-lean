/-
  SYSTEMS_LEAN_HOST partial -- emit body fragment readiness on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): extract.md EMIT_BODY_V0 notes,
    emit slake_emit_body / slake_emit_body_from_compose / slake_emit_body_is_valid
    (frozen wire honesty only; SLAKE_EMIT_BODY_CAP = 256).

  Spec (readable, separate from any future proof):
  - Thin EMIT-BODY host: body fragment readiness inventory from checked HostCompose
    via EmitPlan + EmitApply (does not reimplement those checks).
  - bodyCap = 256 matching emit SLAKE_EMIT_BODY_CAP (defensive headroom under
    programCap 8 live nodes for V0 fragment format).
  - bodyFromCompose is FAIL-CLOSED: requires plan ready and apply valid; on fail
    valid=false, len=0, markers false.
  - On ok: records plan runtime/erased counts, apply tag count, and a thin
    deterministic fragment string (header line + per-tag lines) under bodyCap.
  - Marker flags are derived from buf substrings (EMIT_BODY_V0 / RUNTIME-FS),
    not hardcoded true on success.
  - bodyIsValid: valid && len < bodyCap && markers present in buf.
  - EMIT-BOUNDARY / RUNTIME-FS: fragment claims freestanding product goal text;
    not a product wire reimplementation.

  Open hygiene (name clash):
  - Prefer bodyFromCompose and bodyIsValid (primary). Greppable alias fromCompose
    is emit-map honesty only. Never open more than one SystemsLean.Emit* namespace
    at once; call EmitPlan.planFromCompose / EmitApply.applyFromCompose /
    EmitBody.bodyFromCompose with module qualification when combining.

  Intentional non-claims / partial parity:
  - PARTIAL vs full C EMIT_BODY_V0: host uses String + Nat inventory (no fixed
    char array, no null pointers, no exact -1 return codes).
  - BODY_CAP is not a claim that arbitrary IR modules fit in 256 bytes.
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not full product module emit / CFG/SSA. Not residual free.

  HOST-EMIT-SSOT (P2): this module owns the EMIT_BODY_V0 fragment dialect.
  Durable artifact: src/systems/emit/host_emit_body_fragment.ssot.txt
  (EMPTY_FRAGMENT + HEADER_*/TAG_* keys must match buildFragment).
  Bash script/slake-emit-freestanding-c.sh is NON-SSOT for fragment text;
  it must read/embed the artifact dialect, not invent a second format.
  PARTIAL: host String inventory vs freestanding C fixed char buf remains.

  Greppable: SYSTEMS_LEAN_HOST, EMIT-BODY, EMIT_BODY_V0, BODY_CAP,
  SLAKE_EMIT_BODY_CAP, RUNTIME-FS, EMIT-BOUNDARY, FAIL-CLOSED, HOST-COMPOSE,
  EMIT-PLAN, EMIT-APPLY, slake_emit_body, bodyFromCompose, fromCompose,
  bodyIsValid, buildFragment, HOST-EMIT-SSOT, emptyComposeFragmentSsot
  UNIT_SURFACE host surface. Module: SystemsLean.EmitBody
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.HostCompose
import SystemsLean.EmitPlan
import SystemsLean.EmitApply

namespace SystemsLean.EmitBody

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind)
open SystemsLean.HostCompose (Host)
open SystemsLean.EmitPlan (Plan)
open SystemsLean.EmitApply (Apply)

/-- Fixed body capacity matching emit SLAKE_EMIT_BODY_CAP (BODY_CAP honesty). -/
def bodyCap : Nat := 256

/-- EMIT-BODY fragment readiness (emit map: slake_emit_body).
    PARTIAL vs full C: String fragment + inventory fields (no fixed C char buf). -/
structure Body where
  buf : String
  len : Nat
  valid : Bool
  runtimeNodes : Nat
  erasedNodes : Nat
  tagCount : Nat
  hasEmitBodyMarker : Bool
  hasRuntimeFsMarker : Bool
  deriving DecidableEq, Repr

/-- Fail-closed empty body (emit: valid=0 len=0 buf[0]=0). -/
def Body.failClosed : Body := {
  buf := ""
  len := 0
  valid := false
  runtimeNodes := 0
  erasedNodes := 0
  tagCount := 0
  hasEmitBodyMarker := false
  hasRuntimeFsMarker := false
}

/-- Decimal digits for small Nat counts (smoke / inventory honesty only). -/
private def natToDec : Nat -> String
  | 0 => "0"
  | n =>
    let rec go (k : Nat) (acc : String) : Nat -> String
      | 0 => acc
      | fuel + 1 =>
        if k = 0 then acc
        else go (k / 10) (String.ofList [Char.ofNat (k % 10 + 48)] ++ acc) fuel
    go n "" n

/-- One tag line: /* tI mult=X kind=Y */\n (emit map honesty). -/
private def tagLine (i tag : Nat) : String :=
  "/* t" ++ natToDec i
    ++ " mult=" ++ natToDec (EmitApply.tagMult tag)
    ++ " kind=" ++ natToDec (EmitApply.tagKind tag)
    ++ " */\n"

/-- Fold tag lines in program order (index 0..count-1). -/
private def tagLines : List Nat -> Nat -> String
  | [], _ => ""
  | t :: rest, i => tagLine i t ++ tagLines rest (i + 1)

/-- HOST-EMIT-SSOT: exact empty-compose fragment text.
    Must match EMPTY_FRAGMENT in emit/host_emit_body_fragment.ssot.txt
    (plus trailing newline). bodyFromCompose HostCompose.empty uses this. -/
def emptyComposeFragmentSsot : String :=
  "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */\n"

/-- buildFragment plan apply -- deterministic V0 fragment text (HOST-EMIT-SSOT).
    Header: /* EMIT_BODY_V0 RUNTIME-FS r=N e=M */
    Then one tag line per apply tag. Greppable EMIT_BODY_V0 / RUNTIME-FS.
    Empty plan+apply yields emptyComposeFragmentSsot. -/
def buildFragment (plan : Plan) (apply : Apply) : String :=
  "/* EMIT_BODY_V0 RUNTIME-FS r="
    ++ natToDec plan.runtimeNodes
    ++ " e="
    ++ natToDec plan.erasedNodes
    ++ " */\n"
    ++ tagLines apply.tags 0

/-- List-char prefix check (decide-friendly; no String.splitOn). -/
private def listIsPrefix : List Char -> List Char -> Bool
  | [], _ => true
  | _, [] => false
  | a :: as, b :: bs => decide (a = b) && listIsPrefix as bs

/-- Contiguous sublist search (decide-friendly). Empty needle is false. -/
private def listHasSublist : List Char -> List Char -> Bool
  | _, [] => false
  | [], _ => false
  | hay@(_ :: ht), needle =>
    listIsPrefix needle hay || listHasSublist ht needle

/-- hasSubstr s needle -- true when needle appears as contiguous substring of s.
    Used to derive greppable EMIT_BODY_V0 / RUNTIME-FS markers from buf. -/
def hasSubstr (s needle : String) : Bool :=
  listHasSublist s.toList needle.toList

/-- bufHasEmitBodyMarker buf -- greppable EMIT_BODY_V0 substring in fragment. -/
def bufHasEmitBodyMarker (buf : String) : Bool :=
  hasSubstr buf "EMIT_BODY_V0"

/-- bufHasRuntimeFsMarker buf -- greppable RUNTIME-FS substring in fragment. -/
def bufHasRuntimeFsMarker (buf : String) : Bool :=
  hasSubstr buf "RUNTIME-FS"

/-- bodyFromCompose hc -- body fragment readiness from HostCompose via plan + apply.
    FAIL-CLOSED: plan must be ready; apply must be valid; fragment length must
    be strictly less than bodyCap. Does not reimplement HostCompose checks.
    Marker flags derived from buf (not hardcoded true).
    Greppable: EMIT-BODY, FAIL-CLOSED, HOST-COMPOSE, EMIT-PLAN, EMIT-APPLY,
    bodyFromCompose. -/
def bodyFromCompose (hc : Host) : Body :=
  let plan := EmitPlan.planFromCompose hc
  if !EmitPlan.isReady plan then
    Body.failClosed
  else
    let apply := EmitApply.applyFromCompose hc
    if !EmitApply.applyIsValid apply then
      Body.failClosed
    else
      let buf := buildFragment plan apply
      let len := buf.length
      if len >= bodyCap then
        Body.failClosed
      else
        {
          buf := buf
          len := len
          valid := true
          runtimeNodes := plan.runtimeNodes
          erasedNodes := plan.erasedNodes
          tagCount := apply.count
          hasEmitBodyMarker := bufHasEmitBodyMarker buf
          hasRuntimeFsMarker := bufHasRuntimeFsMarker buf
        }

/-- Greppable emit-map alias for bodyFromCompose (slake_emit_body_from_compose honesty).
    Prefer bodyFromCompose when opening multiple Emit* modules (open-clash hygiene). -/
def fromCompose (hc : Host) : Body := bodyFromCompose hc

/-- bodyIsValid b -- true when body is valid, under bodyCap, and markers in buf.
    Emit map honesty: slake_emit_body_is_valid (valid + len < CAP).
    Re-derives greppable substrings from buf (does not trust stored flags alone).
    Host String has no separate NUL; len is String.length.
    Primary name (avoids open clash with short isValid). -/
def bodyIsValid (b : Body) : Bool :=
  b.valid
    && decide (b.len < bodyCap)
    && bufHasEmitBodyMarker b.buf
    && bufHasRuntimeFsMarker b.buf

/-- bodyOk hc -- bodyFromCompose + bodyIsValid convenience. -/
def bodyOk (hc : Host) : Bool :=
  bodyIsValid (bodyFromCompose hc)

/-! ### Emit body smoke (behavioral; lake build fails if an example does not hold)
    Greppable: EMIT-BODY-SMOKE. Exercises empty ok, markers from buf, multi-node. -/

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

/-- MULT-1 (minted) then MULT-0 (marked): r=1 e=1, two tag lines. -/
private def smokeLinearAndErased : Host :=
  HostCompose.markErased
    (smokeMint
      (smokePush (smokePush HostCompose.empty smokeLinearNode) smokeErasedNode) 9)

/-- EMIT-BODY-SMOKE: bodyCap is 256 (SLAKE_EMIT_BODY_CAP honesty). -/
example : bodyCap = 256 := by decide

/-- EMIT-BODY-SMOKE: empty compose body is valid; r=0 e=0; markers from buf. -/
example : bodyOk HostCompose.empty = true := by decide
example :
    (let b := bodyFromCompose HostCompose.empty
     b.valid && b.runtimeNodes == 0 && b.erasedNodes == 0 && b.tagCount == 0
       && b.hasEmitBodyMarker && b.hasRuntimeFsMarker
       && bufHasEmitBodyMarker b.buf && bufHasRuntimeFsMarker b.buf
       && decide (b.len < bodyCap)) = true := by decide

/-- EMIT-BODY-SMOKE: empty fragment == HOST-EMIT-SSOT emptyComposeFragmentSsot. -/
example :
    (let b := bodyFromCompose HostCompose.empty
     b.buf == emptyComposeFragmentSsot) = true := by decide
example : emptyComposeFragmentSsot == "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */\n" := by
  decide

/-- EMIT-BODY-SMOKE: MULT-1 without mint fails body (fail-closed). -/
example : bodyOk (smokePush HostCompose.empty smokeLinearNode) = false := by decide
example :
    (let b := bodyFromCompose (smokePush HostCompose.empty smokeLinearNode)
     !b.valid && b.len == 0 && !b.hasEmitBodyMarker) = true := by decide

/-- EMIT-BODY-SMOKE: MULT-1 with mint -- full fragment text (header + one tag line). -/
example :
    (let b := bodyFromCompose (smokeMint (smokePush HostCompose.empty smokeLinearNode) 5)
     bodyIsValid b && b.runtimeNodes == 1 && b.erasedNodes == 0 && b.tagCount == 1
       && b.buf ==
         "/* EMIT_BODY_V0 RUNTIME-FS r=1 e=0 */\n/* t0 mult=1 kind=1 */\n") = true := by
  decide

/-- EMIT-BODY-SMOKE: MULT-0 marked -- full fragment text (mult=0 kind=2). -/
example :
    (let b := bodyFromCompose (HostCompose.markErased (smokePush HostCompose.empty smokeErasedNode))
     bodyIsValid b && b.erasedNodes == 1 && b.runtimeNodes == 0 && b.tagCount == 1
       && b.buf ==
         "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=1 */\n/* t0 mult=0 kind=2 */\n") = true := by
  decide

/-- EMIT-BODY-SMOKE: MULT-OMEGA: runtimeNodes=1 inventory. -/
example :
    (let b := bodyFromCompose (smokePush HostCompose.empty smokeValueNode)
     bodyIsValid b && b.runtimeNodes == 1 && b.erasedNodes == 0) = true := by decide

/-- EMIT-BODY-SMOKE: multi-node fragment inventory + exact tag lines. -/
example :
    (let b := bodyFromCompose smokeLinearAndErased
     bodyIsValid b && b.runtimeNodes == 1 && b.erasedNodes == 1 && b.tagCount == 2
       && b.buf ==
         "/* EMIT_BODY_V0 RUNTIME-FS r=1 e=1 */\n/* t0 mult=1 kind=1 */\n/* t1 mult=0 kind=2 */\n")
      = true := by decide

end SystemsLean.EmitBody
