/* SPDX-License-Identifier: Unlicense */
/* SLAKE_EMIT_FREESTANDING_C_V0 -- freestanding C header API.
 * UNIT_TRANSLATION_V0 -- first real unit translation of UNIT_SURFACE modules.
 * UNIT_DEEPEN_V1 -- deepened mult/linear/erasure/extract contract map.
 * FAIL_CLOSED_CHECKER_V1 -- composed fail-closed checker + extract path.
 * CONSUME_TOKEN_HOST_V0 -- freestanding JOIN-ALG ConsumeToken-class host shape.
 * TYPED_IR_V0 -- richer typed IR surface behind checker/host.
 * IR_PROGRAM_V0 -- multi-node ordered IR program (ordered list; not CFG).
 * IR_GRAPH_EDGES_V0 -- graph edges over ordered IR program (node index endpoints).
 * HOST_COMPOSE_V0 -- freestanding host + IR graph composition (not residual free).
 * EMIT_PLAN_V0 -- emit plan from host compose (not residual free; not CFG/SSA).
 * EMIT_APPLY_V0 -- apply plan tags into fixed buffer (not residual free; not full C body).
 * EMIT_BODY_V0 -- freestanding C body fragment (not residual free; not CFG/SSA).
 * HOST-EMIT-SSOT -- fragment dialect from SystemsLean.EmitBody + host_emit_body_fragment.ssot.txt
 * (generator bash is NON-SSOT for EMIT_BODY fragment text).
 * HOST-EMIT-MULT -- Mult product text from SystemsLean.EmitMult + host_emit_mult.ssot.txt
 * (generator bash is NON-SSOT for Mult product text).
 *
 * RUNTIME-FS product surface goal: no Lean managed runtime on the wire.
 * not residual free; not freestanding residual free product claim.
 * not PROVABLY; no product GC; not Lean managed runtime.
 * V0 unit translation only -- not residual free product claim.
 *
 * Unit map (UNIT_SURFACE -> C surface):
 *   Mult.slake    -> enum slake_mult + slake_mult_is_valid (FAIL-CLOSED-UNKNOWN-GRADE; HOST-EMIT-MULT)
 *   Linear.slake  -> slake_linear_token + slake_linear_consume (LINEAR-EXACT-ONCE)
 *                   + slake_consume_token host (CONSUME_TOKEN_HOST_V0 / JOIN-ALG)
 *                   + host_compose mint path (HOST_COMPOSE_V0)
 *   Erasure.slake -> slake_erased + slake_erasure_is_runtime_absent (ERASE-RULE-MULT-0)
 *   Extract.slake -> slake_extract_status + runtime class (EMIT-BOUNDARY / RUNTIME-FS)
 *                   + slake_check_fail_closed / slake_extract_with_checks
 *                   + slake_host_compose extract (HOST_COMPOSE_V0)
 *                   + slake_emit_plan from compose (EMIT_PLAN_V0)
 *                   + slake_emit_apply from compose (EMIT_APPLY_V0)
 *                   + slake_emit_body from compose (EMIT_BODY_V0; HOST-EMIT-SSOT dialect)
 *   Types.slake   -> slake_type_tag (COMMON-UNIVERSE tag only)
 *                   + slake_ir_node typed IR (TYPED_IR_V0; not full elaborator)
 *                   + slake_ir_program multi-node ordered program (IR_PROGRAM_V0)
 *                   + slake_ir_graph edges over program nodes (IR_GRAPH_EDGES_V0)
 *
 * Multiplicity grades (min freestanding set; greppable):
 *   MULT-0    -- erased / compile-time only (no runtime residual when erased)
 *   MULT-1    -- linear / exact-once resource (JOIN-ALG ConsumeToken host V0)
 *   MULT-OMEGA -- unrestricted runtime value
 * No multiplicity zoo beyond these three.
 *
 * Smoke: prefer freestanding-friendly compile. Headers use stdint.h only.
 * Honest smoke flags (compiler freestanding stdint is available on gcc/clang):
 *   cc -c -std=c11 -ffreestanding -nostdlib -I. slake_freestanding.c
 * If a target lacks freestanding stdint, fall back to:
 *   cc -c -std=c11 -I. slake_freestanding.c
 * (still no Lean headers; still no product GC.)
 */
#ifndef SLAKE_FREESTANDING_H
#define SLAKE_FREESTANDING_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Emit stage version symbol (greppable product surface). */
const char *slake_emit_version(void);

/* Unit translation id string (greppable UNIT_TRANSLATION_V0). */
const char *slake_unit_translation_id(void);

/* ---- Types (Types.slake / COMMON-UNIVERSE) ----
 * Host elaborator residual is not product wire residual.
 * Opaque tag only; no type checker body.
 */
typedef struct slake_type_tag {
  uint32_t tag;
} slake_type_tag;

int slake_type_tag_init(slake_type_tag *t, uint32_t tag);
uint32_t slake_type_tag_get(const slake_type_tag *t);

/* ---- Mult (Mult.slake) ----
 * MULT-0 / MULT-1 / MULT-OMEGA only. FAIL-CLOSED-UNKNOWN-GRADE.
 * HOST-EMIT-MULT: dialect from SystemsLean.EmitMult + host_emit_mult.ssot.txt
 * (generator bash is NON-SSOT for Mult product text).
 */
enum slake_mult {
  SLAKE_MULT_0 = 0,     /* MULT-0 */
  SLAKE_MULT_1 = 1,     /* MULT-1 */
  SLAKE_MULT_OMEGA = 2  /* MULT-OMEGA */
};

/* 1 if m is one of MULT-0 / MULT-1 / MULT-OMEGA; 0 otherwise (fail closed).
 * Canonical UNIT_DEEPEN_V1 map name: slake_mult_is_valid (alias multIsValid).
 */
int slake_mult_is_valid(enum slake_mult m);
/* Alias of slake_mult_is_valid (UNIT_TRANSLATION_V0 name). */
int slake_mult_is_known(enum slake_mult m);

/* Greppable grade name: "MULT-0" | "MULT-1" | "MULT-OMEGA" | 0 if unknown. */
const char *slake_mult_name(enum slake_mult m);

/* ---- Linear (Linear.slake / LINEAR-EXACT-ONCE) ----
 * JOIN-ALG ConsumeToken is the dual anchor on language sides (not reimplemented).
 * live==1 means not yet consumed; consume fails closed if already spent.
 */
typedef struct slake_linear_token {
  uint32_t id;
  uint8_t live; /* 1 = live / exact-once remaining; 0 = consumed */
} slake_linear_token;

/* Init fails closed on null or id==0 (id 0 is the spent sentinel after consume). */
int slake_linear_token_init(slake_linear_token *tok, uint32_t id);
/* Exact-once consume: 0 on success; -1 null; -2 already consumed (fail closed).
 * Canonical UNIT_DEEPEN_V1 map name: slake_linear_consume (alias linearConsume).
 * live==0 means spent; id scrubbed to 0 on success. Init rejects id==0.
 */
int slake_linear_consume(slake_linear_token *tok);
/* Alias: thin call-through to slake_linear_consume (same return codes). */
int slake_linear_token_consume(slake_linear_token *tok);
/* 1 if tok non-null and live (consumable); 0 otherwise. */
int slake_linear_token_is_live(const slake_linear_token *tok);

/* ---- CONSUME_TOKEN_HOST_V0 (JOIN-ALG ConsumeToken-class freestanding host) ----
 * Models dual algorithm shape at C level: mint MULT-1 token, exact-once consume.
 * Duals stay read-only under src/idris2 and src/lean4 (not reimplemented here).
 * LINEAR-EXACT-ONCE / MULT-1; not residual free; not PROVABLY; no product GC.
 *
 * Host state:
 *   0 = empty (not minted)
 *   1 = live MULT-1 token held
 *   2 = spent (second consume fails closed)
 *
 * Contract: use only host APIs (init/mint/consume/is_live/check). Direct
 * mutation of the embedded token (e.g. slake_linear_consume(&ct->token)) is
 * out of contract. Host consume heals state if token already spent while
 * state believed live; mint keys off is_live so remint recovers desync.
 */
typedef struct slake_consume_token {
  slake_linear_token token; /* MULT-1 linear resource */
  uint8_t state;            /* 0 empty; 1 live; 2 spent */
} slake_consume_token;

/* Greppable host stage id: CONSUME_TOKEN_HOST_V0 */
const char *slake_consume_token_host_id(void);

/* Zero host state (empty). 0 ok; -1 null. */
int slake_consume_token_init(slake_consume_token *ct);

/* Mint MULT-1 token (JOIN-ALG mkToken shape). Composes slake_linear_token_init.
 * 0 ok; -1 null or id==0; -2 already holds a live token (fail closed).
 * Live check uses slake_consume_token_is_live (state and token.live).
 * Remint allowed after spent or empty (and after healed desync).
 */
int slake_consume_token_mint(slake_consume_token *ct, uint32_t id);

/* Exact-once consume (JOIN-ALG consume shape). Composes slake_linear_consume.
 * 0 success; -1 null or empty; -2 already spent (LINEAR-EXACT-ONCE fail closed).
 * On -2 while host believed live, heals state to spent (still returns -2).
 */
int slake_consume_token_consume(slake_consume_token *ct);

/* 1 if host holds a live MULT-1 token (state live and token.live); 0 otherwise. */
int slake_consume_token_is_live(const slake_consume_token *ct);

/* FAIL_CLOSED_CHECKER_V1 integration: MULT-1 + live token + RUNTIME_FS.
 * Check-only (does not consume). SLAKE_EXTRACT_OK (0) or FAIL_CLOSED (1).
 * Greppable: MULT-1, LINEAR-EXACT-ONCE, JOIN-ALG, ConsumeToken
 */
int slake_consume_token_check_fail_closed(const slake_consume_token *ct);

/* ---- Erasure (Erasure.slake / ERASE-RULE-MULT-0 / ERASE-NO-RUNTIME) ----
 * Zero-payload marker for MULT-0; EDGE-PROP / ERASE-PROP imperfect on sides.
 */
typedef struct slake_erased {
  uint8_t marked; /* 1 after mark; no product payload */
} slake_erased;

int slake_erased_mark(slake_erased *e);
int slake_erased_is_marked(const slake_erased *e);
/* 1 if non-null and marked (erased MULT-0 runtime-absent); 0 for null or unmarked.
 * Canonical UNIT_DEEPEN_V1 map name: slake_erasure_is_runtime_absent.
 * Fail closed: unmarked handles do not claim runtime absence.
 */
int slake_erasure_is_runtime_absent(const slake_erased *e);

/* ---- Extract (Extract.slake / EMIT-BOUNDARY / RUNTIME-FS) ----
 * EDGE-RUNTIME / RUNTIME-CLASSIC mark stock-host managed residual (not this wire).
 */
enum slake_extract_status {
  SLAKE_EXTRACT_OK = 0,
  SLAKE_EXTRACT_FAIL_CLOSED = 1
};

/* Runtime class tags for honesty (not a full runtime switch). */
enum slake_runtime_class {
  SLAKE_RUNTIME_FS = 0,       /* RUNTIME-FS freestanding product goal */
  SLAKE_RUNTIME_CLASSIC = 1   /* RUNTIME-CLASSIC / EDGE-RUNTIME stock host (not product) */
};

int slake_extract_status_ok(void);
/* Product wire claims RUNTIME-FS only. */
enum slake_runtime_class slake_extract_product_runtime(void);

/* FAIL_CLOSED_CHECKER_V1 -- composed checks before product extract.
 * Still not residual free; not PROVABLY; no product GC.
 */
typedef struct slake_check_bundle {
  enum slake_mult mult;
  const slake_linear_token *linear; /* required live when mult == MULT-1; else may be null */
  const slake_erased *erased;       /* required marked when mult == MULT-0; else may be null */
  enum slake_runtime_class claimed_runtime; /* must be SLAKE_RUNTIME_FS for product */
} slake_check_bundle;

/* Fail-closed checker: SLAKE_EXTRACT_OK (0) or SLAKE_EXTRACT_FAIL_CLOSED (1).
 * Rules:
 *  - mult must pass slake_mult_is_valid
 *  - MULT-1: linear non-null AND live (check-only; do not consume here)
 *  - MULT-0: erased non-null AND slake_erasure_is_runtime_absent == 1
 *  - MULT-OMEGA: linear/erased may be null (unrestricted)
 *  - claimed_runtime must be SLAKE_RUNTIME_FS (fail closed on CLASSIC / EDGE-RUNTIME product claim)
 *  - null bundle -> FAIL_CLOSED
 * Document return codes exactly matching body.
 * Greppable: FAIL_CLOSED_CHECKER_V1, EMIT-BOUNDARY, RUNTIME-FS
 */
int slake_check_fail_closed(const slake_check_bundle *b);

/* Extract path: run checker; on OK write *out_rt = SLAKE_RUNTIME_FS and return OK;
 * on fail leave *out_rt untouched.
 * null out_rt on success path is FAIL_CLOSED.
 * Greppable: FAIL_CLOSED_CHECKER_V1, EMIT-BOUNDARY, RUNTIME-FS
 */
int slake_extract_with_checks(const slake_check_bundle *b, enum slake_runtime_class *out_rt);

/* ---- TYPED_IR_V0 -- richer typed IR surface behind checker/host.
 * COMMON-UNIVERSE; not residual free; not full elaborator.
 * Kind must match mult:
 *   VALUE  <-> MULT-OMEGA
 *   LINEAR <-> MULT-1
 *   ERASED <-> MULT-0
 */
enum slake_ir_kind {
  SLAKE_IR_KIND_VALUE = 0,   /* pairs with MULT-OMEGA */
  SLAKE_IR_KIND_LINEAR = 1,  /* pairs with MULT-1 */
  SLAKE_IR_KIND_ERASED = 2   /* pairs with MULT-0 */
};

typedef struct slake_ir_node {
  slake_type_tag ty;
  enum slake_mult mult;
  enum slake_ir_kind kind;
  uint8_t valid; /* 1 after successful init */
} slake_ir_node;

/* Greppable typed IR stage id: TYPED_IR_V0 */
const char *slake_typed_ir_id(void);

/* 0 ok; -1 null or invalid mult/kind pairing or type init fail.
 * Kind must match mult (VALUE/OMEGA, LINEAR/1, ERASED/0).
 * On failure leave node invalid (valid=0) if non-null.
 * Document codes matching body exactly.
 */
int slake_ir_node_init(slake_ir_node *n, uint32_t type_tag,
                       enum slake_mult mult, enum slake_ir_kind kind);

/* 1 if non-null, valid flag set, mult valid, kind matches mult; else 0 */
int slake_ir_node_is_well_typed(const slake_ir_node *n);

/* Compose FAIL_CLOSED_CHECKER_V1 from IR node.
 * MULT-1 requires non-null live linear; MULT-0 requires marked erased;
 * MULT-OMEGA linear/erased may be null; claimed_runtime always RUNTIME_FS.
 * Returns SLAKE_EXTRACT_OK (0) or FAIL_CLOSED (1). Header must match body.
 * Greppable: TYPED_IR_V0, FAIL_CLOSED_CHECKER_V1, RUNTIME-FS
 */
int slake_ir_node_check_fail_closed(const slake_ir_node *n,
    const slake_linear_token *linear,
    const slake_erased *erased);

/* ---- IR_PROGRAM_V0 -- multi-node ordered IR program (ordered nodes).
 * Fixed-capacity ordered list of well-typed slake_ir_node; not CFG/edges yet.
 * not residual free; not PROVABLY; no product GC.
 * Honesty: MULT-1 / MULT-0 nodes share one linear / erased handle for V0 checks
 * (checker does not consume; not a full linear resource graph).
 * Greppable: IR_PROGRAM_V0, SLAKE_IR_PROGRAM_CAP, FAIL_CLOSED_CHECKER_V1
 */
#define SLAKE_IR_PROGRAM_CAP 8

typedef struct slake_ir_program {
  slake_ir_node nodes[SLAKE_IR_PROGRAM_CAP];
  uint8_t count; /* number of live slots 0..CAP */
  uint8_t valid; /* 1 after successful init */
} slake_ir_program;

/* Greppable ordered IR program stage id: IR_PROGRAM_V0 */
const char *slake_ir_program_id(void);

/* Init empty program. 0 ok; -1 null.
 * Dead slots: valid=0 with OMEGA+VALUE pairing (consistent if misread).
 */
int slake_ir_program_init(slake_ir_program *p);

/* Append a well-typed node (copies fields after node init).
 * 0 ok; -1 null/bad; -2 full (count==CAP).
 * On failure leave program count unchanged if possible.
 * Document codes matching body exactly.
 */
int slake_ir_program_push(slake_ir_program *p, uint32_t type_tag,
                          enum slake_mult mult, enum slake_ir_kind kind);

/* 1 if non-null, valid, count>=1, every live node well-typed; else 0.
 * Empty program (count==0) is NOT well-typed as a program (fail closed).
 */
int slake_ir_program_is_well_typed(const slake_ir_program *p);

/* Fail-closed check over all live nodes. For MULT-1 nodes require non-null live
 * linear token (shared host token for V0 is OK -- not consumed by check).
 * MULT-0 nodes need marked erased when checked.
 * claimed_runtime always RUNTIME_FS.
 * Empty / ill-typed program -> FAIL_CLOSED.
 * Returns SLAKE_EXTRACT_OK (0) or FAIL_CLOSED (1). Header must match body.
 * Greppable: IR_PROGRAM_V0, FAIL_CLOSED_CHECKER_V1, RUNTIME-FS
 */
int slake_ir_program_check_fail_closed(const slake_ir_program *p,
    const slake_linear_token *linear,
    const slake_erased *erased);

/* ---- IR_GRAPH_EDGES_V0 -- edges over ordered IR program (not residual free).
 * Fixed-capacity edge list; endpoints are node indices into prog.nodes.
 * Thin call-through to slake_ir_program_* for nodes and fail-closed.
 * Empty valid graph (no nodes, no edges) is well-typed + check OK (graph surface).
 * Nested empty program alone remains fail-closed under IR_PROGRAM_V0.
 * not residual free; not PROVABLY; no product GC.
 * Greppable: IR_GRAPH_EDGES_V0, SLAKE_IR_EDGE_MAX, FAIL_CLOSED_CHECKER_V1
 */
#define SLAKE_IR_EDGE_MAX 16

typedef struct slake_ir_edge {
  uint8_t from;  /* node index into program.nodes */
  uint8_t to;
  uint8_t valid; /* 1 after successful add */
} slake_ir_edge;

typedef struct slake_ir_graph {
  slake_ir_program prog;
  slake_ir_edge edges[SLAKE_IR_EDGE_MAX];
  uint8_t edge_count;
  uint8_t valid;
} slake_ir_graph;

/* Greppable IR graph edges stage id: IR_GRAPH_EDGES_V0 */
const char *slake_ir_graph_id(void);

/* 0 ok; -1 null. Inits nested program via slake_ir_program_init;
 * edge_count=0; valid=1. Dead edges: valid=0.
 */
int slake_ir_graph_init(slake_ir_graph *g);

/* Thin call-through: push node onto g->prog.
 * Same return codes as slake_ir_program_push (0 ok; -1 null/bad; -2 full).
 */
int slake_ir_graph_push_node(slake_ir_graph *g, uint32_t type_tag,
                             enum slake_mult mult, enum slake_ir_kind kind);

/* 0 ok; -1 null/invalid graph, full edges, or endpoints out of range
 * (from/to must be < prog.count). On failure leave edge_count unchanged.
 * On success write edge at edges[edge_count] and increment edge_count.
 * Header return codes must match body.
 */
int slake_ir_graph_add_edge(slake_ir_graph *g, uint8_t from, uint8_t to);

/* 1 if graph non-null, valid, edges sound, and either empty graph
 * (prog.count==0 and edge_count==0) or nested program well-typed with
 * every live edge valid and from/to < prog.count; empty edges OK; else 0.
 */
int slake_ir_graph_is_well_typed(const slake_ir_graph *g);

/* Requires well-typed graph. Empty graph -> SLAKE_EXTRACT_OK.
 * Non-empty: call-through slake_ir_program_check_fail_closed(&g->prog, ...).
 * Ill-typed / null -> SLAKE_EXTRACT_FAIL_CLOSED.
 * Returns SLAKE_EXTRACT_OK (0) or FAIL_CLOSED (1). Header must match body.
 * Greppable: IR_GRAPH_EDGES_V0, FAIL_CLOSED_CHECKER_V1, RUNTIME-FS
 */
int slake_ir_graph_check_fail_closed(const slake_ir_graph *g,
    const slake_linear_token *linear,
    const slake_erased *erased);

/* ---- HOST_COMPOSE_V0 -- freestanding host + IR graph composition (not residual free).
 * Owns IR graph + ConsumeToken host + erasure mark.
 * Mutators (mint/push/add_edge/consume/mark_erased) are thin call-throughs;
 * check_fail_closed is intentional mult pre-scan then graph check (not pure
 * call-through). not residual free; not PROVABLY; no product GC; not full CFG/SSA.
 * Greppable: HOST_COMPOSE_V0, CONSUME_TOKEN_HOST_V0, IR_GRAPH_EDGES_V0,
 * FAIL_CLOSED_CHECKER_V1, EMIT-BOUNDARY, RUNTIME-FS
 */
typedef struct slake_host_compose {
  slake_ir_graph graph;
  slake_consume_token host;
  slake_erased erased;
  uint8_t valid; /* 1 after successful init */
} slake_host_compose;

/* Greppable host compose stage id: exact "HOST_COMPOSE_V0" */
const char *slake_host_compose_id(void);

/* 0 ok; -1 null.
 * Inits graph via slake_ir_graph_init; host via slake_consume_token_init;
 * erased.marked=0; valid=1.
 */
int slake_host_compose_init(slake_host_compose *hc);

/* Thin call-through to slake_ir_graph_push_node after valid guard.
 * 0 ok; -1 null/invalid compose or graph push fail (null/bad mult/kind);
 * -2 full (from slake_ir_program_push via graph). Header matches body.
 */
int slake_host_compose_push_node(slake_host_compose *hc, uint32_t type_tag,
    enum slake_mult mult, enum slake_ir_kind kind);

/* Thin call-through to slake_ir_graph_add_edge after valid guard.
 * 0 ok; -1 null/invalid compose, full edges, or endpoints out of range.
 * (graph add_edge does not use -2). Header matches body.
 */
int slake_host_compose_add_edge(slake_host_compose *hc, uint8_t from, uint8_t to);

/* Thin call-through to slake_consume_token_mint after valid guard.
 * 0 ok; -1 null/invalid compose/id==0; -2 already live.
 * Header matches body (compose guard adds invalid; mint adds id==0/-2).
 */
int slake_host_compose_mint(slake_host_compose *hc, uint32_t id);

/* Thin call-through to slake_consume_token_consume after valid guard.
 * 0 success; -1 null/invalid/empty; -2 already spent / LINEAR-EXACT-ONCE.
 * Header matches body.
 */
int slake_host_compose_consume(slake_host_compose *hc);

/* Thin call-through to slake_erased_mark on &hc->erased after valid guard.
 * 0 ok; -1 null/invalid compose (or null erased path from mark).
 * Header matches body -- explicit compose codes, not "same as erased_mark" alone.
 */
int slake_host_compose_mark_erased(slake_host_compose *hc);

/* 1 if non-null, valid, graph well-typed (slake_ir_graph_is_well_typed); else 0.
 * Host may be unminted (composition allows empty graph).
 */
int slake_host_compose_is_well_typed(const slake_host_compose *hc);

/* Fail-closed composition (0 OK / 1 FAIL_CLOSED). Header must match body.
 *
 * Orchestration (honest non-thin mult pre-scan, then graph check):
 * 1) null/invalid/ill-typed graph -> FAIL_CLOSED
 * 2) Mult pre-scan of owned graph nodes (intentional; not pure call-through):
 *    - any MULT-1 node requires slake_consume_token_is_live(&hc->host)==1
 *    - any MULT-0 node requires erased marked (slake_erasure_is_runtime_absent)
 *    Rationale: compose owns host+erasure handles and fails closed at the
 *    compose boundary before pointer selection. Graph/node checks also enforce
 *    MULT-1/0 when linear/erased are null; pre-scan is redundant-safe today
 *    and documents host ownership at this layer. Behavioral smoke locks both.
 * 3) Select linear = &hc->host.token when live else null; erased = &hc->erased
 *    when marked else null; call slake_ir_graph_check_fail_closed.
 * Greppable: HOST_COMPOSE_V0, FAIL_CLOSED_CHECKER_V1, RUNTIME-FS
 */
int slake_host_compose_check_fail_closed(const slake_host_compose *hc);

/* Extract path: run check_fail_closed; on OK write *out_rt = SLAKE_RUNTIME_FS and return OK;
 * on fail leave *out_rt untouched; null out_rt on success path is FAIL_CLOSED.
 * Greppable: HOST_COMPOSE_V0, EMIT-BOUNDARY, RUNTIME-FS
 */
int slake_host_compose_extract(const slake_host_compose *hc,
    enum slake_runtime_class *out_rt);

/* ---- EMIT_PLAN_V0 -- emit plan from host compose (not residual free; not CFG/SSA)
 * Readiness inventory derived from a checked host compose. Not full product emit
 * of IR bodies. not residual free; not PROVABLY; no product GC.
 * Greppable: EMIT_PLAN_V0, HOST_COMPOSE_V0, RUNTIME-FS, EMIT-BOUNDARY
 */
typedef struct slake_emit_plan {
  uint8_t node_count;     /* program node count */
  uint8_t edge_count;     /* graph edge count */
  uint8_t runtime_nodes;  /* count of MULT-1 + MULT-OMEGA nodes (survive product wire) */
  uint8_t erased_nodes;   /* count of MULT-0 nodes */
  uint8_t ready;          /* 1 if host_compose check_fail_closed would be OK */
  uint8_t valid;          /* 1 after successful plan build */
} slake_emit_plan;

const char *slake_emit_plan_id(void); /* exact "EMIT_PLAN_V0" */

/* Build plan from host compose.
 * 0 ok; -1 null out or null/invalid/ill-typed compose, OR check_fail_closed fails.
 * On failure: if out non-null, set valid=0 and leave other fields zeroed (fail closed).
 * On success:
 *   - node_count = hc->graph.prog.count
 *   - edge_count = hc->graph.edge_count
 *   - runtime_nodes / erased_nodes counted from live nodes' mult
 *   - ready = 1
 *   - valid = 1
 * Greppable: EMIT_PLAN_V0, HOST_COMPOSE_V0, RUNTIME-FS, EMIT-BOUNDARY
 * Honesty: not residual free; plan is readiness inventory, not full product emit of IR bodies.
 */
int slake_emit_plan_from_compose(const slake_host_compose *hc, slake_emit_plan *out);

/* Optional thin: 1 if non-null and valid and ready; else 0 */
int slake_emit_plan_is_ready(const slake_emit_plan *plan);

/* ---- EMIT_APPLY_V0 -- apply plan tags into fixed buffer (not residual free).
 * Serialisation of live node mult/kind tags from a checked host compose.
 * Not full product C body codegen; not CFG/SSA; not residual free; no product GC.
 * Greppable: EMIT_APPLY_V0, EMIT_PLAN_V0, HOST_COMPOSE_V0, RUNTIME-FS
 *
 * Tag packing (one byte per live program node, order = program node order):
 *   tag = (uint8_t)(((unsigned)mult & 0xFu) << 4 | ((unsigned)kind & 0xFu))
 * Mult codes (high nibble): MULT_0=0, MULT_1=1, MULT_OMEGA=2 (enum slake_mult).
 * Kind codes (low nibble): VALUE=0, LINEAR=1, ERASED=2 (enum slake_ir_kind).
 *
 * Capacity honesty: SLAKE_EMIT_APPLY_CAP (32) is defensive headroom above
 * SLAKE_IR_PROGRAM_CAP (8). Honest compose mutators (push_node) cannot grow
 * live node count past PROGRAM_CAP, so the apply overflow branch is unreachable
 * via public APIs today; retained for poisoned prog.count and future program growth.
 * APPLY_CAP is not a claim that apply supports 32 live nodes while the program
 * still caps at 8.
 */
#define SLAKE_EMIT_APPLY_CAP 32

typedef struct slake_emit_apply {
  uint8_t tags[SLAKE_EMIT_APPLY_CAP]; /* packed: mult high nibble, kind low */
  uint8_t count; /* number of tags written */
  uint8_t valid; /* 1 after successful apply */
} slake_emit_apply;

const char *slake_emit_apply_id(void); /* exact "EMIT_APPLY_V0" */

/* Apply from host compose: requires compose check_fail_closed OK.
 * Walks live program nodes in order; for each node writes one tag byte.
 * 0 ok; -1 null out or null/invalid/ill-typed compose or check fails or
 * count would exceed SLAKE_EMIT_APPLY_CAP (defensive; see CAP honesty above --
 * live count is bounded by SLAKE_IR_PROGRAM_CAP via honest mutators).
 * On failure if out non-null: set valid=0 and count=0 (tags left unspecified).
 * Empty well-typed ready compose (0 nodes) is OK: count=0, valid=1.
 * Greppable: EMIT_APPLY_V0, EMIT_PLAN_V0, HOST_COMPOSE_V0, RUNTIME-FS
 * Honesty: not residual free; not full C body emit; not CFG/SSA.
 */
int slake_emit_apply_from_compose(const slake_host_compose *hc,
    slake_emit_apply *out);

/* Thin: 1 if non-null and valid; else 0 */
int slake_emit_apply_is_valid(const slake_emit_apply *a);

/* ---- EMIT_BODY_V0 -- freestanding C body fragment (not residual free; not CFG/SSA)
 * Deterministic ASCII fragment from a checked host compose via plan + apply.
 * Not full product module emit; not CFG/SSA; not residual free; no product GC.
 * HOST-EMIT-SSOT: dialect from SystemsLean.EmitBody.buildFragment +
 *   host_emit_body_fragment.ssot.txt (generator bash is NON-SSOT for fragment text).
 * Greppable: EMIT_BODY_V0, EMIT_APPLY_V0, EMIT_PLAN_V0, HOST_COMPOSE_V0,
 *            RUNTIME-FS, EMIT-BOUNDARY, HOST-EMIT-SSOT
 *
 * Fragment shape (deterministic C comment lines; HOST-EMIT-SSOT):
 *   EMIT_BODY_V0 RUNTIME-FS r=N e=M
 *   tI mult=X kind=Y
 * Tag mult/kind use EMIT_APPLY_V0 packing: mult high nibble, kind low nibble.
 * MULT-0 tags may still be listed (erased inventory honesty, not product wire claim).
 */
#define SLAKE_EMIT_BODY_CAP 256

typedef struct slake_emit_body {
  char buf[SLAKE_EMIT_BODY_CAP]; /* NUL-terminated fragment on success */
  uint16_t len;  /* strlen of buf on success (excluding NUL) */
  uint8_t valid; /* 1 after successful build */
} slake_emit_body;

const char *slake_emit_body_id(void); /* exact "EMIT_BODY_V0" */

/* Build body from checked host compose.
 * 0 ok; -1 null out/hc, plan/apply/check fail, or buffer would overflow.
 * On failure: if out non-null, valid=0, len=0, buf[0]=0 (fail closed).
 * On success:
 *   - require plan ready + apply valid (call those APIs; do not reimplement checks)
 *   - write deterministic ASCII fragment into buf, NUL-terminated
 *   - must contain greppable substrings: EMIT_BODY_V0 and RUNTIME-FS
 *   - include decimal runtime_nodes and erased_nodes from plan
 *   - for each apply tag index 0..count-1, append one short line encoding mult/kind
 *     (same packing as EMIT_APPLY_V0: mult high nibble, kind low)
 *   - MULT-0 tags may still be listed (erased inventory) -- honesty, not product wire claim
 * Greppable: EMIT_BODY_V0, EMIT_APPLY_V0, EMIT_PLAN_V0, RUNTIME-FS, EMIT-BOUNDARY
 * Honesty: not residual free; fragment is not full product module emit.
 */
int slake_emit_body_from_compose(const slake_host_compose *hc, slake_emit_body *out);

/* 1 if non-null, valid, len < CAP, buf[len]==0; else 0 */
int slake_emit_body_is_valid(const slake_emit_body *b);

#ifdef __cplusplus
}
#endif

#endif /* SLAKE_FREESTANDING_H */
