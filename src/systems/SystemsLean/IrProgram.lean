/-
  SYSTEMS_LEAN_HOST partial -- ordered IR program (node list) on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): Types.slake / types.md ir_program notes,
    emit slake_ir_program_* (historical stage id IR_PROGRAM_V0 on frozen wire).
  Shared core map: doc/shared-ir-sketch.md.

  Spec (readable, separate from any future proof):
  - An ordered IR program is a fixed-capacity ordered list of typed IR nodes.
  - Capacity honesty: programCap = 8 (emit SLAKE_IR_PROGRAM_CAP).
  - Host uses List under the cap; emit uses a fixed array of the same capacity.
  - push appends a well-typed node; fail closed on bad node or full capacity.
  - isWellTyped: non-empty, length <= programCap, and every live node well-typed.
  - EMPTY-PROGRAM-FAIL-CLOSED: empty program (count 0) is NOT well-typed as a
    program (matches emit slake_ir_program_is_well_typed).
  - Oversize lists (length > programCap) fail well-typed (emit count > CAP reject).
  - foldWellTyped folds left-to-right only when the program is well-typed;
    otherwise none (fail closed).
  - Not a control-flow graph. Not graph edges (see SystemsLean.IrGraph for edge host surface).

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not a full elaborator. Not CFG / dominance / SSA.
  - Historical wire id IR_PROGRAM_V0 is emit map only; new host names prefer
    ordered IR program / node list (no banned metaphor jargon in this module).

  Greppable: SYSTEMS_LEAN_HOST, ORDERED-IR-PROGRAM, EMPTY-PROGRAM-FAIL-CLOSED,
  SLAKE_IR_PROGRAM_CAP, MULT-0, MULT-1, MULT-OMEGA, TYPED_IR_V0
  UNIT_SURFACE host surface. Module: SystemsLean.IrProgram
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Types

namespace SystemsLean.IrProgram

open SystemsLean.Types (IrNode)

/-- Fixed capacity matching emit SLAKE_IR_PROGRAM_CAP (honesty map). -/
def programCap : Nat := 8

/-- Ordered IR program: ordered list of typed IR nodes under programCap.
    ORDERED-IR-PROGRAM host surface. -/
structure Program where
  nodes : List IrNode
  deriving DecidableEq, Repr

/-- Empty ordered IR program (not well-typed as a program; see isWellTyped). -/
def empty : Program := { nodes := [] }

/-- Live node count. -/
def length (p : Program) : Nat := p.nodes.length

/-- True when no live nodes. -/
def isEmpty (p : Program) : Bool := p.nodes.isEmpty

/-- Result of push: ok with new program, bad node, or full capacity.
    Emit map: 0 ok; -1 null/bad; -2 full. -/
inductive PushResult where
  | ok (p : Program)
  | badNode
  | full
  deriving DecidableEq, Repr

/-- push p n -- append a well-typed node.
    Fail closed: badNode when n is not well-typed; full when at programCap.
    Bad push leaves the original program unchanged (caller keeps p). -/
def push (p : Program) (n : IrNode) : PushResult :=
  if !n.isWellTyped then
    PushResult.badNode
  else if p.nodes.length >= programCap then
    PushResult.full
  else
    PushResult.ok { nodes := p.nodes ++ [n] }

/-- isWellTyped p -- non-empty, within programCap, and every live node well-typed.
    EMPTY-PROGRAM-FAIL-CLOSED: empty program is not well-typed as a program.
    Oversize (length > programCap) fails closed (emit count > CAP parity). -/
def isWellTyped (p : Program) : Bool :=
  !p.nodes.isEmpty
    && decide (p.nodes.length <= programCap)
    && p.nodes.all IrNode.isWellTyped

/-- foldWellTyped p init f -- left-to-right fold over ordered nodes when the
    program is well-typed; none when empty or any node fails well-typed.
    Fail closed: does not fold an ill-typed program. -/
def foldWellTyped {alpha : Type} (p : Program) (init : alpha)
    (f : alpha -> IrNode -> alpha) : Option alpha :=
  if isWellTyped p then
    some (List.foldl f init p.nodes)
  else
    none

/-- Fail-closed program check (host V0): same bar as isWellTyped.
    Emit compose path adds FAIL_CLOSED_CHECKER_V1 per node; that is product wire. -/
def checkFailClosed (p : Program) : Bool := isWellTyped p

end SystemsLean.IrProgram
