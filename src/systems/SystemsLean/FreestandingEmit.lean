/-
  SLAKE_EMIT_FREESTANDING_C_V0 -- Lean-owned freestanding product C emit writer.
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Writes src/systems/emit/slake_freestanding.{h,c} from:
    - emit/template_slake_freestanding.{h,c}.in (frozen wire templates)
    - emit/host_emit_body_fragment.ssot.txt (HOST-EMIT-SSOT dialect)
    - emit/host_emit_mult.ssot.txt (HOST-EMIT-MULT Mult product text)
    - emit/host_emit_linear.ssot.txt (HOST-EMIT-LINEAR Linear product text)
  Never writes out/freestanding-c/ (release copy is just out-freestanding-c).

  Spec (readable):
  - Fail-closed load of body + Mult + Linear SSOT keys/blocks.
  - EMPTY_FRAGMENT must match empty-compose dialect; HEADER_* recompose it.
  - Mult MULT_NAME_* and MULT_C_HEADER / MULT_C_BODY blocks required.
  - Linear LINEAR_C_HEADER / LINEAR_C_BODY blocks required.
  - Templates embed Mult + Linear via whole-line placeholders; body put_str via SSOT keys.
  - Stage honesty: not residual free; not PROVABLY; no product GC.

  Intentional non-claims:
  - Not freestanding residual free. Not PROVABLY. Not full Slake self-host.
  - Templates hold frozen bulk product wire (Types/IR/Emit APIs).
  - Mult + Linear + EMIT_BODY put_str dialect remain SSOT-owned (not a second dialect).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_EMIT_FREESTANDING_C_V0, HOST-EMIT-SSOT,
  HOST-EMIT-MULT, HOST-EMIT-LINEAR, NON-SSOT, UNIT_TRANSLATION_V0, UNIT_DEEPEN_V1,
  RUNTIME-FS, not residual free, UNIT_SURFACE host surface.
  Module: SystemsLean.FreestandingEmit
  Lake exe: slake-emit-freestanding-c
  Red/green: just out-freestanding-c; just systems-emit-wire; cc probe via check.sh
  Module must stay ASCII.
  Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
-/

namespace SystemsLean.FreestandingEmit

/-- Greppable freestanding emit stage id. -/
def stageId : String := "SLAKE_EMIT_FREESTANDING_C_V0"

/-- Expected empty-compose fragment (sans trailing newline; HOST-EMIT-SSOT). -/
def expectedEmptyFragment : String := "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */"

/-- True when s contains needle as a contiguous substring (empty needle => false). -/
def containsStr (s needle : String) : Bool :=
  if needle.isEmpty then false
  else (s.splitOn needle).length > 1

/-- Replace every occurrence of needle with repl (non-overlapping left-to-right). -/
def replaceAll (hay needle repl : String) : String :=
  if needle.isEmpty then hay
  else String.intercalate repl (hay.splitOn needle)

/-- KEY=value first match; none when missing. -/
def ssotGet (content key : String) : Option String :=
  let pref := key ++ "="
  let rec go : List String -> Option String
    | [] => none
    | line :: rest =>
      if line.startsWith pref then some (line.drop pref.length).copy
      else go rest
  go (content.splitOn "\n")

/-- Multi-line block between "# NAME_BEGIN" and "# NAME_END" (markers excluded). -/
def ssotBlock (content name : String) : Option String :=
  let beginMark := "# " ++ name ++ "_BEGIN"
  let endMark := "# " ++ name ++ "_END"
  let rec go (grab : Bool) (acc : List String) : List String -> Option String
    | [] =>
      if grab || acc.isEmpty then none
      else some (String.intercalate "\n" acc.reverse ++ "\n")
    | line :: rest =>
      if !grab && line == beginMark then go true acc rest
      else if grab && line == endMark then
        some (String.intercalate "\n" acc.reverse ++ "\n")
      else if grab then go true (line :: acc) rest
      else go false acc rest
  go false [] (content.splitOn "\n")

/-- Strip one trailing newline if present. -/
def stripTrailingNl (s : String) : String :=
  if s.endsWith "\n" then (s.dropEnd 1).copy else s

/-- Replace any line containing placeholder with Mult block lines (bash embed parity). -/
def embedPlaceholderLine (template placeholder content : String) : Option String :=
  if !containsStr template placeholder then none
  else
    let contentLines := (stripTrailingNl content).splitOn "\n"
    let rec go : List String -> List String
      | [] => []
      | line :: rest =>
        if containsStr line placeholder then contentLines ++ go rest
        else line :: go rest
    some (String.intercalate "\n" (go (template.splitOn "\n")))

/-- Fail with RED stage message to stderr. -/
def red (msg : String) : IO Unit :=
  IO.eprintln s!"RED {stageId}: {msg}"

/-- Require path exists as a file. -/
def requireFile (path : System.FilePath) (label : String) : IO Unit := do
  unless (<- path.pathExists) do
    red s!"{label} missing: {path}"
    throw (IO.userError s!"{stageId}: missing {path}")

/-- Require greppable token in content. -/
def requireToken (content token label : String) : IO Unit := do
  unless containsStr content token do
    red s!"{label} missing token {token}"
    throw (IO.userError s!"{stageId}: missing token {token}")

/-- Body SSOT dialect keys. -/
structure BodySsot where
  emptyFragment : String
  headerOpen : String
  headerE : String
  headerClose : String
  tagOpen : String
  tagMult : String
  tagKind : String
  tagClose : String
  deriving Repr

def loadBodySsot (path : System.FilePath) : IO BodySsot := do
  requireFile path "HOST-EMIT-SSOT artifact"
  let content <- IO.FS.readFile path
  requireToken content "HOST-EMIT-SSOT" "HOST-EMIT-SSOT"
  let get (k : String) : IO String := do
    match ssotGet content k with
    | some v => pure v
    | none =>
      red s!"HOST-EMIT-SSOT missing key {k} in {path}"
      throw (IO.userError s!"missing key {k}")
  let empty <- get "EMPTY_FRAGMENT"
  let hop <- get "HEADER_OPEN"
  let he <- get "HEADER_E"
  let hc <- get "HEADER_CLOSE"
  let tagOpen <- get "TAG_OPEN"
  let tagMult <- get "TAG_MULT"
  let tagKind <- get "TAG_KIND"
  let tagClose <- get "TAG_CLOSE"
  if empty != expectedEmptyFragment then
    red "EMPTY_FRAGMENT diverges from empty-compose SSOT"
    IO.eprintln s!"  got: {empty}"
    throw (IO.userError "EMPTY_FRAGMENT diverge")
  if hop ++ "0" ++ he ++ "0" ++ hc != empty then
    red "HEADER_* keys do not recompose EMPTY_FRAGMENT"
    throw (IO.userError "HEADER recompose")
  pure {
    emptyFragment := empty
    headerOpen := hop
    headerE := he
    headerClose := hc
    tagOpen := tagOpen
    tagMult := tagMult
    tagKind := tagKind
    tagClose := tagClose
  }

/-- Mult SSOT C blocks. -/
structure MultSsot where
  headerBlock : String
  bodyBlock : String
  deriving Repr

def loadMultSsot (path : System.FilePath) : IO MultSsot := do
  requireFile path "HOST-EMIT-MULT artifact"
  let content <- IO.FS.readFile path
  requireToken content "HOST-EMIT-MULT" "HOST-EMIT-MULT"
  requireToken content "NON-SSOT" "HOST-EMIT-MULT"
  for tok in (["MULT-0", "MULT-1", "MULT-OMEGA", "slake_mult_is_valid",
               "FAIL-CLOSED-UNKNOWN-GRADE"] : List String) do
    requireToken content tok "HOST-EMIT-MULT"
  let get (k : String) : IO String := do
    match ssotGet content k with
    | some v => pure v
    | none =>
      red s!"HOST-EMIT-MULT missing key {k} in {path}"
      throw (IO.userError s!"missing key {k}")
  let n0 <- get "MULT_NAME_0"
  let n1 <- get "MULT_NAME_1"
  let nO <- get "MULT_NAME_OMEGA"
  if n0 != "MULT-0" || n1 != "MULT-1" || nO != "MULT-OMEGA" then
    red "HOST-EMIT-MULT MULT_NAME_* diverge from Mult.name"
    IO.eprintln s!"  got: {n0} / {n1} / {nO}"
    throw (IO.userError "MULT_NAME diverge")
  let header <- match ssotBlock content "MULT_C_HEADER" with
    | some b => pure b
    | none =>
      red s!"HOST-EMIT-MULT missing block MULT_C_HEADER in {path}"
      throw (IO.userError "missing MULT_C_HEADER")
  let body <- match ssotBlock content "MULT_C_BODY" with
    | some b => pure b
    | none =>
      red s!"HOST-EMIT-MULT missing block MULT_C_BODY in {path}"
      throw (IO.userError "missing MULT_C_BODY")
  for tok in (["HOST-EMIT-MULT", "slake_mult_is_valid", "MULT-0", "MULT-1",
               "MULT-OMEGA"] : List String) do
    unless containsStr header tok do
      red s!"Mult SSOT header block missing token {tok}"
      throw (IO.userError s!"Mult header missing {tok}")
    unless containsStr body tok do
      red s!"Mult SSOT body block missing token {tok}"
      throw (IO.userError s!"Mult body missing {tok}")
  pure { headerBlock := header, bodyBlock := body }

/-- Linear SSOT C blocks. -/
structure LinearSsot where
  headerBlock : String
  bodyBlock : String
  deriving Repr

def loadLinearSsot (path : System.FilePath) : IO LinearSsot := do
  requireFile path "HOST-EMIT-LINEAR artifact"
  let content <- IO.FS.readFile path
  requireToken content "HOST-EMIT-LINEAR" "HOST-EMIT-LINEAR"
  requireToken content "NON-SSOT" "HOST-EMIT-LINEAR"
  for tok in (["LINEAR-EXACT-ONCE", "CONSUME_TOKEN_HOST_V0", "JOIN-ALG",
               "slake_linear_consume", "slake_consume_token_consume"] : List String) do
    requireToken content tok "HOST-EMIT-LINEAR"
  let header <- match ssotBlock content "LINEAR_C_HEADER" with
    | some b => pure b
    | none =>
      red s!"HOST-EMIT-LINEAR missing block LINEAR_C_HEADER in {path}"
      throw (IO.userError "missing LINEAR_C_HEADER")
  let body <- match ssotBlock content "LINEAR_C_BODY" with
    | some b => pure b
    | none =>
      red s!"HOST-EMIT-LINEAR missing block LINEAR_C_BODY in {path}"
      throw (IO.userError "missing LINEAR_C_BODY")
  for tok in (["HOST-EMIT-LINEAR", "slake_linear_consume", "slake_consume_token_consume",
               "LINEAR-EXACT-ONCE", "CONSUME_TOKEN_HOST_V0"] : List String) do
    unless containsStr header tok do
      red s!"Linear SSOT header block missing token {tok}"
      throw (IO.userError s!"Linear header missing {tok}")
    unless containsStr body tok do
      red s!"Linear SSOT body block missing token {tok}"
      throw (IO.userError s!"Linear body missing {tok}")
  pure { headerBlock := header, bodyBlock := body }

def renderHeader (template : String) (mult : MultSsot) (linear : LinearSsot) : IO String := do
  let withMult <- match embedPlaceholderLine template "__HOST_EMIT_MULT_HEADER__" mult.headerBlock with
    | none =>
      red "header template missing __HOST_EMIT_MULT_HEADER__"
      throw (IO.userError "missing mult header placeholder")
    | some s => pure s
  match embedPlaceholderLine withMult "__HOST_EMIT_LINEAR_HEADER__" linear.headerBlock with
  | none =>
    red "header template missing __HOST_EMIT_LINEAR_HEADER__"
    throw (IO.userError "missing linear header placeholder")
  | some s =>
    if containsStr s "__HOST_EMIT_MULT_" then
      red "Mult SSOT placeholders remain after header embed"
      throw (IO.userError "placeholder remain header mult")
    if containsStr s "__HOST_EMIT_LINEAR_" then
      red "Linear SSOT placeholders remain after header embed"
      throw (IO.userError "placeholder remain header linear")
    pure s

def renderSource (template : String) (body : BodySsot) (mult : MultSsot)
    (linear : LinearSsot) : IO String := do
  let withMult <- match embedPlaceholderLine template "__HOST_EMIT_MULT_BODY__" mult.bodyBlock with
    | none =>
      red "source template missing __HOST_EMIT_MULT_BODY__"
      throw (IO.userError "missing mult body placeholder")
    | some s => pure s
  let withLinear <- match embedPlaceholderLine withMult "__HOST_EMIT_LINEAR_BODY__" linear.bodyBlock with
    | none =>
      red "source template missing __HOST_EMIT_LINEAR_BODY__"
      throw (IO.userError "missing linear body placeholder")
    | some s => pure s
  let s := replaceAll withLinear "__SSOT_EMPTY_FRAGMENT__" body.emptyFragment
  let s := replaceAll s "__SSOT_HEADER_OPEN__" body.headerOpen
  let s := replaceAll s "__SSOT_HEADER_E__" body.headerE
  let s := replaceAll s "__SSOT_HEADER_CLOSE__" body.headerClose
  let s := replaceAll s "__SSOT_TAG_OPEN__" body.tagOpen
  let s := replaceAll s "__SSOT_TAG_MULT__" body.tagMult
  let s := replaceAll s "__SSOT_TAG_KIND__" body.tagKind
  let s := replaceAll s "__SSOT_TAG_CLOSE__" body.tagClose
  if containsStr s "__HOST_EMIT_MULT_" then
    red "Mult SSOT placeholders remain after source embed"
    throw (IO.userError "placeholder remain source mult")
  if containsStr s "__HOST_EMIT_LINEAR_" then
    red "Linear SSOT placeholders remain after source embed"
    throw (IO.userError "placeholder remain source linear")
  if containsStr s "__SSOT_" then
    red "body SSOT placeholders remain after source embed"
    throw (IO.userError "ssot placeholder remain")
  pure s

/-- Post-write honesty greps (contract-stable; pure Nix also checks product wire). -/
def validateProduct (path : System.FilePath) (content : String) (isSource : Bool)
    (body : BodySsot) : IO Unit := do
  for tok in ([
      "SLAKE_EMIT_FREESTANDING_C_V0", "UNIT_TRANSLATION_V0", "UNIT_DEEPEN_V1",
      "HOST-EMIT-SSOT", "HOST-EMIT-MULT", "HOST-EMIT-LINEAR", "RUNTIME-FS",
      "not residual free",
      "MULT-0", "MULT-1", "MULT-OMEGA", "slake_mult_is_valid",
      "EMIT_BODY_V0", "EMIT_PLAN_V0", "EMIT_APPLY_V0", "JOIN-ALG", "ConsumeToken",
      "LINEAR-EXACT-ONCE", "FAIL_CLOSED_CHECKER_V1", "CONSUME_TOKEN_HOST_V0",
      "TYPED_IR_V0", "IR_PROGRAM_V0", "IR_GRAPH_EDGES_V0", "HOST_COMPOSE_V0",
      "SLAKE_IR_PROGRAM_CAP", "SLAKE_IR_EDGE_MAX", "SLAKE_EMIT_APPLY_CAP",
      "SLAKE_EMIT_BODY_CAP"
    ] : List String) do
    requireToken content tok s!"{path}"
  if containsStr content "SLAKE_IR_EDGE_CAP" then
    red s!"{path} still cites SLAKE_IR_EDGE_CAP (use MAX)"
    throw (IO.userError "banned EDGE_CAP")
  if containsStr content "SLAKE_IR_PROGRAM_MAX" then
    red s!"{path} still cites SLAKE_IR_PROGRAM_MAX (use CAP)"
    throw (IO.userError "banned PROGRAM_MAX")
  if isSource then
    unless containsStr content body.headerOpen do
      red s!"{path} missing SSOT HEADER_OPEN dialect string"
      throw (IO.userError "missing HEADER_OPEN embed")
    unless containsStr content body.emptyFragment do
      red s!"{path} missing EMPTY_FRAGMENT reference from HOST-EMIT-SSOT"
      throw (IO.userError "missing EMPTY_FRAGMENT embed")

/-- Emit freestanding product C under emitDir (relative to repo root). -/
def emitAtRoot (root : System.FilePath) : IO Unit := do
  let emitDir := root / "src" / "systems" / "emit"
  let bodyPath := emitDir / "host_emit_body_fragment.ssot.txt"
  let multPath := emitDir / "host_emit_mult.ssot.txt"
  let linearPath := emitDir / "host_emit_linear.ssot.txt"
  let tmplH := emitDir / "template_slake_freestanding.h.in"
  let tmplC := emitDir / "template_slake_freestanding.c.in"
  let outH := emitDir / "slake_freestanding.h"
  let outC := emitDir / "slake_freestanding.c"

  IO.println s!"== {stageId}: freestanding emit path V0 (Lean FreestandingEmit) =="
  IO.println "  not residual free; not freestanding residual free"
  IO.println "  not PROVABLY; no product GC; not Lean managed runtime"
  IO.println "  never writes out/freestanding-c/ (release surface is separate)"

  let body <- loadBodySsot bodyPath
  let mult <- loadMultSsot multPath
  let linear <- loadLinearSsot linearPath
  requireFile tmplH "header template"
  requireFile tmplC "source template"
  let th <- IO.FS.readFile tmplH
  let tc <- IO.FS.readFile tmplC
  let header <- renderHeader th mult linear
  let source <- renderSource tc body mult linear
  IO.FS.createDirAll emitDir
  IO.FS.writeFile outH header
  IO.FS.writeFile outC source
  let headerWritten <- IO.FS.readFile outH
  let sourceWritten <- IO.FS.readFile outC
  validateProduct outH headerWritten false body
  validateProduct outC sourceWritten true body
  IO.println s!"GREEN {stageId}: wrote freestanding emit surface under {emitDir}/"
  IO.println s!"  wrote: {outH}"
  IO.println s!"  wrote: {outC}"
  IO.println "  not residual free; not PROVABLY; no product GC; not Lean managed runtime"
  IO.println "  release copy via just out-freestanding-c (not this stage)"

/-- Drop lake/exe separators so root path is first real arg. -/
def filterArgs : List String -> List String
  | [] => []
  | "--" :: rest => filterArgs rest
  | a :: rest => a :: filterArgs rest

/-- CLI: optional repo root argument (default cwd). -/
def main (args : List String) : IO UInt32 := do
  let root : System.FilePath :=
    match filterArgs args with
    | r :: _ => System.FilePath.mk r
    | [] => "."
  try
    emitAtRoot root
    pure 0
  catch e =>
    IO.eprintln s!"{e}"
    pure 1

end SystemsLean.FreestandingEmit

/-- Lake / lean --run entry: forward argv. -/
def main (args : List String) : IO UInt32 :=
  SystemsLean.FreestandingEmit.main args
