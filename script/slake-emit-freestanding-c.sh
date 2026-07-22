#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# SLAKE_EMIT_FREESTANDING_C_V0 -- real freestanding emit path for product C surface.
#
# Writes V0 freestanding C under src/systems/emit/ so release copy can populate
# out/freestanding-c. This stage is:
#   - NOT freestanding residual free / not residual free
#   - NOT PROVABLY / CompCert
#   - NOT product GC / no product GC
#   - NOT Lean managed runtime on the wire
#   - NOT a full Slake compiler body (first real unit translation only)
#   - NEVER writes under out/freestanding-c/ (release copy is a separate just recipe)
#
# HOST-EMIT-SSOT / NON-SSOT (P2):
#   This bash generator is NON-SSOT for EMIT_BODY_V0 fragment dialect text.
#   SSoT: SystemsLean.EmitBody.buildFragment + durable artifact
#         src/systems/emit/host_emit_body_fragment.ssot.txt
#   Re-emit must read that artifact (fail closed) and embed its HEADER_*/TAG_*
#   strings into product C; it must not invent a second fragment header dialect.
#
# HOST-EMIT-MULT / NON-SSOT (SH2):
#   This bash generator is NON-SSOT for Mult freestanding product C text.
#   SSoT: SystemsLean.EmitMult multHeaderFragment / multBodyFragment + durable
#         artifact src/systems/emit/host_emit_mult.ssot.txt
#   Re-emit must read that artifact (fail closed) and embed MULT_C_HEADER /
#   MULT_C_BODY; it must not invent a second Mult dialect.
#   Host stage ids only (HOST-EMIT-MULT / SLAKE_SELF_HOST_EMIT_MULT_V0); do not
#   mint EMIT_MULT_V0 residual C stage ladder.
#
# Stage id (greppable): SLAKE_EMIT_FREESTANDING_C_V0
# Unit translation id (greppable): UNIT_TRANSLATION_V0
# Unit deepen id (greppable): UNIT_DEEPEN_V1
# Fail-closed checker id (greppable): FAIL_CLOSED_CHECKER_V1
# ConsumeToken host id (greppable): CONSUME_TOKEN_HOST_V0
# Typed IR id (greppable): TYPED_IR_V0
# ordered IR program id (greppable): IR_PROGRAM_V0
# IR graph edges id (greppable): IR_GRAPH_EDGES_V0
# Host compose id (greppable): HOST_COMPOSE_V0
# Emit plan id (greppable): EMIT_PLAN_V0
# Emit apply id (greppable): EMIT_APPLY_V0
# Emit body id (greppable): EMIT_BODY_V0
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

STAGE_ID="SLAKE_EMIT_FREESTANDING_C_V0"
UNIT_TX_ID="UNIT_TRANSLATION_V0"
UNIT_DEEPEN_ID="UNIT_DEEPEN_V1"
CHECKER_ID="FAIL_CLOSED_CHECKER_V1"
HOST_ID="CONSUME_TOKEN_HOST_V0"
TYPED_IR_ID="TYPED_IR_V0"
IR_PROGRAM_ID="IR_PROGRAM_V0"
IR_GRAPH_ID="IR_GRAPH_EDGES_V0"
HOST_COMPOSE_ID="HOST_COMPOSE_V0"
EMIT_PLAN_ID="EMIT_PLAN_V0"
EMIT_APPLY_ID="EMIT_APPLY_V0"
EMIT_BODY_ID="EMIT_BODY_V0"
EMIT_DIR="src/systems/emit"
HEADER="${EMIT_DIR}/slake_freestanding.h"
SOURCE="${EMIT_DIR}/slake_freestanding.c"
# HOST-EMIT-SSOT durable fragment dialect (Lean buildFragment is owner).
HOST_EMIT_BODY_SSOT="${EMIT_DIR}/host_emit_body_fragment.ssot.txt"
# HOST-EMIT-MULT durable Mult product text (Lean EmitMult is owner).
HOST_EMIT_MULT_SSOT="${EMIT_DIR}/host_emit_mult.ssot.txt"
COMPILE_DRIVER="script/slake-compile-path.sh"
MANIFEST=".cache/slake-compile-path/manifest.txt"

# Load KEY=value from a durable SSOT file (bash is NON-SSOT; fail closed).
ssot_get_from() {
  local file="$1"
  local key="$2"
  local label="$3"
  local line
  line=$(grep -E "^${key}=" "$file" 2>/dev/null | head -n1 || true)
  if [[ -z "${line}" ]]; then
    echo "RED ${STAGE_ID}: ${label} missing key ${key} in ${file}" >&2
    exit 1
  fi
  printf '%s' "${line#${key}=}"
}

# Extract multi-line block between "# NAME_BEGIN" and "# NAME_END" (inclusive markers excluded).
ssot_block_from() {
  local file="$1"
  local name="$2"
  local label="$3"
  local block
  block=$(awk -v begin="# ${name}_BEGIN" -v end="# ${name}_END" '
    $0 == begin { grab=1; next }
    $0 == end { grab=0; next }
    grab { print }
  ' "$file")
  if [[ -z "${block}" ]]; then
    echo "RED ${STAGE_ID}: ${label} missing block ${name} in ${file}" >&2
    exit 1
  fi
  printf '%s\n' "$block"
}

# Replace a single-line placeholder with multi-line SSOT content (fail closed if missing).
ssot_embed_placeholder() {
  local file="$1"
  local placeholder="$2"
  local content_file="$3"
  local label="$4"
  local tmp
  if ! grep -Fq "$placeholder" "$file" 2>/dev/null; then
    echo "RED ${STAGE_ID}: ${label} placeholder missing in ${file}: ${placeholder}" >&2
    exit 1
  fi
  tmp=$(mktemp)
  while IFS= read -r line || [[ -n "${line}" ]]; do
    if [[ "$line" == *"${placeholder}"* ]]; then
      cat "$content_file"
    else
      printf '%s\n' "$line"
    fi
  done <"$file" >"$tmp"
  mv "$tmp" "$file"
}

# Load HOST-EMIT-SSOT fragment dialect keys (bash is NON-SSOT; fail closed).
ssot_get() {
  ssot_get_from "$HOST_EMIT_BODY_SSOT" "$1" "HOST-EMIT-SSOT"
}

if [[ ! -f "$HOST_EMIT_BODY_SSOT" ]]; then
  echo "RED ${STAGE_ID}: HOST-EMIT-SSOT artifact missing: ${HOST_EMIT_BODY_SSOT}" >&2
  echo "  (SSoT: SystemsLean.EmitBody.buildFragment; bash is NON-SSOT for fragment)" >&2
  exit 1
fi
if ! grep -q 'HOST-EMIT-SSOT' "$HOST_EMIT_BODY_SSOT" 2>/dev/null; then
  echo "RED ${STAGE_ID}: ${HOST_EMIT_BODY_SSOT} missing greppable HOST-EMIT-SSOT" >&2
  exit 1
fi

SSOT_EMPTY_FRAGMENT=$(ssot_get EMPTY_FRAGMENT)
SSOT_HEADER_OPEN=$(ssot_get HEADER_OPEN)
SSOT_HEADER_E=$(ssot_get HEADER_E)
SSOT_HEADER_CLOSE=$(ssot_get HEADER_CLOSE)
SSOT_TAG_OPEN=$(ssot_get TAG_OPEN)
SSOT_TAG_MULT=$(ssot_get TAG_MULT)
SSOT_TAG_KIND=$(ssot_get TAG_KIND)
SSOT_TAG_CLOSE=$(ssot_get TAG_CLOSE)

# Empty-compose fragment must match Lean emptyComposeFragmentSsot (sans trailing NL).
if [[ "$SSOT_EMPTY_FRAGMENT" != "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */" ]]; then
  echo "RED ${STAGE_ID}: EMPTY_FRAGMENT diverges from EmitBody emptyComposeFragmentSsot" >&2
  echo "  got: ${SSOT_EMPTY_FRAGMENT}" >&2
  exit 1
fi
# Header open must produce EMPTY_FRAGMENT when r=0 e=0.
if [[ "${SSOT_HEADER_OPEN}0${SSOT_HEADER_E}0${SSOT_HEADER_CLOSE}" != "$SSOT_EMPTY_FRAGMENT" ]]; then
  echo "RED ${STAGE_ID}: HEADER_* keys do not recompose EMPTY_FRAGMENT" >&2
  exit 1
fi

# Load HOST-EMIT-MULT Mult product text (bash is NON-SSOT; fail closed).
if [[ ! -f "$HOST_EMIT_MULT_SSOT" ]]; then
  echo "RED ${STAGE_ID}: HOST-EMIT-MULT artifact missing: ${HOST_EMIT_MULT_SSOT}" >&2
  echo "  (SSoT: SystemsLean.EmitMult; bash is NON-SSOT for Mult product text)" >&2
  exit 1
fi
if ! grep -q 'HOST-EMIT-MULT' "$HOST_EMIT_MULT_SSOT" 2>/dev/null; then
  echo "RED ${STAGE_ID}: ${HOST_EMIT_MULT_SSOT} missing greppable HOST-EMIT-MULT" >&2
  exit 1
fi
if ! grep -q 'NON-SSOT' "$HOST_EMIT_MULT_SSOT" 2>/dev/null; then
  echo "RED ${STAGE_ID}: ${HOST_EMIT_MULT_SSOT} missing greppable NON-SSOT" >&2
  exit 1
fi
for tok in MULT-0 MULT-1 MULT-OMEGA slake_mult_is_valid FAIL-CLOSED-UNKNOWN-GRADE; do
  if ! grep -q "$tok" "$HOST_EMIT_MULT_SSOT" 2>/dev/null; then
    echo "RED ${STAGE_ID}: ${HOST_EMIT_MULT_SSOT} missing Mult token ${tok}" >&2
    exit 1
  fi
done

SSOT_MULT_NAME_0=$(ssot_get_from "$HOST_EMIT_MULT_SSOT" MULT_NAME_0 "HOST-EMIT-MULT")
SSOT_MULT_NAME_1=$(ssot_get_from "$HOST_EMIT_MULT_SSOT" MULT_NAME_1 "HOST-EMIT-MULT")
SSOT_MULT_NAME_OMEGA=$(ssot_get_from "$HOST_EMIT_MULT_SSOT" MULT_NAME_OMEGA "HOST-EMIT-MULT")
if [[ "$SSOT_MULT_NAME_0" != "MULT-0" || "$SSOT_MULT_NAME_1" != "MULT-1" || "$SSOT_MULT_NAME_OMEGA" != "MULT-OMEGA" ]]; then
  echo "RED ${STAGE_ID}: HOST-EMIT-MULT MULT_NAME_* diverge from Mult.name" >&2
  echo "  got: ${SSOT_MULT_NAME_0} / ${SSOT_MULT_NAME_1} / ${SSOT_MULT_NAME_OMEGA}" >&2
  exit 1
fi

SSOT_MULT_HEADER_TMP=$(mktemp)
SSOT_MULT_BODY_TMP=$(mktemp)
ssot_block_from "$HOST_EMIT_MULT_SSOT" MULT_C_HEADER "HOST-EMIT-MULT" >"$SSOT_MULT_HEADER_TMP"
ssot_block_from "$HOST_EMIT_MULT_SSOT" MULT_C_BODY "HOST-EMIT-MULT" >"$SSOT_MULT_BODY_TMP"
# Mult blocks must carry greppable product API + HOST-EMIT-MULT ownership.
for f in "$SSOT_MULT_HEADER_TMP" "$SSOT_MULT_BODY_TMP"; do
  for tok in HOST-EMIT-MULT slake_mult_is_valid MULT-0 MULT-1 MULT-OMEGA; do
    if ! grep -q "$tok" "$f" 2>/dev/null; then
      echo "RED ${STAGE_ID}: Mult SSOT block missing token ${tok}" >&2
      rm -f "$SSOT_MULT_HEADER_TMP" "$SSOT_MULT_BODY_TMP"
      exit 1
    fi
  done
done
trap 'rm -f "$SSOT_MULT_HEADER_TMP" "$SSOT_MULT_BODY_TMP"' EXIT

echo "== ${STAGE_ID}: freestanding emit path V0 (${UNIT_TX_ID} / ${UNIT_DEEPEN_ID} / ${CHECKER_ID} / ${HOST_ID} / ${TYPED_IR_ID} / ${IR_PROGRAM_ID} / ${IR_GRAPH_ID} / ${HOST_COMPOSE_ID} / ${EMIT_PLAN_ID} / ${EMIT_APPLY_ID} / ${EMIT_BODY_ID}) =="
echo "  not residual free; not freestanding residual free"
echo "  not PROVABLY; no product GC; not Lean managed runtime"
echo "  never writes out/freestanding-c/ (release surface is separate)"

# Prune package-local .lake / .git (parity with pure Nix unitWalkSkipDirs).
mapfile -t units < <(find src/systems \( -name .lake -o -name .git \) -prune -o -type f \( -name '*.lean' -o -name '*.slake' \) -print 2>/dev/null | sort || true)
us_count=0
for u in "${units[@]:-}"; do
  if [[ -n "${u:-}" ]] && grep -q 'UNIT_SURFACE' "$u" 2>/dev/null; then
    us_count=$((us_count + 1))
  fi
done

if [[ "$us_count" -eq 0 ]]; then
  echo "RED ${STAGE_ID}: no UNIT_SURFACE units; emit requires unit surface first" >&2
  exit 1
fi

if [[ ! -f "$COMPILE_DRIVER" ]]; then
  echo "RED ${STAGE_ID}: compile-path driver missing: $COMPILE_DRIVER" >&2
  exit 1
fi

if [[ -f "$MANIFEST" ]] && grep -q 'stage=SLAKE_COMPILE_PATH_V0' "$MANIFEST" 2>/dev/null \
  && grep -q 'validated:' "$MANIFEST" 2>/dev/null; then
  echo "  compile-path manifest present (SLAKE_COMPILE_PATH_V0); using validated units"
else
  echo "  compile-path manifest missing or incomplete; re-running structure validation"
  if [[ -x "$COMPILE_DRIVER" ]]; then
    ./"$COMPILE_DRIVER"
  else
    bash "$COMPILE_DRIVER"
  fi
  if [[ ! -f "$MANIFEST" ]] || ! grep -q 'stage=SLAKE_COMPILE_PATH_V0' "$MANIFEST" 2>/dev/null; then
    echo "RED ${STAGE_ID}: no validated compile-path units after structure run" >&2
    exit 1
  fi
fi

mkdir -p "$EMIT_DIR"

# First real unit translation: map each UNIT_SURFACE module into freestanding C API.
# Still not residual free; not a full compiler body.
cat >"$HEADER" <<'EOF'
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

/* __HOST_EMIT_MULT_HEADER__ */

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
EOF

cat >"$SOURCE" <<'EOF'
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

/* __HOST_EMIT_MULT_BODY__ */

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

EOF

# EMIT_BODY_V0: embed HOST-EMIT-SSOT dialect (bash NON-SSOT; expanding heredoc).
# put_str format strings come only from SSOT keys loaded above.
cat >>"$SOURCE" <<EOF
/* ---- EMIT_BODY_V0 (freestanding C body fragment; not residual free; not CFG/SSA) ----
 * Builds a fixed-buffer deterministic ASCII fragment via plan + apply APIs.
 * No snprintf/stdlib; manual digit write. Greppable: EMIT_BODY_V0, RUNTIME-FS,
 * EMIT_APPLY_V0, EMIT_PLAN_V0, EMIT-BOUNDARY, HOST-EMIT-SSOT.
 * Fragment dialect: HOST-EMIT-SSOT (SystemsLean.EmitBody.buildFragment +
 * host_emit_body_fragment.ssot.txt); generator bash is NON-SSOT for put_str text.
 */

/* HOST-EMIT-SSOT empty-compose fragment (matches EmitBody.emptyComposeFragmentSsot).
 * Greppable contract text; returned only for honesty / smoke of dialect embed. */
static const char slake_emit_body_empty_ssot[] = "${SSOT_EMPTY_FRAGMENT}\n";

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
  if (slake_emit_body_put_str(out, "${SSOT_HEADER_OPEN}") != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }
  if (slake_emit_body_put_u8(out, plan.runtime_nodes) != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }
  if (slake_emit_body_put_str(out, "${SSOT_HEADER_E}") != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }
  if (slake_emit_body_put_u8(out, plan.erased_nodes) != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }
  if (slake_emit_body_put_str(out, "${SSOT_HEADER_CLOSE}\\n") != 0) {
    slake_emit_body_fail_closed(out);
    return -1;
  }

  /* One line per apply tag: HOST-EMIT-SSOT tI mult=X kind=Y. */
  for (i = 0; i < applied.count; i++) {
    mult = (uint8_t)((applied.tags[i] >> 4) & 0xFu);
    kind = (uint8_t)(applied.tags[i] & 0xFu);
    if (slake_emit_body_put_str(out, "${SSOT_TAG_OPEN}") != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_u8(out, i) != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_str(out, "${SSOT_TAG_MULT}") != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_u8(out, mult) != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_str(out, "${SSOT_TAG_KIND}") != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_u8(out, kind) != 0) {
      slake_emit_body_fail_closed(out);
      return -1;
    }
    if (slake_emit_body_put_str(out, "${SSOT_TAG_CLOSE}\\n") != 0) {
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
EOF

if [[ ! -f "$HEADER" || ! -f "$SOURCE" ]]; then
  echo "RED ${STAGE_ID}: failed to write emit files under ${EMIT_DIR}" >&2
  exit 1
fi

# HOST-EMIT-MULT: embed Mult product text from durable SSOT (bash NON-SSOT).
ssot_embed_placeholder "$HEADER" "__HOST_EMIT_MULT_HEADER__" "$SSOT_MULT_HEADER_TMP" "HOST-EMIT-MULT header"
ssot_embed_placeholder "$SOURCE" "__HOST_EMIT_MULT_BODY__" "$SSOT_MULT_BODY_TMP" "HOST-EMIT-MULT body"
if grep -q '__HOST_EMIT_MULT_' "$HEADER" "$SOURCE" 2>/dev/null; then
  echo "RED ${STAGE_ID}: Mult SSOT placeholders remain after embed" >&2
  exit 1
fi
for f in "$HEADER" "$SOURCE"; do
  if ! grep -q 'HOST-EMIT-MULT' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing HOST-EMIT-MULT after Mult SSOT embed" >&2
    exit 1
  fi
  for tok in MULT-0 MULT-1 MULT-OMEGA slake_mult_is_valid; do
    if ! grep -q "$tok" "$f" 2>/dev/null; then
      echo "RED ${STAGE_ID}: $f missing Mult token ${tok} after embed" >&2
      exit 1
    fi
  done
done

# HOST-EMIT-SSOT: product wire must embed host fragment dialect (bash NON-SSOT).
for f in "$HEADER" "$SOURCE"; do
  if ! grep -q 'HOST-EMIT-SSOT' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing HOST-EMIT-SSOT (fragment dialect honesty)" >&2
    exit 1
  fi
done
if ! grep -Fq "$SSOT_HEADER_OPEN" "$SOURCE" 2>/dev/null; then
  echo "RED ${STAGE_ID}: ${SOURCE} missing SSOT HEADER_OPEN dialect string" >&2
  exit 1
fi
if ! grep -Fq "$SSOT_EMPTY_FRAGMENT" "$SOURCE" 2>/dev/null; then
  echo "RED ${STAGE_ID}: ${SOURCE} missing EMPTY_FRAGMENT reference from HOST-EMIT-SSOT" >&2
  exit 1
fi

for f in "$HEADER" "$SOURCE"; do
  if ! grep -q 'SLAKE_EMIT_FREESTANDING_C_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing stage id" >&2
    exit 1
  fi
  if ! grep -q 'UNIT_TRANSLATION_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing UNIT_TRANSLATION_V0" >&2
    exit 1
  fi
  if ! grep -q 'UNIT_DEEPEN_V1' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing UNIT_DEEPEN_V1" >&2
    exit 1
  fi
  if ! grep -q 'FAIL_CLOSED_CHECKER_V1' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing FAIL_CLOSED_CHECKER_V1" >&2
    exit 1
  fi
  if ! grep -q 'CONSUME_TOKEN_HOST_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing CONSUME_TOKEN_HOST_V0" >&2
    exit 1
  fi
  if ! grep -q 'TYPED_IR_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing TYPED_IR_V0" >&2
    exit 1
  fi
  if ! grep -q 'IR_PROGRAM_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing IR_PROGRAM_V0" >&2
    exit 1
  fi
  if ! grep -q 'IR_GRAPH_EDGES_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing IR_GRAPH_EDGES_V0" >&2
    exit 1
  fi
  if ! grep -q 'HOST_COMPOSE_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing HOST_COMPOSE_V0" >&2
    exit 1
  fi
  if ! grep -q 'EMIT_PLAN_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing EMIT_PLAN_V0" >&2
    exit 1
  fi
  if ! grep -q 'EMIT_APPLY_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing EMIT_APPLY_V0" >&2
    exit 1
  fi
  if ! grep -q 'EMIT_BODY_V0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing EMIT_BODY_V0" >&2
    exit 1
  fi
  if ! grep -q 'JOIN-ALG' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing JOIN-ALG" >&2
    exit 1
  fi
  if ! grep -q 'ConsumeToken' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing ConsumeToken" >&2
    exit 1
  fi
  if ! grep -q 'LINEAR-EXACT-ONCE' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing LINEAR-EXACT-ONCE" >&2
    exit 1
  fi
  if ! grep -q 'RUNTIME-FS' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing RUNTIME-FS" >&2
    exit 1
  fi
  if ! grep -q 'not residual free' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing not residual free honesty" >&2
    exit 1
  fi
  if ! grep -q 'MULT-0' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing MULT-0" >&2
    exit 1
  fi
  if ! grep -q 'MULT-1' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing MULT-1" >&2
    exit 1
  fi
  if ! grep -q 'MULT-OMEGA' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing MULT-OMEGA" >&2
    exit 1
  fi
  for api in slake_mult_is_valid slake_linear_consume slake_erasure_is_runtime_absent \
    slake_check_fail_closed slake_extract_with_checks \
    slake_consume_token_init slake_consume_token_is_live \
    slake_consume_token_mint slake_consume_token_consume \
    slake_consume_token_check_fail_closed slake_consume_token_host_id \
    slake_typed_ir_id slake_ir_node_init slake_ir_node_is_well_typed \
    slake_ir_node_check_fail_closed \
    slake_ir_program_id slake_ir_program_init slake_ir_program_push \
    slake_ir_program_is_well_typed slake_ir_program_check_fail_closed \
    slake_ir_graph_id slake_ir_graph_init slake_ir_graph_push_node \
    slake_ir_graph_add_edge slake_ir_graph_is_well_typed \
    slake_ir_graph_check_fail_closed \
    slake_host_compose_id slake_host_compose_init \
    slake_host_compose_push_node slake_host_compose_add_edge \
    slake_host_compose_mint slake_host_compose_consume \
    slake_host_compose_mark_erased \
    slake_host_compose_is_well_typed slake_host_compose_check_fail_closed \
    slake_host_compose_extract \
    slake_emit_plan_id slake_emit_plan_from_compose slake_emit_plan_is_ready \
    slake_emit_apply_id slake_emit_apply_from_compose slake_emit_apply_is_valid \
    slake_emit_body_id slake_emit_body_from_compose slake_emit_body_is_valid; do
    if ! grep -q "$api" "$f" 2>/dev/null; then
      echo "RED ${STAGE_ID}: $f missing unit deepen API $api" >&2
      exit 1
    fi
  done
  if ! grep -q 'SLAKE_IR_PROGRAM_CAP' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing SLAKE_IR_PROGRAM_CAP" >&2
    exit 1
  fi
  if ! grep -q 'SLAKE_IR_EDGE_MAX' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing SLAKE_IR_EDGE_MAX" >&2
    exit 1
  fi
  if ! grep -q 'SLAKE_EMIT_APPLY_CAP' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing SLAKE_EMIT_APPLY_CAP" >&2
    exit 1
  fi
  if ! grep -q 'SLAKE_EMIT_BODY_CAP' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f missing SLAKE_EMIT_BODY_CAP" >&2
    exit 1
  fi
  if grep -q 'SLAKE_IR_EDGE_CAP' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f still cites SLAKE_IR_EDGE_CAP (use MAX)" >&2
    exit 1
  fi
  if grep -q 'SLAKE_IR_PROGRAM_MAX' "$f" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $f still cites SLAKE_IR_PROGRAM_MAX (use CAP)" >&2
    exit 1
  fi
done

# Smoke: freestanding-friendly compile of generated product C (optional if no cc).
if command -v cc >/dev/null 2>&1; then
  smoke_obj="${EMIT_DIR}/.slake_freestanding_smoke.o"
  smoke_ok=0
  # Prefer pure freestanding flags; stdint from freestanding compiler headers.
  if cc -c -std=c11 -ffreestanding -nostdlib -I"$EMIT_DIR" -o "$smoke_obj" "$SOURCE" 2>/dev/null; then
    smoke_ok=1
    echo "  smoke: cc -c -ffreestanding -nostdlib OK"
  elif cc -c -std=c11 -I"$EMIT_DIR" -o "$smoke_obj" "$SOURCE" 2>/dev/null; then
    smoke_ok=1
    echo "  smoke: cc -c (hosted stdint fallback; still no Lean/GC) OK"
  fi
  rm -f "$smoke_obj"
  if [[ "$smoke_ok" -ne 1 ]]; then
    echo "RED ${STAGE_ID}: freestanding smoke compile failed for ${SOURCE}" >&2
    exit 1
  fi
else
  echo "  smoke: cc not found; skip compile smoke (presence checks remain)"
fi

echo "GREEN ${STAGE_ID}: wrote freestanding emit surface under ${EMIT_DIR}/"
echo "  wrote: ${HEADER}"
echo "  wrote: ${SOURCE}"
echo "  unit translation: ${UNIT_TX_ID} / deepen: ${UNIT_DEEPEN_ID} / checker: ${CHECKER_ID} / host: ${HOST_ID} / typed-ir: ${TYPED_IR_ID} / ir-program: ${IR_PROGRAM_ID} / ir-graph: ${IR_GRAPH_ID} / host-compose: ${HOST_COMPOSE_ID} / emit-plan: ${EMIT_PLAN_ID} / emit-apply: ${EMIT_APPLY_ID} / emit-body: ${EMIT_BODY_ID}"
echo "  not residual free; not PROVABLY; no product GC; not Lean managed runtime"
echo "  release copy via just out-freestanding-c (not this stage)"
exit 0
