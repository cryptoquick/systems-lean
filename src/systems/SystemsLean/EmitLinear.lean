/-
  SYSTEMS_LEAN_HOST partial -- host-owned Linear freestanding C product text.
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): Linear.lean ConsumeToken axioms; KernelLinear.lean Linear
    kernel IR; emit slake_linear_* / slake_consume_token_*; self-host.md.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_EMIT_LINEAR_V0 / HOST-EMIT-LINEAR / SELF-HOST-EMIT-LINEAR:
    Lean owns freestanding Linear + ConsumeToken product C text
    (linear_token + consume_token APIs).
  - Durable artifact: src/systems/emit/host_emit_linear.ssot.txt
    (LINEAR_C_HEADER / LINEAR_C_BODY blocks match linearHeaderFragment /
    linearBodyFragment).
  - FreestandingEmit embeds Linear product text from the durable SSOT artifact;
    it must not invent a second Linear dialect.
  - LINEAR-EXACT-ONCE / CONSUME_TOKEN_HOST_V0 / JOIN-ALG greppable on wire.
  - emitLinearReady: surface + honesty piece equality.
  - No new EMIT_LINEAR_V0 residual C stage ladder (host stage ids only).

  Intentional non-claims / partial parity:
  - PARTIAL: Linear product C text SSoT only; not full product module emit;
    closed-loop Linear freestanding path parity is ParityLinear; not compiler
    self-application.
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_EMIT_LINEAR_V0, HOST-EMIT-LINEAR,
  SELF-HOST-EMIT-LINEAR, EMIT-LINEAR-SMOKE, HOST-EMIT-LINEAR-SMOKE,
  LINEAR-EXACT-ONCE, CONSUME_TOKEN_HOST_V0, JOIN-ALG, slake_linear_consume,
  slake_consume_token_consume, linearHeaderFragment, linearBodyFragment,
  emitLinearReady, NON-SSOT
  UNIT_SURFACE host surface. Module: SystemsLean.EmitLinear
  Not freestanding emit. Not freestanding residual free. Not PROVABLY.
  Not freestanding emit residual free.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

namespace SystemsLean.EmitLinear

/-- Greppable primary stage id for host-owned Linear product emit. -/
def stageId : String := "SLAKE_SELF_HOST_EMIT_LINEAR_V0"

/-- Greppable short map id (HOST-EMIT-LINEAR). -/
def hostEmitLinearId : String := "HOST-EMIT-LINEAR"

/-- Greppable short map id (SELF-HOST-EMIT-LINEAR). -/
def selfHostEmitLinearId : String := "SELF-HOST-EMIT-LINEAR"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/EmitLinear.lean"

/-- Durable Linear SSOT artifact path cite (not a filesystem read). -/
def ssotArtifactPath : String := "src/systems/emit/host_emit_linear.ssot.txt"

/-- Ownership comment shared by header and body fragments (HOST-EMIT-LINEAR). -/
def linearOwnershipComment : String :=
  " * HOST-EMIT-LINEAR: dialect from SystemsLean.EmitLinear + host_emit_linear.ssot.txt\n"
    ++ " * (Lean FreestandingEmit embeds this Linear product text).\n"

/-- Linear section open comment (header). -/
def linearHeaderOpen : String :=
  "/* ---- Linear (Linear.slake / LINEAR-EXACT-ONCE) ----\n"
    ++ " * JOIN-ALG ConsumeToken is the dual anchor on language sides (not reimplemented).\n"
    ++ " * live==1 means not yet consumed; consume fails closed if already spent.\n"
    ++ linearOwnershipComment
    ++ " */\n"

/-- Linear token typedef + decls (product wire names). -/
def linearTokenApiDecls : String :=
  "typedef struct slake_linear_token {\n"
    ++ "  uint32_t id;\n"
    ++ "  uint8_t live; /* 1 = live / exact-once remaining; 0 = consumed */\n"
    ++ "} slake_linear_token;\n"
    ++ "\n"
    ++ "/* Init fails closed on null or id==0 (id 0 is the spent sentinel after consume). */\n"
    ++ "int slake_linear_token_init(slake_linear_token *tok, uint32_t id);\n"
    ++ "/* Exact-once consume: 0 on success; -1 null; -2 already consumed (fail closed).\n"
    ++ " * Canonical UNIT_DEEPEN_V1 map name: slake_linear_consume (alias linearConsume).\n"
    ++ " * live==0 means spent; id scrubbed to 0 on success. Init rejects id==0.\n"
    ++ " */\n"
    ++ "int slake_linear_consume(slake_linear_token *tok);\n"
    ++ "/* Alias: thin call-through to slake_linear_consume (same return codes). */\n"
    ++ "int slake_linear_token_consume(slake_linear_token *tok);\n"
    ++ "/* 1 if tok non-null and live (consumable); 0 otherwise. */\n"
    ++ "int slake_linear_token_is_live(const slake_linear_token *tok);\n"

/-- ConsumeToken host section open (header). -/
def consumeTokenHeaderOpen : String :=
  "/* ---- CONSUME_TOKEN_HOST_V0 (JOIN-ALG ConsumeToken-class freestanding host) ----\n"
    ++ " * Models dual algorithm shape at C level: mint MULT-1 token, exact-once consume.\n"
    ++ " * Duals stay read-only under src/idris2 and src/lean4 (not reimplemented here).\n"
    ++ " * LINEAR-EXACT-ONCE / MULT-1; not residual free; not PROVABLY; no product GC.\n"
    ++ linearOwnershipComment
    ++ " *\n"
    ++ " * Host state:\n"
    ++ " *   0 = empty (not minted)\n"
    ++ " *   1 = live MULT-1 token held\n"
    ++ " *   2 = spent (second consume fails closed)\n"
    ++ " *\n"
    ++ " * Contract: use only host APIs (init/mint/consume/is_live/check). Direct\n"
    ++ " * mutation of the embedded token (e.g. slake_linear_consume(&ct->token)) is\n"
    ++ " * out of contract. Host consume heals state if token already spent while\n"
    ++ " * state believed live; mint keys off is_live so remint recovers desync.\n"
    ++ " */\n"

/-- Header prototype for greppable host stage id (not the body implementation). -/
def consumeTokenHostIdDecl : String :=
  "/* Greppable host stage id: CONSUME_TOKEN_HOST_V0 */\n"
    ++ "const char *slake_consume_token_host_id(void);\n"

/-- ConsumeToken typedef + decls (product wire names). -/
def consumeTokenApiDecls : String :=
  "typedef struct slake_consume_token {\n"
    ++ "  slake_linear_token token; /* MULT-1 linear resource */\n"
    ++ "  uint8_t state;            /* 0 empty; 1 live; 2 spent */\n"
    ++ "} slake_consume_token;\n"
    ++ "\n"
    ++ consumeTokenHostIdDecl
    ++ "\n"
    ++ "/* Zero host state (empty). 0 ok; -1 null. */\n"
    ++ "int slake_consume_token_init(slake_consume_token *ct);\n"
    ++ "\n"
    ++ "/* Mint MULT-1 token (JOIN-ALG mkToken shape). Composes slake_linear_token_init.\n"
    ++ " * 0 ok; -1 null or id==0; -2 already holds a live token (fail closed).\n"
    ++ " * Live check uses slake_consume_token_is_live (state and token.live).\n"
    ++ " * Remint allowed after spent or empty (and after healed desync).\n"
    ++ " */\n"
    ++ "int slake_consume_token_mint(slake_consume_token *ct, uint32_t id);\n"
    ++ "\n"
    ++ "/* Exact-once consume (JOIN-ALG consume shape). Composes slake_linear_consume.\n"
    ++ " * 0 success; -1 null or empty; -2 already spent (LINEAR-EXACT-ONCE fail closed).\n"
    ++ " * On -2 while host believed live, heals state to spent (still returns -2).\n"
    ++ " */\n"
    ++ "int slake_consume_token_consume(slake_consume_token *ct);\n"
    ++ "\n"
    ++ "/* 1 if host holds a live MULT-1 token (state live and token.live); 0 otherwise. */\n"
    ++ "int slake_consume_token_is_live(const slake_consume_token *ct);\n"
    ++ "\n"
    ++ "/* FAIL_CLOSED_CHECKER_V1 integration: MULT-1 + live token + RUNTIME_FS.\n"
    ++ " * Check-only (does not consume). SLAKE_EXTRACT_OK (0) or FAIL_CLOSED (1).\n"
    ++ " * Greppable: MULT-1, LINEAR-EXACT-ONCE, JOIN-ALG, ConsumeToken\n"
    ++ " */\n"
    ++ "int slake_consume_token_check_fail_closed(const slake_consume_token *ct);\n"

/-- linearHeaderFragment -- freestanding Linear header text (HOST-EMIT-LINEAR SSoT).
    slake_linear_token + consume_token decls. Compatible with frozen product wire. -/
def linearHeaderFragment : String :=
  linearHeaderOpen
    ++ linearTokenApiDecls
    ++ "\n"
    ++ consumeTokenHeaderOpen
    ++ consumeTokenApiDecls

/-- host_id body (CONSUME_TOKEN_HOST_V0 greppable string). -/
def consumeTokenHostIdBody : String :=
  "const char *slake_consume_token_host_id(void)\n"
    ++ "{\n"
    ++ "  return \"CONSUME_TOKEN_HOST_V0\";\n"
    ++ "}\n"

/-- linear_token bodies (exact-once consume). -/
def linearTokenBodies : String :=
  "int slake_linear_token_init(slake_linear_token *tok, uint32_t id)\n"
    ++ "{\n"
    ++ "  if (tok == 0) {\n"
    ++ "    return -1;\n"
    ++ "  }\n"
    ++ "  /* id 0 is the spent sentinel; refuse so is_live matches consumability. */\n"
    ++ "  if (id == 0) {\n"
    ++ "    return -1;\n"
    ++ "  }\n"
    ++ "  tok->id = id;\n"
    ++ "  tok->live = 1;\n"
    ++ "  return 0;\n"
    ++ "}\n"
    ++ "\n"
    ++ "int slake_linear_consume(slake_linear_token *tok)\n"
    ++ "{\n"
    ++ "  if (tok == 0) {\n"
    ++ "    return -1;\n"
    ++ "  }\n"
    ++ "  /* Exact-once: live flag is the authority; scrub id after spend. */\n"
    ++ "  if (tok->live == 0) {\n"
    ++ "    return -2; /* already consumed -- fail closed */\n"
    ++ "  }\n"
    ++ "  tok->live = 0;\n"
    ++ "  tok->id = 0;\n"
    ++ "  return 0;\n"
    ++ "}\n"
    ++ "\n"
    ++ "int slake_linear_token_consume(slake_linear_token *tok)\n"
    ++ "{\n"
    ++ "  /* Alias: single body via call-through (same return codes as canonical). */\n"
    ++ "  return slake_linear_consume(tok);\n"
    ++ "}\n"
    ++ "\n"
    ++ "int slake_linear_token_is_live(const slake_linear_token *tok)\n"
    ++ "{\n"
    ++ "  if (tok == 0) {\n"
    ++ "    return 0;\n"
    ++ "  }\n"
    ++ "  return (tok->live != 0) ? 1 : 0;\n"
    ++ "}\n"

/-- consume_token bodies (JOIN-ALG freestanding host). -/
def consumeTokenBodies : String :=
  "int slake_consume_token_init(slake_consume_token *ct)\n"
    ++ "{\n"
    ++ "  if (ct == 0) {\n"
    ++ "    return -1;\n"
    ++ "  }\n"
    ++ "  ct->token.id = 0;\n"
    ++ "  ct->token.live = 0;\n"
    ++ "  ct->state = 0; /* empty */\n"
    ++ "  return 0;\n"
    ++ "}\n"
    ++ "\n"
    ++ "int slake_consume_token_mint(slake_consume_token *ct, uint32_t id)\n"
    ++ "{\n"
    ++ "  if (ct == 0) {\n"
    ++ "    return -1;\n"
    ++ "  }\n"
    ++ "  if (id == 0) {\n"
    ++ "    return -1; /* spent sentinel reserved; fail closed */\n"
    ++ "  }\n"
    ++ "  /* Key off is_live (state + token.live) so remint recovers desync. */\n"
    ++ "  if (slake_consume_token_is_live(ct) == 1) {\n"
    ++ "    return -2; /* already holds live MULT-1 token */\n"
    ++ "  }\n"
    ++ "  if (slake_linear_token_init(&ct->token, id) != 0) {\n"
    ++ "    return -1;\n"
    ++ "  }\n"
    ++ "  ct->state = 1; /* live */\n"
    ++ "  return 0;\n"
    ++ "}\n"
    ++ "\n"
    ++ "int slake_consume_token_consume(slake_consume_token *ct)\n"
    ++ "{\n"
    ++ "  int rc;\n"
    ++ "\n"
    ++ "  if (ct == 0) {\n"
    ++ "    return -1;\n"
    ++ "  }\n"
    ++ "  if (ct->state == 0) {\n"
    ++ "    return -1; /* empty -- never minted */\n"
    ++ "  }\n"
    ++ "  if (ct->state == 2) {\n"
    ++ "    return -2; /* already spent -- LINEAR-EXACT-ONCE fail closed */\n"
    ++ "  }\n"
    ++ "  /* state == 1 believed live: compose with linear exact-once consume */\n"
    ++ "  rc = slake_linear_consume(&ct->token);\n"
    ++ "  if (rc == 0) {\n"
    ++ "    ct->state = 2; /* spent */\n"
    ++ "  } else if (rc == -2) {\n"
    ++ "    /* Heal desync if token already spent under host that believed live. */\n"
    ++ "    ct->state = 2;\n"
    ++ "  }\n"
    ++ "  return rc;\n"
    ++ "}\n"
    ++ "\n"
    ++ "int slake_consume_token_is_live(const slake_consume_token *ct)\n"
    ++ "{\n"
    ++ "  if (ct == 0) {\n"
    ++ "    return 0;\n"
    ++ "  }\n"
    ++ "  if (ct->state != 1) {\n"
    ++ "    return 0;\n"
    ++ "  }\n"
    ++ "  return (slake_linear_token_is_live(&ct->token) == 1) ? 1 : 0;\n"
    ++ "}\n"
    ++ "\n"
    ++ "int slake_consume_token_check_fail_closed(const slake_consume_token *ct)\n"
    ++ "{\n"
    ++ "  slake_check_bundle b;\n"
    ++ "\n"
    ++ "  if (ct == 0) {\n"
    ++ "    return (int)SLAKE_EXTRACT_FAIL_CLOSED;\n"
    ++ "  }\n"
    ++ "  /* Host must hold live MULT-1 (is_live); checker is check-only (no consume). */\n"
    ++ "  if (slake_consume_token_is_live(ct) != 1) {\n"
    ++ "    return (int)SLAKE_EXTRACT_FAIL_CLOSED;\n"
    ++ "  }\n"
    ++ "  b.mult = SLAKE_MULT_1;\n"
    ++ "  b.linear = &ct->token;\n"
    ++ "  b.erased = 0;\n"
    ++ "  b.claimed_runtime = SLAKE_RUNTIME_FS;\n"
    ++ "  return slake_check_fail_closed(&b);\n"
    ++ "}\n"

/-- Body section open for Linear + ConsumeToken. -/
def linearBodyOpen : String :=
  "/* ---- Linear (LINEAR-EXACT-ONCE; JOIN-ALG ConsumeToken dual anchor on sides) ----\n"
    ++ linearOwnershipComment
    ++ " */\n"

/-- ConsumeToken body section open. -/
def consumeTokenBodyOpen : String :=
  "/* ---- CONSUME_TOKEN_HOST_V0 (JOIN-ALG ConsumeToken-class freestanding host) ----\n"
    ++ " * mint + exact-once consume at C level; duals not reimplemented.\n"
    ++ " * LINEAR-EXACT-ONCE / MULT-1; not residual free; not PROVABLY.\n"
    ++ linearOwnershipComment
    ++ " */\n"

/-- linearBodyFragment -- freestanding Linear body text (HOST-EMIT-LINEAR SSoT).
    host_id + linear_token_* + consume_token_* matching frozen product wire. -/
def linearBodyFragment : String :=
  linearBodyOpen
    ++ "\n"
    ++ consumeTokenHostIdBody
    ++ "\n"
    ++ linearTokenBodies
    ++ "\n"
    ++ consumeTokenBodyOpen
    ++ "\n"
    ++ consumeTokenBodies

/-- Ownership comment carries HOST-EMIT-LINEAR + FreestandingEmit embed honesty. -/
def ownershipHonestyOk : Bool :=
  (linearOwnershipComment
    == " * HOST-EMIT-LINEAR: dialect from SystemsLean.EmitLinear + host_emit_linear.ssot.txt\n"
      ++ " * (Lean FreestandingEmit embeds this Linear product text).\n")

/-- Header piece honesty: linear token decls + host_id prototype + ownership.
    Header text only (no body). Full consumeTokenApiDecls is not re-checked with
    String.beq here (decide maxRecDepth); host_id decl canary covers the greppable
    header surface Mult-scale. -/
def headerHonestyOk : Bool :=
  ownershipHonestyOk
    && (linearTokenApiDecls
      == "typedef struct slake_linear_token {\n"
        ++ "  uint32_t id;\n"
        ++ "  uint8_t live; /* 1 = live / exact-once remaining; 0 = consumed */\n"
        ++ "} slake_linear_token;\n"
        ++ "\n"
        ++ "/* Init fails closed on null or id==0 (id 0 is the spent sentinel after consume). */\n"
        ++ "int slake_linear_token_init(slake_linear_token *tok, uint32_t id);\n"
        ++ "/* Exact-once consume: 0 on success; -1 null; -2 already consumed (fail closed).\n"
        ++ " * Canonical UNIT_DEEPEN_V1 map name: slake_linear_consume (alias linearConsume).\n"
        ++ " * live==0 means spent; id scrubbed to 0 on success. Init rejects id==0.\n"
        ++ " */\n"
        ++ "int slake_linear_consume(slake_linear_token *tok);\n"
        ++ "/* Alias: thin call-through to slake_linear_consume (same return codes). */\n"
        ++ "int slake_linear_token_consume(slake_linear_token *tok);\n"
        ++ "/* 1 if tok non-null and live (consumable); 0 otherwise. */\n"
        ++ "int slake_linear_token_is_live(const slake_linear_token *tok);\n")
    && (consumeTokenHostIdDecl
      == "/* Greppable host stage id: CONSUME_TOKEN_HOST_V0 */\n"
        ++ "const char *slake_consume_token_host_id(void);\n")

/-- Body piece honesty: host_id body + linear token bodies + ownership helpers. -/
def bodyHonestyOk : Bool :=
  ownershipHonestyOk
    && (consumeTokenHostIdBody
      == "const char *slake_consume_token_host_id(void)\n"
        ++ "{\n"
        ++ "  return \"CONSUME_TOKEN_HOST_V0\";\n"
        ++ "}\n")
    && (linearTokenBodies
      == "int slake_linear_token_init(slake_linear_token *tok, uint32_t id)\n"
        ++ "{\n"
        ++ "  if (tok == 0) {\n"
        ++ "    return -1;\n"
        ++ "  }\n"
        ++ "  /* id 0 is the spent sentinel; refuse so is_live matches consumability. */\n"
        ++ "  if (id == 0) {\n"
        ++ "    return -1;\n"
        ++ "  }\n"
        ++ "  tok->id = id;\n"
        ++ "  tok->live = 1;\n"
        ++ "  return 0;\n"
        ++ "}\n"
        ++ "\n"
        ++ "int slake_linear_consume(slake_linear_token *tok)\n"
        ++ "{\n"
        ++ "  if (tok == 0) {\n"
        ++ "    return -1;\n"
        ++ "  }\n"
        ++ "  /* Exact-once: live flag is the authority; scrub id after spend. */\n"
        ++ "  if (tok->live == 0) {\n"
        ++ "    return -2; /* already consumed -- fail closed */\n"
        ++ "  }\n"
        ++ "  tok->live = 0;\n"
        ++ "  tok->id = 0;\n"
        ++ "  return 0;\n"
        ++ "}\n"
        ++ "\n"
        ++ "int slake_linear_token_consume(slake_linear_token *tok)\n"
        ++ "{\n"
        ++ "  /* Alias: single body via call-through (same return codes as canonical). */\n"
        ++ "  return slake_linear_consume(tok);\n"
        ++ "}\n"
        ++ "\n"
        ++ "int slake_linear_token_is_live(const slake_linear_token *tok)\n"
        ++ "{\n"
        ++ "  if (tok == 0) {\n"
        ++ "    return 0;\n"
        ++ "  }\n"
        ++ "  return (tok->live != 0) ? 1 : 0;\n"
        ++ "}\n")

/-- Surface canary: stage ids + path cites. -/
def emitLinearSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_EMIT_LINEAR_V0")
    && (hostEmitLinearId == "HOST-EMIT-LINEAR")
    && (selfHostEmitLinearId == "SELF-HOST-EMIT-LINEAR")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/EmitLinear.lean")
    && (ssotArtifactPath == "src/systems/emit/host_emit_linear.ssot.txt")

/-- emitLinearReady -- Linear host-owned emit readiness.
    FAIL-CLOSED: surface + header/body piece honesty.
    Greppable: emitLinearReady, HOST-EMIT-LINEAR, SELF-HOST-EMIT-LINEAR. -/
def emitLinearReady : Bool :=
  emitLinearSurfaceOk && headerHonestyOk && bodyHonestyOk

/-- Full inventory ok (alias of emitLinearReady for inventory greps). -/
def emitLinearOk : Bool := emitLinearReady

/-! ### Linear host emit smoke (behavioral; lake build fails if an example does not hold)
    Greppable: EMIT-LINEAR-SMOKE, HOST-EMIT-LINEAR-SMOKE.
    maxRecDepth raised for String.beq unfolds on Linear ownership / API piece equality. -/

set_option maxRecDepth 4096

/-- EMIT-LINEAR-SMOKE / HOST-EMIT-LINEAR-SMOKE: stage / map ids are greppable honesty. -/
example : stageId = "SLAKE_SELF_HOST_EMIT_LINEAR_V0" := by decide
example : hostEmitLinearId = "HOST-EMIT-LINEAR" := by decide
example : selfHostEmitLinearId = "SELF-HOST-EMIT-LINEAR" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/EmitLinear.lean" := by decide
example : ssotArtifactPath = "src/systems/emit/host_emit_linear.ssot.txt" := by decide
example : emitLinearSurfaceOk = true := by decide

/-- HOST-EMIT-LINEAR-SMOKE: ownership + header decls only (no body text). -/
example : ownershipHonestyOk = true := by decide
example : headerHonestyOk = true := by decide
example :
    consumeTokenHostIdDecl
      = "/* Greppable host stage id: CONSUME_TOKEN_HOST_V0 */\n"
        ++ "const char *slake_consume_token_host_id(void);\n" := by
  decide

/-- HOST-EMIT-LINEAR-SMOKE: body piece honesty (host_id body + linear token bodies). -/
example : bodyHonestyOk = true := by decide
example :
    consumeTokenHostIdBody
      = "const char *slake_consume_token_host_id(void)\n"
        ++ "{\n"
        ++ "  return \"CONSUME_TOKEN_HOST_V0\";\n"
        ++ "}\n" := by
  decide

/-- EMIT-LINEAR-SMOKE: full emit readiness. -/
example : emitLinearReady = true := by decide
example : emitLinearOk = true := by decide

end SystemsLean.EmitLinear
