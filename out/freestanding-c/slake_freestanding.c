/* SPDX-License-Identifier: Unlicense */
/* SLAKE_EMIT_FREESTANDING_C_V0 -- freestanding C definitions.
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
 * No main required. No stdlib GC. No Lean headers.
 * MULT-0 / MULT-1 / MULT-OMEGA greppable via slake_mult_name (HOST-EMIT-MULT).
 */

#include "slake_freestanding.h"

const char *slake_emit_version(void)
{
  return "SLAKE_EMIT_FREESTANDING_C_V0+UNIT_DEEPEN_V1+FAIL_CLOSED_CHECKER_V1+CONSUME_TOKEN_HOST_V0+TYPED_IR_V0+IR_PROGRAM_V0+IR_GRAPH_EDGES_V0+HOST_COMPOSE_V0+EMIT_PLAN_V0+EMIT_APPLY_V0+EMIT_BODY_V0";
}

const char *slake_unit_translation_id(void)
{
  return "UNIT_TRANSLATION_V0";
}

const char *slake_consume_token_host_id(void)
{
  return "CONSUME_TOKEN_HOST_V0";
}

/* ---- Types ---- */

int slake_type_tag_init(slake_type_tag *t, uint32_t tag)
{
  if (t == 0) {
    return -1;
  }
  t->tag = tag;
  return 0;
}

uint32_t slake_type_tag_get(const slake_type_tag *t)
{
  if (t == 0) {
    return 0;
  }
  return t->tag;
}

/* ---- Mult (FAIL-CLOSED-UNKNOWN-GRADE) ----
 * HOST-EMIT-MULT: dialect from SystemsLean.EmitMult + host_emit_mult.ssot.txt
 * (generator bash is NON-SSOT for Mult product text).
 */

int slake_mult_is_valid(enum slake_mult m)
{
  if (m == SLAKE_MULT_0 || m == SLAKE_MULT_1 || m == SLAKE_MULT_OMEGA) {
    return 1;
  }
  return 0;
}

int slake_mult_is_known(enum slake_mult m)
{
  return slake_mult_is_valid(m);
}

const char *slake_mult_name(enum slake_mult m)
{
  if (m == SLAKE_MULT_0) {
    return "MULT-0";
  }
  if (m == SLAKE_MULT_1) {
    return "MULT-1";
  }
  if (m == SLAKE_MULT_OMEGA) {
    return "MULT-OMEGA";
  }
  return 0; /* unknown: fail closed; no silent coerce */
}

/* ---- Linear (LINEAR-EXACT-ONCE; JOIN-ALG ConsumeToken dual anchor on sides) ---- */

int slake_linear_token_init(slake_linear_token *tok, uint32_t id)
{
  if (tok == 0) {
    return -1;
  }
  /* id 0 is the spent sentinel; refuse so is_live matches consumability. */
  if (id == 0) {
    return -1;
  }
  tok->id = id;
  tok->live = 1;
  return 0;
}

int slake_linear_consume(slake_linear_token *tok)
{
  if (tok == 0) {
    return -1;
  }
  /* Exact-once: live flag is the authority; scrub id after spend. */
  if (tok->live == 0) {
    return -2; /* already consumed -- fail closed */
  }
  tok->live = 0;
  tok->id = 0;
  return 0;
}

int slake_linear_token_consume(slake_linear_token *tok)
{
  /* Alias: single body via call-through (same return codes as canonical). */
  return slake_linear_consume(tok);
}

int slake_linear_token_is_live(const slake_linear_token *tok)
{
  if (tok == 0) {
    return 0;
  }
  return (tok->live != 0) ? 1 : 0;
}

/* ---- Erasure (ERASE-RULE-MULT-0 / ERASE-NO-RUNTIME) ---- */

int slake_erased_mark(slake_erased *e)
{
  if (e == 0) {
    return -1;
  }
  e->marked = 1;
  return 0;
}

int slake_erased_is_marked(const slake_erased *e)
{
  if (e == 0) {
    return 0;
  }
  return (e->marked != 0) ? 1 : 0;
}

int slake_erasure_is_runtime_absent(const slake_erased *e)
{
  /* Fail closed: only marked MULT-0 handles claim runtime absence. */
  if (e == 0) {
    return 0;
  }
  if (e->marked == 0) {
    return 0;
  }
  return 1;
}

/* ---- Extract (EMIT-BOUNDARY / RUNTIME-FS) ---- */

int slake_extract_status_ok(void)
{
  return (int)SLAKE_EXTRACT_OK;
}

enum slake_runtime_class slake_extract_product_runtime(void)
{
  /* Product wire is RUNTIME-FS only; EDGE-RUNTIME / RUNTIME-CLASSIC stay off-wire. */
  return SLAKE_RUNTIME_FS;
}

/* ---- FAIL_CLOSED_CHECKER_V1 (composed checks + extract path) ---- */

int slake_check_fail_closed(const slake_check_bundle *b)
{
  /* null bundle -> FAIL_CLOSED */
  if (b == 0) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  /* mult must pass slake_mult_is_valid */
  if (slake_mult_is_valid(b->mult) != 1) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  /* claimed_runtime must be SLAKE_RUNTIME_FS (fail closed on CLASSIC / EDGE-RUNTIME) */
  if (b->claimed_runtime != SLAKE_RUNTIME_FS) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  if (b->mult == SLAKE_MULT_1) {
    /* MULT-1: linear non-null AND live (check-only; do not consume here) */
    if (b->linear == 0 || slake_linear_token_is_live(b->linear) != 1) {
      return (int)SLAKE_EXTRACT_FAIL_CLOSED;
    }
  } else if (b->mult == SLAKE_MULT_0) {
    /* MULT-0: erased non-null AND runtime-absent marked */
    if (b->erased == 0 || slake_erasure_is_runtime_absent(b->erased) != 1) {
      return (int)SLAKE_EXTRACT_FAIL_CLOSED;
    }
  }
  /* MULT-OMEGA: linear/erased may be null (unrestricted) */
  return (int)SLAKE_EXTRACT_OK;
}

int slake_extract_with_checks(const slake_check_bundle *b, enum slake_runtime_class *out_rt)
{
  /* Fail closed first; leave *out_rt untouched on fail. */
  if (slake_check_fail_closed(b) != (int)SLAKE_EXTRACT_OK) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  /* null out_rt on success path is FAIL_CLOSED */
  if (out_rt == 0) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  *out_rt = SLAKE_RUNTIME_FS;
  return (int)SLAKE_EXTRACT_OK;
}

/* ---- CONSUME_TOKEN_HOST_V0 (JOIN-ALG ConsumeToken-class freestanding host) ----
 * mint + exact-once consume at C level; duals not reimplemented.
 * LINEAR-EXACT-ONCE / MULT-1; not residual free; not PROVABLY.
 */

int slake_consume_token_init(slake_consume_token *ct)
{
  if (ct == 0) {
    return -1;
  }
  ct->token.id = 0;
  ct->token.live = 0;
  ct->state = 0; /* empty */
  return 0;
}

int slake_consume_token_mint(slake_consume_token *ct, uint32_t id)
{
  if (ct == 0) {
    return -1;
  }
  if (id == 0) {
    return -1; /* spent sentinel reserved; fail closed */
  }
  /* Key off is_live (state + token.live) so remint recovers desync. */
  if (slake_consume_token_is_live(ct) == 1) {
    return -2; /* already holds live MULT-1 token */
  }
  if (slake_linear_token_init(&ct->token, id) != 0) {
    return -1;
  }
  ct->state = 1; /* live */
  return 0;
}

int slake_consume_token_consume(slake_consume_token *ct)
{
  int rc;

  if (ct == 0) {
    return -1;
  }
  if (ct->state == 0) {
    return -1; /* empty -- never minted */
  }
  if (ct->state == 2) {
    return -2; /* already spent -- LINEAR-EXACT-ONCE fail closed */
  }
  /* state == 1 believed live: compose with linear exact-once consume */
  rc = slake_linear_consume(&ct->token);
  if (rc == 0) {
    ct->state = 2; /* spent */
  } else if (rc == -2) {
    /* Heal desync if token already spent under host that believed live. */
    ct->state = 2;
  }
  return rc;
}

int slake_consume_token_is_live(const slake_consume_token *ct)
{
  if (ct == 0) {
    return 0;
  }
  if (ct->state != 1) {
    return 0;
  }
  return (slake_linear_token_is_live(&ct->token) == 1) ? 1 : 0;
}

int slake_consume_token_check_fail_closed(const slake_consume_token *ct)
{
  slake_check_bundle b;

  if (ct == 0) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  /* Host must hold live MULT-1 (is_live); checker is check-only (no consume). */
  if (slake_consume_token_is_live(ct) != 1) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  b.mult = SLAKE_MULT_1;
  b.linear = &ct->token;
  b.erased = 0;
  b.claimed_runtime = SLAKE_RUNTIME_FS;
  return slake_check_fail_closed(&b);
}

/* ---- TYPED_IR_V0 (richer typed IR; not residual free; not full elaborator) ----
 * Kind/mult pairing fail-closed. Composes FAIL_CLOSED_CHECKER_V1 on check path.
 */

const char *slake_typed_ir_id(void)
{
  return "TYPED_IR_V0";
}

/* Internal: 1 if kind pairs with mult under TYPED_IR_V0 rules; 0 otherwise. */
static int slake_ir_kind_matches_mult(enum slake_ir_kind kind, enum slake_mult mult)
{
  if (mult == SLAKE_MULT_OMEGA && kind == SLAKE_IR_KIND_VALUE) {
    return 1;
  }
  if (mult == SLAKE_MULT_1 && kind == SLAKE_IR_KIND_LINEAR) {
    return 1;
  }
  if (mult == SLAKE_MULT_0 && kind == SLAKE_IR_KIND_ERASED) {
    return 1;
  }
  return 0;
}

int slake_ir_node_init(slake_ir_node *n, uint32_t type_tag,
                       enum slake_mult mult, enum slake_ir_kind kind)
{
  if (n == 0) {
    return -1;
  }
  /* Fail closed first; leave invalid on any reject path. */
  n->valid = 0;
  n->mult = mult;
  n->kind = kind;
  n->ty.tag = 0;
  if (slake_mult_is_valid(mult) != 1) {
    return -1;
  }
  if (slake_ir_kind_matches_mult(kind, mult) != 1) {
    return -1;
  }
  if (slake_type_tag_init(&n->ty, type_tag) != 0) {
    return -1;
  }
  n->valid = 1;
  return 0;
}

int slake_ir_node_is_well_typed(const slake_ir_node *n)
{
  if (n == 0) {
    return 0;
  }
  if (n->valid == 0) {
    return 0;
  }
  if (slake_mult_is_valid(n->mult) != 1) {
    return 0;
  }
  if (slake_ir_kind_matches_mult(n->kind, n->mult) != 1) {
    return 0;
  }
  return 1;
}

int slake_ir_node_check_fail_closed(const slake_ir_node *n,
    const slake_linear_token *linear,
    const slake_erased *erased)
{
  slake_check_bundle b;

  /* Well-typed IR required before composing FAIL_CLOSED_CHECKER_V1. */
  if (slake_ir_node_is_well_typed(n) != 1) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  b.mult = n->mult;
  b.linear = linear;
  b.erased = erased;
  b.claimed_runtime = SLAKE_RUNTIME_FS; /* product path always RUNTIME-FS */
  return slake_check_fail_closed(&b);
}

/* ---- IR_PROGRAM_V0 (multi-node ordered list; not CFG; not residual free) ----
 * Collective well-typed + fail-closed over fixed-capacity node array.
 * Edges/CFG remain residual. Shared linear token across MULT-1 nodes is V0 honesty.
 */

const char *slake_ir_program_id(void)
{
  return "IR_PROGRAM_V0";
}

int slake_ir_program_init(slake_ir_program *p)
{
  uint8_t i;

  if (p == 0) {
    return -1;
  }
  p->count = 0;
  p->valid = 1;
  /* Dead slots: valid=0 with consistent OMEGA+VALUE pairing (not a live node). */
  for (i = 0; i < (uint8_t)SLAKE_IR_PROGRAM_CAP; i++) {
    p->nodes[i].valid = 0;
    p->nodes[i].mult = SLAKE_MULT_OMEGA;
    p->nodes[i].kind = SLAKE_IR_KIND_VALUE;
    p->nodes[i].ty.tag = 0;
  }
  return 0;
}

int slake_ir_program_push(slake_ir_program *p, uint32_t type_tag,
                          enum slake_mult mult, enum slake_ir_kind kind)
{
  slake_ir_node tmp;

  if (p == 0 || p->valid == 0) {
    return -1;
  }
  if (p->count >= (uint8_t)SLAKE_IR_PROGRAM_CAP) {
    return -2; /* full; leave count unchanged */
  }
  /* Init into temp so a bad node never lands in the program. */
  if (slake_ir_node_init(&tmp, type_tag, mult, kind) != 0) {
    return -1;
  }
  p->nodes[p->count] = tmp;
  p->count = (uint8_t)(p->count + 1);
  return 0;
}

int slake_ir_program_is_well_typed(const slake_ir_program *p)
{
  uint8_t i;

  if (p == 0) {
    return 0;
  }
  if (p->valid == 0) {
    return 0;
  }
  /* Empty program is not well-typed as a program (fail closed). */
  if (p->count == 0) {
    return 0;
  }
  if (p->count > (uint8_t)SLAKE_IR_PROGRAM_CAP) {
    return 0;
  }
  for (i = 0; i < p->count; i++) {
    if (slake_ir_node_is_well_typed(&p->nodes[i]) != 1) {
      return 0;
    }
  }
  return 1;
}

int slake_ir_program_check_fail_closed(const slake_ir_program *p,
    const slake_linear_token *linear,
    const slake_erased *erased)
{
  uint8_t i;

  /* Null, empty, or ill-typed -> FAIL_CLOSED. */
  if (slake_ir_program_is_well_typed(p) != 1) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  for (i = 0; i < p->count; i++) {
    if (slake_ir_node_check_fail_closed(&p->nodes[i], linear, erased)
        != (int)SLAKE_EXTRACT_OK) {
      return (int)SLAKE_EXTRACT_FAIL_CLOSED;
    }
  }
  return (int)SLAKE_EXTRACT_OK;
}

/* ---- IR_GRAPH_EDGES_V0 (edges over ordered IR program; not residual free) ----
 * Endpoints are indices into prog.nodes. Thin call-through to program APIs.
 * Empty edges OK. Empty graph (no nodes) is well-typed at graph surface.
 * Shared linear/erased handles remain V0 honesty for checks.
 * Greppable types: slake_ir_graph, slake_ir_edge, SLAKE_IR_EDGE_MAX.
 */

const char *slake_ir_graph_id(void)
{
  return "IR_GRAPH_EDGES_V0";
}

int slake_ir_graph_init(slake_ir_graph *g)
{
  uint8_t i;

  if (g == 0) {
    return -1;
  }
  if (slake_ir_program_init(&g->prog) != 0) {
    return -1;
  }
  g->edge_count = 0;
  g->valid = 1;
  for (i = 0; i < (uint8_t)SLAKE_IR_EDGE_MAX; i++) {
    g->edges[i].from = 0;
    g->edges[i].to = 0;
    g->edges[i].valid = 0;
  }
  return 0;
}

int slake_ir_graph_push_node(slake_ir_graph *g, uint32_t type_tag,
                             enum slake_mult mult, enum slake_ir_kind kind)
{
  if (g == 0 || g->valid == 0) {
    return -1;
  }
  return slake_ir_program_push(&g->prog, type_tag, mult, kind);
}

int slake_ir_graph_add_edge(slake_ir_graph *g, uint8_t from, uint8_t to)
{
  if (g == 0 || g->valid == 0) {
    return -1;
  }
  if (g->edge_count >= (uint8_t)SLAKE_IR_EDGE_MAX) {
    return -1; /* full; leave edge_count unchanged */
  }
  /* Endpoints must reference live program nodes. */
  if (from >= g->prog.count || to >= g->prog.count) {
    return -1;
  }
  g->edges[g->edge_count].from = from;
  g->edges[g->edge_count].to = to;
  g->edges[g->edge_count].valid = 1;
  g->edge_count = (uint8_t)(g->edge_count + 1);
  return 0;
}

int slake_ir_graph_is_well_typed(const slake_ir_graph *g)
{
  uint8_t i;

  if (g == 0) {
    return 0;
  }
  if (g->valid == 0) {
    return 0;
  }
  if (g->edge_count > (uint8_t)SLAKE_IR_EDGE_MAX) {
    return 0;
  }
  /* Empty valid graph (no nodes, no edges): well-typed at graph surface. */
  if (g->prog.count == 0) {
    if (g->edge_count != 0) {
      return 0;
    }
    return 1;
  }
  if (slake_ir_program_is_well_typed(&g->prog) != 1) {
    return 0;
  }
  /* Empty edges OK when program is well-typed. */
  for (i = 0; i < g->edge_count; i++) {
    if (g->edges[i].valid != 1) {
      return 0;
    }
    if (g->edges[i].from >= g->prog.count || g->edges[i].to >= g->prog.count) {
      return 0;
    }
  }
  return 1;
}

int slake_ir_graph_check_fail_closed(const slake_ir_graph *g,
    const slake_linear_token *linear,
    const slake_erased *erased)
{
  /* Ill-typed / null graph -> FAIL_CLOSED before program call-through. */
  if (slake_ir_graph_is_well_typed(g) != 1) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  /* Empty well-typed graph: no nodes to check. */
  if (g->prog.count == 0) {
    return (int)SLAKE_EXTRACT_OK;
  }
  return slake_ir_program_check_fail_closed(&g->prog, linear, erased);
}

/* ---- HOST_COMPOSE_V0 (host + IR graph composition; not residual free) ----
 * Mutators (mint/consume/push/add_edge/mark_erased) are thin call-throughs.
 * check_fail_closed: intentional mult pre-scan for host ownership, then
 * graph check (see header). MULT-1 needs live host; MULT-0 needs marked erased.
 * Greppable: HOST_COMPOSE_V0, CONSUME_TOKEN_HOST_V0, IR_GRAPH_EDGES_V0,
 * EMIT-BOUNDARY, RUNTIME-FS.
 */

const char *slake_host_compose_id(void)
{
  return "HOST_COMPOSE_V0";
}

int slake_host_compose_init(slake_host_compose *hc)
{
  if (hc == 0) {
    return -1;
  }
  if (slake_ir_graph_init(&hc->graph) != 0) {
    return -1;
  }
  if (slake_consume_token_init(&hc->host) != 0) {
    return -1;
  }
  hc->erased.marked = 0;
  hc->valid = 1;
  return 0;
}

int slake_host_compose_push_node(slake_host_compose *hc, uint32_t type_tag,
    enum slake_mult mult, enum slake_ir_kind kind)
{
  if (hc == 0 || hc->valid == 0) {
    return -1;
  }
  return slake_ir_graph_push_node(&hc->graph, type_tag, mult, kind);
}

int slake_host_compose_add_edge(slake_host_compose *hc, uint8_t from, uint8_t to)
{
  if (hc == 0 || hc->valid == 0) {
    return -1;
  }
  return slake_ir_graph_add_edge(&hc->graph, from, to);
}

int slake_host_compose_mint(slake_host_compose *hc, uint32_t id)
{
  if (hc == 0 || hc->valid == 0) {
    return -1;
  }
  return slake_consume_token_mint(&hc->host, id);
}

int slake_host_compose_consume(slake_host_compose *hc)
{
  if (hc == 0 || hc->valid == 0) {
    return -1;
  }
  return slake_consume_token_consume(&hc->host);
}

int slake_host_compose_mark_erased(slake_host_compose *hc)
{
  if (hc == 0 || hc->valid == 0) {
    return -1;
  }
  return slake_erased_mark(&hc->erased);
}

int slake_host_compose_is_well_typed(const slake_host_compose *hc)
{
  if (hc == 0 || hc->valid == 0) {
    return 0;
  }
  /* Host may be unminted; empty graph OK at graph surface. */
  return slake_ir_graph_is_well_typed(&hc->graph);
}

int slake_host_compose_check_fail_closed(const slake_host_compose *hc)
{
  uint8_t i;
  int needs_mult1;
  int needs_mult0;
  const slake_linear_token *linear;
  const slake_erased *erased;

  if (hc == 0 || hc->valid == 0) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  if (slake_ir_graph_is_well_typed(&hc->graph) != 1) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }

  /* Intentional mult pre-scan (compose owns host+erasure; fail closed here
   * before pointer selection). Graph check also enforces MULT-1/0 when
   * linear/erased are null -- redundant-safe; smoke locks both layers. */
  needs_mult1 = 0;
  needs_mult0 = 0;
  for (i = 0; i < hc->graph.prog.count; i++) {
    if (hc->graph.prog.nodes[i].mult == SLAKE_MULT_1) {
      needs_mult1 = 1;
    }
    if (hc->graph.prog.nodes[i].mult == SLAKE_MULT_0) {
      needs_mult0 = 1;
    }
  }
  if (needs_mult1 != 0 && slake_consume_token_is_live(&hc->host) != 1) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  if (needs_mult0 != 0
      && slake_erasure_is_runtime_absent(&hc->erased) != 1) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }

  /* Public field: host embeds slake_linear_token token. */
  linear = 0;
  if (slake_consume_token_is_live(&hc->host) == 1) {
    linear = &hc->host.token;
  }
  erased = 0;
  if (slake_erasure_is_runtime_absent(&hc->erased) == 1) {
    erased = &hc->erased;
  }
  return slake_ir_graph_check_fail_closed(&hc->graph, linear, erased);
}

int slake_host_compose_extract(const slake_host_compose *hc,
    enum slake_runtime_class *out_rt)
{
  /* Fail closed first; leave *out_rt untouched on fail. */
  if (slake_host_compose_check_fail_closed(hc) != (int)SLAKE_EXTRACT_OK) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  /* null out_rt on success path is FAIL_CLOSED */
  if (out_rt == 0) {
    return (int)SLAKE_EXTRACT_FAIL_CLOSED;
  }
  *out_rt = SLAKE_RUNTIME_FS;
  return (int)SLAKE_EXTRACT_OK;
}

/* ---- EMIT_PLAN_V0 (emit plan from host compose; not residual free; not CFG/SSA) ----
 * Readiness inventory: node/edge counts + MULT-1/OMEGA runtime vs MULT-0 erased.
 * Requires host_compose check_fail_closed OK. Not full product emit of IR bodies.
 * Greppable: EMIT_PLAN_V0, HOST_COMPOSE_V0, RUNTIME-FS, EMIT-BOUNDARY.
 */

const char *slake_emit_plan_id(void)
{
  return "EMIT_PLAN_V0";
}

int slake_emit_plan_from_compose(const slake_host_compose *hc, slake_emit_plan *out)
{
  uint8_t i;
  uint8_t runtime;
  uint8_t erased;

  if (out == 0) {
    return -1;
  }
  /* Fail closed: zero fields and valid=0 before any further checks. */
  out->node_count = 0;
  out->edge_count = 0;
  out->runtime_nodes = 0;
  out->erased_nodes = 0;
  out->ready = 0;
  out->valid = 0;

  if (hc == 0 || hc->valid == 0) {
    return -1;
  }
  if (slake_host_compose_is_well_typed(hc) != 1) {
    return -1;
  }
  if (slake_host_compose_check_fail_closed(hc) != (int)SLAKE_EXTRACT_OK) {
    return -1;
  }

  runtime = 0;
  erased = 0;
  for (i = 0; i < hc->graph.prog.count; i++) {
    if (hc->graph.prog.nodes[i].mult == SLAKE_MULT_0) {
      erased = (uint8_t)(erased + 1);
    } else {
      /* MULT-1 and MULT-OMEGA survive product wire as runtime nodes */
      runtime = (uint8_t)(runtime + 1);
    }
  }

  out->node_count = hc->graph.prog.count;
  out->edge_count = hc->graph.edge_count;
  out->runtime_nodes = runtime;
  out->erased_nodes = erased;
  out->ready = 1;
  out->valid = 1;
  return 0;
}

int slake_emit_plan_is_ready(const slake_emit_plan *plan)
{
  if (plan == 0 || plan->valid == 0 || plan->ready == 0) {
    return 0;
  }
  return 1;
}

/* ---- EMIT_APPLY_V0 (apply plan tags from host compose; not residual free) ----
 * Serialisation of live node mult/kind into a fixed buffer. Not full C body emit.
 * Greppable: EMIT_APPLY_V0, EMIT_PLAN_V0, HOST_COMPOSE_V0, RUNTIME-FS.
 * Tag: high nibble = mult (0/1/2), low nibble = kind (0/1/2).
 * CAP honesty: APPLY_CAP 32 is defensive headroom above PROGRAM_CAP 8;
 * overflow branch unreachable via honest push_node (see header comment).
 */

const char *slake_emit_apply_id(void)
{
  return "EMIT_APPLY_V0";
}

int slake_emit_apply_from_compose(const slake_host_compose *hc,
    slake_emit_apply *out)
{
  uint8_t i;
  uint8_t n;

  if (out == 0) {
    return -1;
  }
  /* Fail closed: clear count/valid before further checks. */
  out->count = 0;
  out->valid = 0;

  if (hc == 0 || hc->valid == 0) {
    return -1;
  }
  if (slake_host_compose_is_well_typed(hc) != 1) {
    return -1;
  }
  if (slake_host_compose_check_fail_closed(hc) != (int)SLAKE_EXTRACT_OK) {
    return -1;
  }

  n = hc->graph.prog.count;
  /* Defensive: APPLY_CAP (32) > PROGRAM_CAP (8); honest mutators cannot hit this. */
  if (n > (uint8_t)SLAKE_EMIT_APPLY_CAP) {
    return -1;
  }

  for (i = 0; i < n; i++) {
    enum slake_mult mult;
    enum slake_ir_kind kind;
    mult = hc->graph.prog.nodes[i].mult;
    kind = hc->graph.prog.nodes[i].kind;
    /* Pack: mult high nibble, kind low nibble (codes match enums 0/1/2). */
    out->tags[i] = (uint8_t)((((unsigned)mult & 0xFu) << 4)
        | ((unsigned)kind & 0xFu));
  }

  out->count = n;
  out->valid = 1;
  return 0;
}

int slake_emit_apply_is_valid(const slake_emit_apply *a)
{
  if (a == 0 || a->valid == 0) {
    return 0;
  }
  return 1;
}

/* ---- EMIT_BODY_V0 (freestanding C body fragment; not residual free; not CFG/SSA) ----
 * Builds a fixed-buffer deterministic ASCII fragment via plan + apply APIs.
 * No snprintf/stdlib; manual digit write. Greppable: EMIT_BODY_V0, RUNTIME-FS,
 * EMIT_APPLY_V0, EMIT_PLAN_V0, EMIT-BOUNDARY, HOST-EMIT-SSOT.
 * Fragment dialect: HOST-EMIT-SSOT (SystemsLean.EmitBody.buildFragment +
 * host_emit_body_fragment.ssot.txt); generator bash is NON-SSOT for put_str text.
 */

/* HOST-EMIT-SSOT empty-compose fragment (matches EmitBody.emptyComposeFragmentSsot).
 * Greppable contract text; returned only for honesty / smoke of dialect embed. */
static const char slake_emit_body_empty_ssot[] = "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */\n";

const char *slake_emit_body_id(void)
{
  /* Touch empty SSOT string so freestanding link keeps the greppable literal. */
  if (slake_emit_body_empty_ssot[0] == 0) {
    return "EMIT_BODY_V0";
  }
  return "EMIT_BODY_V0";
}

/* Append one char; leave room for trailing NUL. Returns 0 ok, -1 overflow. */
static int slake_emit_body_put_char(slake_emit_body *out, char c)
{
  if (out->len + 1u >= (uint16_t)SLAKE_EMIT_BODY_CAP) {
    return -1;
  }
  out->buf[out->len] = c;
  out->len = (uint16_t)(out->len + 1u);
  return 0;
}

static int slake_emit_body_put_str(slake_emit_body *out, const char *s)
{
  if (s == 0) {
    return -1;
  }
  while (*s != 0) {
    if (slake_emit_body_put_char(out, *s) != 0) {
      return -1;
    }
    s = s + 1;
  }
  return 0;
}

/* Decimal write of uint8_t (0..255); freestanding, no snprintf. */
static int slake_emit_body_put_u8(slake_emit_body *out, uint8_t v)
{
  char digs[3];
  int n;
  uint8_t x;

  if (v == 0) {
    return slake_emit_body_put_char(out, '0');
  }
  n = 0;
  x = v;
  while (x > 0 && n < 3) {
    digs[n] = (char)('0' + (x % 10u));
    n = n + 1;
    x = (uint8_t)(x / 10u);
  }
  while (n > 0) {
    n = n - 1;
    if (slake_emit_body_put_char(out, digs[n]) != 0) {
      return -1;
    }
  }
  return 0;
}

static void slake_emit_body_fail_closed(slake_emit_body *out)
{
  out->len = 0;
  out->valid = 0;
  out->buf[0] = 0;
}

int slake_emit_body_from_compose(const slake_host_compose *hc, slake_emit_body *out)
{
  slake_emit_plan plan;
  slake_emit_apply applied;
  uint8_t i;
  uint8_t mult;
  uint8_t kind;

  if (out == 0) {
    return -1;
  }
  /* Fail closed: zero before any further checks. */
  slake_emit_body_fail_closed(out);

  if (hc == 0) {
    return -1;
  }

  /* Require plan ready via plan API (does not reimplement check). */
  if (slake_emit_plan_from_compose(hc, &plan) != 0) {
    return -1;
  }
  if (slake_emit_plan_is_ready(&plan) != 1) {
    return -1;
  }

  /* Require apply valid via apply API. */
  if (slake_emit_apply_from_compose(hc, &applied) != 0) {
    return -1;
  }
  if (slake_emit_apply_is_valid(&applied) != 1) {
    return -1;
  }

  /* Header line: HOST-EMIT-SSOT dialect (EMIT_BODY_V0 RUNTIME-FS r=N e=M). */
  if (slake_emit_body_put_str(out, "/* EMIT_BODY_V0 RUNTIME-FS r=") != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }
  if (slake_emit_body_put_u8(out, plan.runtime_nodes) != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }
  if (slake_emit_body_put_str(out, " e=") != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }
  if (slake_emit_body_put_u8(out, plan.erased_nodes) != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }
  if (slake_emit_body_put_str(out, " */\n") != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }

  /* One line per apply tag: HOST-EMIT-SSOT tI mult=X kind=Y. */
  for (i = 0; i < applied.count; i++) {
    mult = (uint8_t)((applied.tags[i] >> 4) & 0xFu);
    kind = (uint8_t)(applied.tags[i] & 0xFu);
    if (slake_emit_body_put_str(out, "/* t") != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_u8(out, i) != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_str(out, " mult=") != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_u8(out, mult) != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_str(out, " kind=") != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_u8(out, kind) != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_str(out, " */\n") != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
  }

  out->buf[out->len] = 0;
  out->valid = 1;
  return 0;
}

int slake_emit_body_is_valid(const slake_emit_body *b)
{
  if (b == 0 || b->valid == 0) {
    return 0;
  }
  if (b->len >= (uint16_t)SLAKE_EMIT_BODY_CAP) {
    return 0;
  }
  if (b->buf[b->len] != 0) {
    return 0;
  }
  return 1;
}
