/* SPDX-License-Identifier: Unlicense
 *
 * Hosted behavioral smoke for freestanding emit product contracts
 * (UNIT_TRANSLATION_V0 .. EMIT_BODY_V0 / UNIT_DEEPEN_V1).
 *
 * This is test/smoke debt linked against src/systems/emit product C -- not
 * product freestanding residual, not an emit stage, not residual free.
 * Invoked by src/systems/check.sh when cc is available (fail closed if missing).
 */
#include "slake_freestanding.h"

/* Hosted behavioral probe for UNIT_TRANSLATION_V0 / UNIT_DEEPEN_V1 contracts.
 * Return non-zero code = which assert failed (for RED diagnostics).
 */
int main(void)
{
  slake_linear_token tok;
  slake_erased erased;

  /* Mult: unknown grade fail closed; known grades ok.
   * HOST-PARITY-MULT / SELF-HOST-PARITY-MULT / SLAKE_SELF_HOST_PARITY_MULT_V0:
   * product Mult contracts must agree with host Mult.name / isValid / ofNat?
   * (SystemsLean.ParityMult gradeParityOk). PARITY-MULT-SMOKE product side.
   */
  if (slake_mult_is_valid(SLAKE_MULT_0) != 1) {
    return 10;
  }
  if (slake_mult_is_valid(SLAKE_MULT_1) != 1) {
    return 11;
  }
  if (slake_mult_is_valid(SLAKE_MULT_OMEGA) != 1) {
    return 12;
  }
  if (slake_mult_is_valid((enum slake_mult)99) != 0) {
    return 13;
  }
  if (slake_mult_is_known((enum slake_mult)99) != 0) {
    return 14; /* alias must match canonical */
  }
  /* is_known: alias of is_valid. Known grades pair Mult.isValid (closed
   * inductive); unknown tags pair Mult.isValidTag / ofNat? fail-closed
   * (gradeParityOk ofNatRoundTripOk / isValidTagParityOk). */
  if (slake_mult_is_known(SLAKE_MULT_0) != 1) {
    return 15;
  }
  if (slake_mult_is_known(SLAKE_MULT_1) != 1) {
    return 16;
  }
  if (slake_mult_is_known(SLAKE_MULT_OMEGA) != 1) {
    return 17;
  }
  /* slake_mult_name strings == Mult.name (MULT-0 / MULT-1 / MULT-OMEGA). */
  {
    const char *n0 = slake_mult_name(SLAKE_MULT_0);
    const char *n1 = slake_mult_name(SLAKE_MULT_1);
    const char *nOmega = slake_mult_name(SLAKE_MULT_OMEGA);
    const char *nBad = slake_mult_name((enum slake_mult)99);
    if (n0 == 0 || n0[0] != 'M' || n0[1] != 'U' || n0[2] != 'L' || n0[3] != 'T'
        || n0[4] != '-' || n0[5] != '0' || n0[6] != '\0') {
      return 18; /* must be MULT-0 */
    }
    if (n1 == 0 || n1[0] != 'M' || n1[1] != 'U' || n1[2] != 'L' || n1[3] != 'T'
        || n1[4] != '-' || n1[5] != '1' || n1[6] != '\0') {
      return 19; /* must be MULT-1 */
    }
    if (nOmega == 0 || nOmega[0] != 'M' || nOmega[1] != 'U' || nOmega[2] != 'L'
        || nOmega[3] != 'T' || nOmega[4] != '-' || nOmega[5] != 'O'
        || nOmega[6] != 'M' || nOmega[7] != 'E' || nOmega[8] != 'G'
        || nOmega[9] != 'A' || nOmega[10] != '\0') {
      return 106; /* must be MULT-OMEGA */
    }
    if (nBad != 0) {
      return 107; /* unknown fails closed (null) */
    }
    /* Enum tag values match host ofNat? table (0 / 1 / 2). */
    if ((int)SLAKE_MULT_0 != 0 || (int)SLAKE_MULT_1 != 1
        || (int)SLAKE_MULT_OMEGA != 2) {
      return 108;
    }
  }

  /* Linear: id 0 init fail-closed (spent sentinel reserved).
   * HOST-PARITY-LINEAR / SELF-HOST-PARITY-LINEAR /
   * SLAKE_SELF_HOST_PARITY_LINEAR_V0 / PARITY-LINEAR-SMOKE:
   * linear_token init/live/consume + consume_token mint/consume match host
   * KernelLinear / HostCompose contracts (linearHostPathReady exact-once;
   * SystemsLean.ParityLinear linearParityReady / multLinearParityReady).
   * Product side of freestanding Linear path honesty -- no new EMIT_* stage.
   */
  if (slake_linear_token_init(&tok, 0) != -1) {
    return 20;
  }
  if (slake_linear_token_init(&tok, 1) != 0) {
    return 21;
  }
  if (slake_linear_token_is_live(&tok) != 1) {
    return 22;
  }
  if (slake_linear_consume(&tok) != 0) {
    return 23;
  }
  if (slake_linear_token_is_live(&tok) != 0) {
    return 24;
  }
  /* Double consume: documented -2 fail closed (canonical). */
  if (slake_linear_consume(&tok) != -2) {
    return 25;
  }
  /* Alias thin call-through: same -2. */
  if (slake_linear_token_consume(&tok) != -2) {
    return 26;
  }
  /* Null consume. */
  if (slake_linear_consume(0) != -1) {
    return 27;
  }

  /* Erasure: unmarked is NOT runtime-absent; marked is. */
  erased.marked = 0;
  if (slake_erasure_is_runtime_absent(&erased) != 0) {
    return 30;
  }
  if (slake_erased_is_marked(&erased) != 0) {
    return 31;
  }
  if (slake_erased_mark(&erased) != 0) {
    return 32;
  }
  if (slake_erased_is_marked(&erased) != 1) {
    return 33;
  }
  if (slake_erasure_is_runtime_absent(&erased) != 1) {
    return 34;
  }
  if (slake_erasure_is_runtime_absent(0) != 0) {
    return 35;
  }

  /* Extract product runtime is RUNTIME-FS only. */
  if (slake_extract_product_runtime() != SLAKE_RUNTIME_FS) {
    return 40;
  }
  if (slake_extract_status_ok() != (int)SLAKE_EXTRACT_OK) {
    return 41;
  }

  /* Types thin tag. */
  {
    slake_type_tag t;
    if (slake_type_tag_init(&t, 7) != 0) {
      return 50;
    }
    if (slake_type_tag_get(&t) != 7) {
      return 51;
    }
    if (slake_type_tag_init(0, 1) != -1) {
      return 52;
    }
  }

  /* FAIL_CLOSED_CHECKER_V1: composed checks + extract path (check-only; no residual free). */
  {
    slake_check_bundle b;
    enum slake_runtime_class out_rt;
    slake_linear_token live_tok;
    slake_erased er;

    /* 1) MULT-OMEGA + RUNTIME_FS + null linear/erased -> OK + extract OK + out FS */
    b.mult = SLAKE_MULT_OMEGA;
    b.linear = 0;
    b.erased = 0;
    b.claimed_runtime = SLAKE_RUNTIME_FS;
    if (slake_check_fail_closed(&b) != (int)SLAKE_EXTRACT_OK) {
      return 60;
    }
    out_rt = SLAKE_RUNTIME_CLASSIC; /* sentinel before success overwrite */
    if (slake_extract_with_checks(&b, &out_rt) != (int)SLAKE_EXTRACT_OK) {
      return 61;
    }
    if (out_rt != SLAKE_RUNTIME_FS) {
      return 62;
    }

    /* 2) invalid mult cast -> FAIL_CLOSED */
    b.mult = (enum slake_mult)99;
    b.linear = 0;
    b.erased = 0;
    b.claimed_runtime = SLAKE_RUNTIME_FS;
    if (slake_check_fail_closed(&b) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 63;
    }

    /* 3) MULT-1 + null linear -> FAIL_CLOSED */
    b.mult = SLAKE_MULT_1;
    b.linear = 0;
    b.erased = 0;
    b.claimed_runtime = SLAKE_RUNTIME_FS;
    if (slake_check_fail_closed(&b) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 64;
    }

    /* 4) MULT-1 + live token -> OK; after consume live=0, recheck -> FAIL_CLOSED */
    if (slake_linear_token_init(&live_tok, 42) != 0) {
      return 65;
    }
    b.mult = SLAKE_MULT_1;
    b.linear = &live_tok;
    b.erased = 0;
    b.claimed_runtime = SLAKE_RUNTIME_FS;
    if (slake_check_fail_closed(&b) != (int)SLAKE_EXTRACT_OK) {
      return 66;
    }
    if (slake_linear_consume(&live_tok) != 0) {
      return 67;
    }
    if (slake_check_fail_closed(&b) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 68;
    }

    /* 5) MULT-0 + unmarked erased -> FAIL_CLOSED; after mark -> OK */
    er.marked = 0;
    b.mult = SLAKE_MULT_0;
    b.linear = 0;
    b.erased = &er;
    b.claimed_runtime = SLAKE_RUNTIME_FS;
    if (slake_check_fail_closed(&b) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 69;
    }
    if (slake_erased_mark(&er) != 0) {
      return 70;
    }
    if (slake_check_fail_closed(&b) != (int)SLAKE_EXTRACT_OK) {
      return 71;
    }

    /* 6) claimed_runtime CLASSIC -> FAIL_CLOSED even if mult valid */
    b.mult = SLAKE_MULT_OMEGA;
    b.linear = 0;
    b.erased = 0;
    b.claimed_runtime = SLAKE_RUNTIME_CLASSIC;
    if (slake_check_fail_closed(&b) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 72;
    }

    /* null bundle -> FAIL_CLOSED; null out_rt on success path -> FAIL_CLOSED */
    if (slake_check_fail_closed(0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 73;
    }
    b.mult = SLAKE_MULT_OMEGA;
    b.linear = 0;
    b.erased = 0;
    b.claimed_runtime = SLAKE_RUNTIME_FS;
    if (slake_extract_with_checks(&b, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 74;
    }

    /* on fail, leave out_rt untouched */
    out_rt = SLAKE_RUNTIME_CLASSIC;
    b.claimed_runtime = SLAKE_RUNTIME_CLASSIC;
    if (slake_extract_with_checks(&b, &out_rt) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 75;
    }
    if (out_rt != SLAKE_RUNTIME_CLASSIC) {
      return 76;
    }
  }

  /* CONSUME_TOKEN_HOST_V0: mint MULT-1, consume once OK, second fails, mult-1 checker.
   * HOST-PARITY-LINEAR / PARITY-LINEAR-SMOKE product side: HostCompose mint/consume
   * contracts align with slake_consume_token_* (KernelLinear linearHostPathReady;
   * ParityLinear linearContractParityOk). Representation PARTIAL host Bool vs C int.
   */
  {
    slake_consume_token ct;

    if (slake_consume_token_init(0) != -1) {
      return 80;
    }
    if (slake_consume_token_init(&ct) != 0) {
      return 81;
    }
    if (slake_consume_token_is_live(&ct) != 0) {
      return 82;
    }
    /* empty consume fail closed */
    if (slake_consume_token_consume(&ct) != -1) {
      return 83;
    }
    /* empty checker fail closed */
    if (slake_consume_token_check_fail_closed(&ct) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 84;
    }
    /* id 0 mint fail closed */
    if (slake_consume_token_mint(&ct, 0) != -1) {
      return 85;
    }
    /* mint MULT-1 live */
    if (slake_consume_token_mint(&ct, 7) != 0) {
      return 86;
    }
    if (slake_consume_token_is_live(&ct) != 1) {
      return 87;
    }
    /* double mint while live fails closed */
    if (slake_consume_token_mint(&ct, 8) != -2) {
      return 88;
    }
    /* mult-1 checker path OK while live */
    if (slake_consume_token_check_fail_closed(&ct) != (int)SLAKE_EXTRACT_OK) {
      return 89;
    }
    /* host id full string compare (freestanding-safe; no string.h) */
    {
      const char *hid = slake_consume_token_host_id();
      const char *exp = "CONSUME_TOKEN_HOST_V0";
      unsigned i;
      if (hid == 0) {
        return 90;
      }
      for (i = 0; exp[i] != 0; i++) {
        if (hid[i] != exp[i]) {
          return 91;
        }
      }
      if (hid[i] != 0) {
        return 91; /* expect exact match, no trailing junk */
      }
    }
    /* consume once OK */
    if (slake_consume_token_consume(&ct) != 0) {
      return 92;
    }
    if (slake_consume_token_is_live(&ct) != 0) {
      return 93;
    }
    /* second consume fails closed (LINEAR-EXACT-ONCE) */
    if (slake_consume_token_consume(&ct) != -2) {
      return 94;
    }
    /* after spend, mult-1 checker fails closed */
    if (slake_consume_token_check_fail_closed(&ct) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 95;
    }
    /* remint after spent allowed; then check OK again */
    if (slake_consume_token_mint(&ct, 9) != 0) {
      return 96;
    }
    if (slake_consume_token_check_fail_closed(&ct) != (int)SLAKE_EXTRACT_OK) {
      return 97;
    }
    if (slake_consume_token_consume(&ct) != 0) {
      return 98;
    }
    /* Desync heal: bypass host API and spend embedded token while state live.
     * Host consume must return -2, heal state to spent; remint must recover.
     * Direct mutation of embedded token remains out of contract for callers.
     */
    if (slake_consume_token_mint(&ct, 11) != 0) {
      return 99;
    }
    if (slake_linear_consume(&ct.token) != 0) {
      return 100;
    }
    /* is_live must be 0 (token spent even if state still believed live) */
    if (slake_consume_token_is_live(&ct) != 0) {
      return 101;
    }
    if (slake_consume_token_consume(&ct) != -2) {
      return 102;
    }
    /* remint after healed desync */
    if (slake_consume_token_mint(&ct, 12) != 0) {
      return 103;
    }
    if (slake_consume_token_is_live(&ct) != 1) {
      return 104;
    }
    if (slake_consume_token_consume(&ct) != 0) {
      return 105;
    }
  }

  /* TYPED_IR_V0: richer typed IR surface (kind/mult pairing; not residual free).
   * HOST-PARITY-TYPES / SELF-HOST-PARITY-TYPES /
   * SLAKE_SELF_HOST_PARITY_TYPES_V0 / PARITY-TYPES-SMOKE:
   * typed_ir id + ir_node init/well_typed/check_fail_closed match host
   * KernelTypes contracts (typesKernelReady / typesProgramPathReady /
   * kindMultMismatchRejected; SystemsLean.ParityTypes typesParityReady /
   * multLinearTypesParityReady). Product side of freestanding Types path
   * honesty -- Mult+Linear+Types freestanding path; no new EMIT_* stage.
   */
  {
    slake_ir_node node;
    slake_linear_token live_tok;
    slake_erased er;
    const char *tid;
    const char *exp = "TYPED_IR_V0";
    unsigned i;

    /* id string exact match (or at least starts with TYPED_IR) */
    tid = slake_typed_ir_id();
    if (tid == 0) {
      return 110;
    }
    for (i = 0; exp[i] != 0; i++) {
      if (tid[i] != exp[i]) {
        return 111;
      }
    }
    if (tid[i] != 0) {
      return 111;
    }

    /* null node fail closed */
    if (slake_ir_node_init(0, 1, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != -1) {
      return 112;
    }
    if (slake_ir_node_is_well_typed(0) != 0) {
      return 113;
    }
    if (slake_ir_node_check_fail_closed(0, 0, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 114;
    }

    /* MULT-OMEGA + VALUE kind OK */
    if (slake_ir_node_init(&node, 3, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != 0) {
      return 115;
    }
    if (slake_ir_node_is_well_typed(&node) != 1) {
      return 116;
    }
    /* OMEGA check may pass with null linear/erased */
    if (slake_ir_node_check_fail_closed(&node, 0, 0) != (int)SLAKE_EXTRACT_OK) {
      return 117;
    }

    /* MULT-1 + LINEAR kind OK; MULT-1 + VALUE kind fail closed */
    if (slake_ir_node_init(&node, 4, SLAKE_MULT_1, SLAKE_IR_KIND_LINEAR) != 0) {
      return 118;
    }
    if (slake_ir_node_is_well_typed(&node) != 1) {
      return 119;
    }
    if (slake_ir_node_init(&node, 4, SLAKE_MULT_1, SLAKE_IR_KIND_VALUE) != -1) {
      return 120;
    }
    if (slake_ir_node_is_well_typed(&node) != 0) {
      return 121; /* left invalid after fail */
    }

    /* MULT-0 + ERASED kind OK; MULT-0 + LINEAR fail closed */
    if (slake_ir_node_init(&node, 5, SLAKE_MULT_0, SLAKE_IR_KIND_ERASED) != 0) {
      return 122;
    }
    if (slake_ir_node_is_well_typed(&node) != 1) {
      return 123;
    }
    if (slake_ir_node_init(&node, 5, SLAKE_MULT_0, SLAKE_IR_KIND_LINEAR) != -1) {
      return 124;
    }
    if (slake_ir_node_is_well_typed(&node) != 0) {
      return 125;
    }

    /* invalid mult fail closed */
    if (slake_ir_node_init(&node, 6, (enum slake_mult)99, SLAKE_IR_KIND_VALUE) != -1) {
      return 126;
    }
    if (slake_ir_node_is_well_typed(&node) != 0) {
      return 127;
    }

    /* IR node check composes FAIL_CLOSED_CHECKER_V1 with live linear for MULT-1 */
    if (slake_ir_node_init(&node, 7, SLAKE_MULT_1, SLAKE_IR_KIND_LINEAR) != 0) {
      return 128;
    }
    if (slake_linear_token_init(&live_tok, 21) != 0) {
      return 129;
    }
    if (slake_ir_node_check_fail_closed(&node, 0, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 130; /* MULT-1 needs live linear */
    }
    if (slake_ir_node_check_fail_closed(&node, &live_tok, 0) != (int)SLAKE_EXTRACT_OK) {
      return 131;
    }
    /* MULT-0 needs marked erased */
    if (slake_ir_node_init(&node, 8, SLAKE_MULT_0, SLAKE_IR_KIND_ERASED) != 0) {
      return 132;
    }
    er.marked = 0;
    if (slake_ir_node_check_fail_closed(&node, 0, &er) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 133;
    }
    if (slake_erased_mark(&er) != 0) {
      return 134;
    }
    if (slake_ir_node_check_fail_closed(&node, 0, &er) != (int)SLAKE_EXTRACT_OK) {
      return 135;
    }
  }

  /* IR_PROGRAM_V0: multi-node ordered program (not CFG; not residual free).
   * HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM /
   * SLAKE_SELF_HOST_PARITY_PROGRAM_V0 / PARITY-PROGRAM-SMOKE:
   * program init/push/well_typed/check_fail_closed match host KernelProgram
   * contracts (programKernelReady / programPathReady; SystemsLean.ParityProgram
   * programParityReady / multLinearTypesProgramParityReady). Product side of
   * freestanding Program path honesty -- Mult+Linear+Types+Program freestanding
   * path; no new EMIT_* stage.
   * Product contract: SLAKE_IR_PROGRAM_CAP; empty NOT well-typed (fail closed);
   * push full returns -2 (distinct from -1 null/bad).
   */
  {
    slake_ir_program prog;
    slake_linear_token live_tok;
    slake_erased er;
    const char *pid;
    const char *pexp = "IR_PROGRAM_V0";
    unsigned i;
    uint8_t saved_count;

    pid = slake_ir_program_id();
    if (pid == 0) {
      return 140;
    }
    for (i = 0; pexp[i] != 0; i++) {
      if (pid[i] != pexp[i]) {
        return 141;
      }
    }
    if (pid[i] != 0) {
      return 141;
    }

    if (slake_ir_program_init(0) != -1) {
      return 142;
    }
    if (slake_ir_program_push(0, 1, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != -1) {
      return 143;
    }
    if (slake_ir_program_is_well_typed(0) != 0) {
      return 144;
    }
    if (slake_ir_program_check_fail_closed(0, 0, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 145;
    }

    /* empty program: NOT well-typed; fail closed */
    if (slake_ir_program_init(&prog) != 0) {
      return 146;
    }
    if (slake_ir_program_is_well_typed(&prog) != 0) {
      return 147;
    }
    if (slake_ir_program_check_fail_closed(&prog, 0, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 148;
    }

    if (slake_ir_program_push(&prog, 10, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != 0) {
      return 149;
    }
    if (slake_ir_program_is_well_typed(&prog) != 1) {
      return 150;
    }
    if (prog.count != 1) {
      return 151;
    }
    if (slake_ir_program_check_fail_closed(&prog, 0, 0) != (int)SLAKE_EXTRACT_OK) {
      return 152;
    }

    saved_count = prog.count;
    if (slake_ir_program_push(&prog, 11, SLAKE_MULT_1, SLAKE_IR_KIND_VALUE) != -1) {
      return 153;
    }
    if (prog.count != saved_count) {
      return 154;
    }
    /* Failed push must not half-write the next slot (temp-init design). */
    if (prog.nodes[saved_count].valid != 0) {
      return 155;
    }
    if (slake_ir_program_is_well_typed(&prog) != 1) {
      return 156;
    }

    if (slake_ir_program_push(&prog, 12, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != 0) {
      return 157;
    }
    if (slake_ir_program_push(&prog, 13, SLAKE_MULT_1, SLAKE_IR_KIND_LINEAR) != 0) {
      return 158;
    }
    if (prog.count != 3) {
      return 159;
    }
    if (slake_ir_program_is_well_typed(&prog) != 1) {
      return 160;
    }

    if (slake_ir_program_check_fail_closed(&prog, 0, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 161;
    }
    if (slake_linear_token_init(&live_tok, 42) != 0) {
      return 162;
    }
    if (slake_ir_program_check_fail_closed(&prog, &live_tok, 0) != (int)SLAKE_EXTRACT_OK) {
      return 163;
    }

    if (slake_ir_program_push(&prog, 14, SLAKE_MULT_0, SLAKE_IR_KIND_ERASED) != 0) {
      return 164;
    }
    er.marked = 0;
    if (slake_ir_program_check_fail_closed(&prog, &live_tok, &er)
        != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 165;
    }
    if (slake_erased_mark(&er) != 0) {
      return 166;
    }
    if (slake_ir_program_check_fail_closed(&prog, &live_tok, &er)
        != (int)SLAKE_EXTRACT_OK) {
      return 167;
    }

    if (slake_ir_program_init(&prog) != 0) {
      return 168;
    }
    for (i = 0; i < (unsigned)SLAKE_IR_PROGRAM_CAP; i++) {
      if (slake_ir_program_push(&prog, (uint32_t)(20 + i),
                                SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != 0) {
        return 169;
      }
    }
    if (prog.count != (uint8_t)SLAKE_IR_PROGRAM_CAP) {
      return 170;
    }
    /* Full push returns -2 (distinct from -1 null/bad); count unchanged. */
    if (slake_ir_program_push(&prog, 99, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != -2) {
      return 171;
    }
    if (prog.count != (uint8_t)SLAKE_IR_PROGRAM_CAP) {
      return 172;
    }
    if (slake_ir_program_is_well_typed(&prog) != 1) {
      return 173;
    }
    if (slake_ir_program_check_fail_closed(&prog, 0, 0) != (int)SLAKE_EXTRACT_OK) {
      return 174;
    }
  }

  /* IR_GRAPH_EDGES_V0: graph edges over ordered IR program (not residual free).
   * HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM /
   * SLAKE_SELF_HOST_PARITY_PROGRAM_V0 / PARITY-PROGRAM-SMOKE:
   * graph init/push_node/add_edge match host KernelProgram programGraphPathReady
   * (EMPTY-GRAPH-OK / IR-GRAPH-EDGES); freestanding Program path honesty labels.
   * Product contract: SLAKE_IR_EDGE_MAX; empty edges OK; empty graph well-typed + check OK;
   * endpoints < prog.count; failed add leaves edge_count and half-valid edge slot unchanged.
   * Full edges return -1 (same class as null/invalid/out-of-range).
   */
  {
    slake_ir_graph graph;
    slake_linear_token live_tok;
    slake_erased er;
    const char *gid;
    const char *gexp = "IR_GRAPH_EDGES_V0";
    unsigned i;
    uint8_t saved_edges;

    gid = slake_ir_graph_id();
    if (gid == 0) {
      return 175;
    }
    for (i = 0; gexp[i] != 0; i++) {
      if (gid[i] != gexp[i]) {
        return 176;
      }
    }
    if (gid[i] != 0) {
      return 176;
    }

    /* null graph fail closed */
    if (slake_ir_graph_init(0) != -1) {
      return 177;
    }
    if (slake_ir_graph_push_node(0, 1, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != -1) {
      return 178;
    }
    if (slake_ir_graph_add_edge(0, 0, 0) != -1) {
      return 179;
    }
    if (slake_ir_graph_is_well_typed(0) != 0) {
      return 180;
    }
    if (slake_ir_graph_check_fail_closed(0, 0, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 181;
    }

    /* init empty graph (no nodes, no edges): well-typed; check OK.
     * Distinct from "empty edges with nodes present" (asserted after push).
     */
    if (slake_ir_graph_init(&graph) != 0) {
      return 182;
    }
    if (graph.edge_count != 0 || graph.valid != 1) {
      return 183;
    }
    if (slake_ir_graph_is_well_typed(&graph) != 1) {
      return 184;
    }
    if (slake_ir_graph_check_fail_closed(&graph, 0, 0) != (int)SLAKE_EXTRACT_OK) {
      return 185;
    }

    /* push 2+ nodes; empty edges OK with nodes (before any add_edge) */
    if (slake_ir_graph_push_node(&graph, 30, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != 0) {
      return 186;
    }
    if (slake_ir_graph_push_node(&graph, 31, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != 0) {
      return 187;
    }
    if (graph.prog.count != 2) {
      return 188;
    }
    if (graph.edge_count != 0) {
      return 189;
    }
    if (slake_ir_graph_is_well_typed(&graph) != 1) {
      return 190;
    }
    if (slake_ir_graph_check_fail_closed(&graph, 0, 0) != (int)SLAKE_EXTRACT_OK) {
      return 191;
    }

    /* add edge 0->1 OK; well-typed with edges */
    if (slake_ir_graph_add_edge(&graph, 0, 1) != 0) {
      return 192;
    }
    if (graph.edge_count != 1) {
      return 193;
    }
    if (graph.edges[0].from != 0 || graph.edges[0].to != 1 || graph.edges[0].valid != 1) {
      return 194;
    }
    if (slake_ir_graph_is_well_typed(&graph) != 1) {
      return 195;
    }
    if (slake_ir_graph_check_fail_closed(&graph, 0, 0) != (int)SLAKE_EXTRACT_OK) {
      return 196;
    }

    /* endpoints out of range: -1; edge_count preserved; no half-valid edge */
    saved_edges = graph.edge_count;
    if (slake_ir_graph_add_edge(&graph, 0, 2) != -1) {
      return 197;
    }
    if (graph.edge_count != saved_edges) {
      return 198;
    }
    if (graph.edges[saved_edges].valid != 0) {
      return 199;
    }
    if (slake_ir_graph_add_edge(&graph, 5, 0) != -1) {
      return 200;
    }
    if (graph.edge_count != saved_edges) {
      return 201;
    }
    if (graph.edges[saved_edges].valid != 0) {
      return 202;
    }

    /* MULT-1 node needs live linear; MULT-0 needs marked erased */
    if (slake_ir_graph_push_node(&graph, 32, SLAKE_MULT_1, SLAKE_IR_KIND_LINEAR) != 0) {
      return 203;
    }
    if (slake_ir_graph_add_edge(&graph, 1, 2) != 0) {
      return 204;
    }
    if (slake_ir_graph_is_well_typed(&graph) != 1) {
      return 205;
    }
    if (slake_ir_graph_check_fail_closed(&graph, 0, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 206;
    }
    if (slake_linear_token_init(&live_tok, 77) != 0) {
      return 207;
    }
    if (slake_ir_graph_check_fail_closed(&graph, &live_tok, 0) != (int)SLAKE_EXTRACT_OK) {
      return 208;
    }
    if (slake_ir_graph_push_node(&graph, 33, SLAKE_MULT_0, SLAKE_IR_KIND_ERASED) != 0) {
      return 209;
    }
    er.marked = 0;
    if (slake_ir_graph_check_fail_closed(&graph, &live_tok, &er)
        != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 210;
    }
    if (slake_erased_mark(&er) != 0) {
      return 211;
    }
    if (slake_ir_graph_check_fail_closed(&graph, &live_tok, &er)
        != (int)SLAKE_EXTRACT_OK) {
      return 212;
    }

    /* fill edges to MAX then add fails -1; edge_count preserved */
    if (slake_ir_graph_init(&graph) != 0) {
      return 213;
    }
    if (slake_ir_graph_push_node(&graph, 40, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != 0) {
      return 214;
    }
    if (slake_ir_graph_push_node(&graph, 41, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != 0) {
      return 215;
    }
    for (i = 0; i < (unsigned)SLAKE_IR_EDGE_MAX; i++) {
      if (slake_ir_graph_add_edge(&graph, 0, 1) != 0) {
        return 216;
      }
    }
    if (graph.edge_count != (uint8_t)SLAKE_IR_EDGE_MAX) {
      return 217;
    }
    saved_edges = graph.edge_count;
    if (slake_ir_graph_add_edge(&graph, 0, 1) != -1) {
      return 218;
    }
    if (graph.edge_count != saved_edges) {
      return 219;
    }
    if (slake_ir_graph_is_well_typed(&graph) != 1) {
      return 220;
    }
    if (slake_ir_graph_check_fail_closed(&graph, 0, 0) != (int)SLAKE_EXTRACT_OK) {
      return 221;
    }
  }

  /* HOST_COMPOSE_V0: host + IR graph composition for fail-closed extract.
   * HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM /
   * SLAKE_SELF_HOST_PARITY_PROGRAM_V0 / PARITY-PROGRAM-SMOKE:
   * host_compose init/mint/consume match host KernelProgram
   * programComposePathReady (HOST-COMPOSE); freestanding Program path honesty.
   * Exact id match; empty compose well-typed; MULT-1 needs mint; MULT-0 needs mark;
   * extract null out_rt FAIL_CLOSED; fail path leaves out_rt untouched; edge path OK.
   * Not residual free; not full CFG/SSA. Assert codes 230-276 unique per step.
   */
  {
    slake_host_compose hc;
    enum slake_runtime_class out_rt;
    const char *cid;
    const char *cexp = "HOST_COMPOSE_V0";
    unsigned i;

    cid = slake_host_compose_id();
    if (cid == 0) {
      return 230;
    }
    /* exact entire string match (not prefix-only) */
    for (i = 0; cexp[i] != 0; i++) {
      if (cid[i] != cexp[i]) {
        return 231;
      }
    }
    if (cid[i] != 0) {
      return 231;
    }

    /* null compose fail closed (unique codes per API) */
    if (slake_host_compose_init(0) != -1) {
      return 232;
    }
    if (slake_host_compose_is_well_typed(0) != 0) {
      return 233;
    }
    if (slake_host_compose_check_fail_closed(0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 234;
    }
    if (slake_host_compose_extract(0, &out_rt) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 235;
    }
    if (slake_host_compose_push_node(0, 1, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE) != -1) {
      return 236;
    }
    if (slake_host_compose_add_edge(0, 0, 0) != -1) {
      return 237;
    }
    if (slake_host_compose_mint(0, 1) != -1) {
      return 238;
    }
    if (slake_host_compose_consume(0) != -1) {
      return 239;
    }
    if (slake_host_compose_mark_erased(0) != -1) {
      return 240;
    }

    /* init empty: well-typed; check OK; extract -> RUNTIME_FS */
    if (slake_host_compose_init(&hc) != 0) {
      return 241;
    }
    if (hc.valid != 1 || hc.erased.marked != 0) {
      return 242;
    }
    if (slake_host_compose_is_well_typed(&hc) != 1) {
      return 243;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_OK) {
      return 244;
    }
    out_rt = SLAKE_RUNTIME_CLASSIC; /* poison; extract must overwrite */
    if (slake_host_compose_extract(&hc, &out_rt) != (int)SLAKE_EXTRACT_OK) {
      return 245;
    }
    if (out_rt != SLAKE_RUNTIME_FS) {
      return 246;
    }

    /* push MULT-OMEGA VALUE: check OK without mint */
    if (slake_host_compose_push_node(&hc, 50, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE)
        != 0) {
      return 247;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_OK) {
      return 248;
    }
    if (slake_host_compose_extract(&hc, &out_rt) != (int)SLAKE_EXTRACT_OK) {
      return 249;
    }
    if (out_rt != SLAKE_RUNTIME_FS) {
      return 250;
    }

    /* push MULT-1 LINEAR without mint: FAIL_CLOSED; fail path leaves out_rt poison */
    if (slake_host_compose_push_node(&hc, 51, SLAKE_MULT_1, SLAKE_IR_KIND_LINEAR)
        != 0) {
      return 251;
    }
    if (slake_host_compose_is_well_typed(&hc) != 1) {
      return 252;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 253;
    }
    out_rt = SLAKE_RUNTIME_CLASSIC; /* poison; fail must leave untouched */
    if (slake_host_compose_extract(&hc, &out_rt) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 254;
    }
    if (out_rt != SLAKE_RUNTIME_CLASSIC) {
      return 255;
    }
    /* after mint: OK */
    if (slake_host_compose_mint(&hc, 91) != 0) {
      return 256;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_OK) {
      return 257;
    }
    /* consume then MULT-1 fails closed again; remint restores OK */
    if (slake_host_compose_consume(&hc) != 0) {
      return 258;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 259;
    }
    if (slake_host_compose_mint(&hc, 92) != 0) {
      return 260;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_OK) {
      return 261;
    }

    /* push MULT-0 ERASED without mark: FAIL_CLOSED; after mark_erased: OK */
    if (slake_host_compose_push_node(&hc, 52, SLAKE_MULT_0, SLAKE_IR_KIND_ERASED)
        != 0) {
      return 262;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 263;
    }
    if (slake_host_compose_mark_erased(&hc) != 0) {
      return 264;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_OK) {
      return 265;
    }
    if (slake_host_compose_extract(&hc, &out_rt) != (int)SLAKE_EXTRACT_OK) {
      return 266;
    }
    if (out_rt != SLAKE_RUNTIME_FS) {
      return 267;
    }

    /* extract null out_rt FAIL_CLOSED when would succeed */
    if (slake_host_compose_extract(&hc, 0) != (int)SLAKE_EXTRACT_FAIL_CLOSED) {
      return 268;
    }

    /* graph edge path: push 2 nodes, add_edge 0->1, compose still OK with right mults */
    if (slake_host_compose_init(&hc) != 0) {
      return 269;
    }
    if (slake_host_compose_push_node(&hc, 60, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE)
        != 0) {
      return 270;
    }
    if (slake_host_compose_push_node(&hc, 61, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE)
        != 0) {
      return 271;
    }
    if (slake_host_compose_add_edge(&hc, 0, 1) != 0) {
      return 272;
    }
    if (hc.graph.edge_count != 1) {
      return 273;
    }
    if (slake_host_compose_is_well_typed(&hc) != 1) {
      return 274;
    }
    if (slake_host_compose_check_fail_closed(&hc) != (int)SLAKE_EXTRACT_OK) {
      return 275;
    }
    if (slake_host_compose_extract(&hc, &out_rt) != (int)SLAKE_EXTRACT_OK) {
      return 276;
    }
    if (out_rt != SLAKE_RUNTIME_FS) {
      return 277;
    }
  }

  /* EMIT_PLAN_V0: emit plan from host compose (readiness inventory; not CFG/SSA).
   * Exact id match; empty plan OK; fail closed zeros out; runtime/erased counts;
   * edge_count reflects graph; is_ready null/invalid 0. Assert codes 280-312 unique.
   * HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT /
   * SLAKE_SELF_HOST_PARITY_EMIT_V0 / PARITY-EMIT-SMOKE: freestanding Emit path
   * honesty labels (Mult+Linear+Types+Program+Emit); existing test only -- no
   * new EMIT_* C residual stage.
   * Not residual free. Not full product emit of IR bodies.
   */
  {
    slake_host_compose hc;
    slake_emit_plan plan;
    const char *pid;
    const char *pexp = "EMIT_PLAN_V0";
    unsigned i;

    pid = slake_emit_plan_id();
    if (pid == 0) {
      return 280;
    }
    /* exact entire string match (not prefix-only) */
    for (i = 0; pexp[i] != 0; i++) {
      if (pid[i] != pexp[i]) {
        return 281;
      }
    }
    if (pid[i] != 0) {
      return 281;
    }

    /* null hc or null out -> -1 */
    if (slake_emit_plan_from_compose(0, &plan) != -1) {
      return 282;
    }
    if (slake_emit_plan_from_compose((const slake_host_compose *)0, 0) != -1) {
      return 283;
    }
    if (slake_host_compose_init(&hc) != 0) {
      return 284;
    }
    if (slake_emit_plan_from_compose(&hc, 0) != -1) {
      return 285;
    }

    /* empty compose after init: plan ok, all counts 0, ready 1, valid 1; is_ready 1 */
    if (slake_emit_plan_from_compose(&hc, &plan) != 0) {
      return 286;
    }
    if (plan.node_count != 0 || plan.edge_count != 0
        || plan.runtime_nodes != 0 || plan.erased_nodes != 0) {
      return 287;
    }
    if (plan.ready != 1 || plan.valid != 1) {
      return 288;
    }
    if (slake_emit_plan_is_ready(&plan) != 1) {
      return 289;
    }

    /* push OMEGA + LINEAR without mint: from_compose fails; out.valid=0 zeroed */
    if (slake_host_compose_push_node(&hc, 70, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE)
        != 0) {
      return 290;
    }
    if (slake_host_compose_push_node(&hc, 71, SLAKE_MULT_1, SLAKE_IR_KIND_LINEAR)
        != 0) {
      return 291;
    }
    plan.valid = 1; /* poison; failure must clear */
    plan.node_count = 99;
    plan.edge_count = 99;
    plan.runtime_nodes = 99;
    plan.erased_nodes = 99;
    plan.ready = 1;
    if (slake_emit_plan_from_compose(&hc, &plan) != -1) {
      return 292;
    }
    if (plan.valid != 0 || plan.ready != 0
        || plan.node_count != 0 || plan.edge_count != 0
        || plan.runtime_nodes != 0 || plan.erased_nodes != 0) {
      return 293;
    }
    if (slake_emit_plan_is_ready(&plan) != 0) {
      return 294;
    }

    /* mint then plan: node_count 2, runtime_nodes 2, erased 0, ready 1 */
    if (slake_host_compose_mint(&hc, 101) != 0) {
      return 295;
    }
    if (slake_emit_plan_from_compose(&hc, &plan) != 0) {
      return 296;
    }
    if (plan.node_count != 2 || plan.edge_count != 0
        || plan.runtime_nodes != 2 || plan.erased_nodes != 0) {
      return 297;
    }
    if (plan.ready != 1 || plan.valid != 1) {
      return 298;
    }
    if (slake_emit_plan_is_ready(&plan) != 1) {
      return 299;
    }

    /* MULT-0 without mark: fail; mark_erased then plan: erased 1, runtime still 2 */
    if (slake_host_compose_push_node(&hc, 72, SLAKE_MULT_0, SLAKE_IR_KIND_ERASED)
        != 0) {
      return 300;
    }
    plan.valid = 1; /* poison; failure must clear all fields */
    plan.node_count = 99;
    plan.edge_count = 99;
    plan.runtime_nodes = 99;
    plan.erased_nodes = 99;
    plan.ready = 1;
    if (slake_emit_plan_from_compose(&hc, &plan) != -1) {
      return 301;
    }
    if (plan.valid != 0 || plan.ready != 0
        || plan.node_count != 0 || plan.edge_count != 0
        || plan.runtime_nodes != 0 || plan.erased_nodes != 0) {
      return 302;
    }
    if (slake_host_compose_mark_erased(&hc) != 0) {
      return 303;
    }
    if (slake_emit_plan_from_compose(&hc, &plan) != 0) {
      return 304;
    }
    if (plan.node_count != 3 || plan.erased_nodes != 1 || plan.runtime_nodes != 2) {
      return 305;
    }
    if (plan.ready != 1 || plan.valid != 1) {
      return 306;
    }

    /* edge: add_edge; plan edge_count reflects it */
    if (slake_host_compose_add_edge(&hc, 0, 1) != 0) {
      return 307;
    }
    if (slake_emit_plan_from_compose(&hc, &plan) != 0) {
      return 308;
    }
    if (plan.edge_count != 1 || plan.node_count != 3) {
      return 309;
    }

    /* is_ready null -> 0; invalid plan -> 0 */
    if (slake_emit_plan_is_ready(0) != 0) {
      return 310;
    }
    plan.valid = 0;
    plan.ready = 1;
    if (slake_emit_plan_is_ready(&plan) != 0) {
      return 311;
    }
    plan.valid = 1;
    plan.ready = 0;
    if (slake_emit_plan_is_ready(&plan) != 0) {
      return 312;
    }
  }

  /* EMIT_APPLY_V0: apply plan tags from host compose (fixed buffer; not full C body).
   * HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT /
   * SLAKE_SELF_HOST_PARITY_EMIT_V0 / PARITY-EMIT-SMOKE: freestanding Emit path
   * honesty labels (Mult+Linear+Types+Program+Emit); existing test only -- no
   * new EMIT_* C residual stage.
   * Exact id match; empty apply OK count=0 valid=1; OMEGA VALUE tag pack; MULT-1
   * without mint fails closed; mint then MULT-1 apply OK; null args fail closed.
   * Assert codes 320-349 unique. Not residual free. Not CFG/SSA.
   */
  {
    slake_host_compose hc;
    slake_emit_apply applied;
    const char *aid;
    const char *aexp = "EMIT_APPLY_V0";
    unsigned i;
    uint8_t expect_tag;

    aid = slake_emit_apply_id();
    if (aid == 0) {
      return 320;
    }
    /* exact entire string match (not prefix-only) */
    for (i = 0; aexp[i] != 0; i++) {
      if (aid[i] != aexp[i]) {
        return 321;
      }
    }
    if (aid[i] != 0) {
      return 321;
    }

    /* null hc or null out -> -1 */
    if (slake_emit_apply_from_compose(0, &applied) != -1) {
      return 322;
    }
    if (slake_emit_apply_from_compose((const slake_host_compose *)0, 0) != -1) {
      return 323;
    }
    if (slake_host_compose_init(&hc) != 0) {
      return 324;
    }
    if (slake_emit_apply_from_compose(&hc, 0) != -1) {
      return 325;
    }

    /* empty ready compose: apply ok count=0 valid=1; is_valid 1 */
    if (slake_emit_apply_from_compose(&hc, &applied) != 0) {
      return 326;
    }
    if (applied.count != 0 || applied.valid != 1) {
      return 327;
    }
    if (slake_emit_apply_is_valid(&applied) != 1) {
      return 328;
    }

    /* push OMEGA VALUE: apply count=1; tag packs mult high + kind low */
    if (slake_host_compose_push_node(&hc, 80, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE)
        != 0) {
      return 329;
    }
    if (slake_emit_apply_from_compose(&hc, &applied) != 0) {
      return 330;
    }
    if (applied.count != 1 || applied.valid != 1) {
      return 331;
    }
    /* MULT_OMEGA=2, VALUE=0 -> 0x20 */
    expect_tag = (uint8_t)((((unsigned)SLAKE_MULT_OMEGA & 0xFu) << 4)
        | ((unsigned)SLAKE_IR_KIND_VALUE & 0xFu));
    if (applied.tags[0] != expect_tag) {
      return 332;
    }
    if (slake_emit_apply_is_valid(&applied) != 1) {
      return 333;
    }

    /* MULT-1 without mint -> apply fails closed; valid=0 count=0 */
    if (slake_host_compose_push_node(&hc, 81, SLAKE_MULT_1, SLAKE_IR_KIND_LINEAR)
        != 0) {
      return 334;
    }
    applied.valid = 1; /* poison; failure must clear */
    applied.count = 99;
    if (slake_emit_apply_from_compose(&hc, &applied) != -1) {
      return 335;
    }
    if (applied.valid != 0 || applied.count != 0) {
      return 336;
    }
    if (slake_emit_apply_is_valid(&applied) != 0) {
      return 337;
    }

    /* mint + MULT-1 apply OK: count=2; tags encode OMEGA/VALUE and MULT_1/LINEAR */
    if (slake_host_compose_mint(&hc, 111) != 0) {
      return 338;
    }
    if (slake_emit_apply_from_compose(&hc, &applied) != 0) {
      return 339;
    }
    if (applied.count != 2 || applied.valid != 1) {
      return 340;
    }
    expect_tag = (uint8_t)((((unsigned)SLAKE_MULT_OMEGA & 0xFu) << 4)
        | ((unsigned)SLAKE_IR_KIND_VALUE & 0xFu));
    if (applied.tags[0] != expect_tag) {
      return 341;
    }
    expect_tag = (uint8_t)((((unsigned)SLAKE_MULT_1 & 0xFu) << 4)
        | ((unsigned)SLAKE_IR_KIND_LINEAR & 0xFu));
    if (applied.tags[1] != expect_tag) {
      return 342;
    }

    /* is_valid null -> 0; invalid apply -> 0 */
    if (slake_emit_apply_is_valid(0) != 0) {
      return 343;
    }
    applied.valid = 0;
    if (slake_emit_apply_is_valid(&applied) != 0) {
      return 344;
    }
  }

  /* EMIT_BODY_V0: freestanding C body fragment from host compose (not residual free).
   * Exact id match; empty body ok r=0 e=0 with EMIT_BODY_V0 + RUNTIME-FS; MULT-1 without
   * mint fails closed (out zeroed); mint + OMEGA + LINEAR lists tags; MULT-0 with mark
   * raises e. Assert codes 350-388 unique. Not CFG/SSA. Not full product module emit.
   * BODY_CAP overflow not smoked: defensive under PROGRAM_CAP 8 (see CAP honesty).
   * HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT /
   * SLAKE_SELF_HOST_PARITY_EMIT_V0 / PARITY-EMIT-SMOKE: freestanding Emit path
   * honesty labels (Mult+Linear+Types+Program+Emit); existing test only -- no
   * new EMIT_* C residual stage.
   */
  {
    slake_host_compose hc;
    slake_emit_body body;
    const char *bid;
    const char *bexp = "EMIT_BODY_V0";
    unsigned i;
    unsigned j;
    int found;

    bid = slake_emit_body_id();
    if (bid == 0) {
      return 350;
    }
    /* exact entire string match (not prefix-only) */
    for (i = 0; bexp[i] != 0; i++) {
      if (bid[i] != bexp[i]) {
        return 351;
      }
    }
    if (bid[i] != 0) {
      return 351;
    }

    /* null hc: fail; poison out must clear valid/len/buf[0] */
    body.valid = 1;
    body.len = 99;
    body.buf[0] = 'x';
    if (slake_emit_body_from_compose(0, &body) != -1) {
      return 352;
    }
    if (body.valid != 0 || body.len != 0 || body.buf[0] != 0) {
      return 353;
    }
    if (slake_emit_body_from_compose((const slake_host_compose *)0, 0) != -1) {
      return 354;
    }
    if (slake_host_compose_init(&hc) != 0) {
      return 355;
    }
    if (slake_emit_body_from_compose(&hc, 0) != -1) {
      return 356;
    }

    /* empty ready compose: body ok; greppable EMIT_BODY_V0 + RUNTIME-FS; r=0 e=0 */
    if (slake_emit_body_from_compose(&hc, &body) != 0) {
      return 357;
    }
    if (body.valid != 1 || body.len == 0 || body.len >= SLAKE_EMIT_BODY_CAP) {
      return 358;
    }
    if (body.buf[body.len] != 0) {
      return 359;
    }
    if (slake_emit_body_is_valid(&body) != 1) {
      return 360;
    }
    found = 0;
    for (i = 0; (uint16_t)(i + 12) <= body.len; i++) {
      if (body.buf[i] == 'E' && body.buf[i + 1] == 'M' && body.buf[i + 2] == 'I'
          && body.buf[i + 3] == 'T' && body.buf[i + 4] == '_'
          && body.buf[i + 5] == 'B' && body.buf[i + 6] == 'O'
          && body.buf[i + 7] == 'D' && body.buf[i + 8] == 'Y'
          && body.buf[i + 9] == '_' && body.buf[i + 10] == 'V'
          && body.buf[i + 11] == '0') {
        found = 1;
        break;
      }
    }
    if (found != 1) {
      return 361;
    }
    found = 0;
    for (i = 0; (uint16_t)(i + 10) <= body.len; i++) {
      if (body.buf[i] == 'R' && body.buf[i + 1] == 'U' && body.buf[i + 2] == 'N'
          && body.buf[i + 3] == 'T' && body.buf[i + 4] == 'I'
          && body.buf[i + 5] == 'M' && body.buf[i + 6] == 'E'
          && body.buf[i + 7] == '-' && body.buf[i + 8] == 'F'
          && body.buf[i + 9] == 'S') {
        found = 1;
        break;
      }
    }
    if (found != 1) {
      return 362;
    }
    found = 0;
    for (i = 0; (uint16_t)(i + 3) <= body.len; i++) {
      if (body.buf[i] == 'r' && body.buf[i + 1] == '=' && body.buf[i + 2] == '0') {
        found = 1;
        break;
      }
    }
    if (found != 1) {
      return 363;
    }
    found = 0;
    for (i = 0; (uint16_t)(i + 3) <= body.len; i++) {
      if (body.buf[i] == 'e' && body.buf[i + 1] == '=' && body.buf[i + 2] == '0') {
        found = 1;
        break;
      }
    }
    if (found != 1) {
      return 364;
    }

    /* push OMEGA VALUE: body ok; r=1; tag line mult=2 kind=0 */
    if (slake_host_compose_push_node(&hc, 90, SLAKE_MULT_OMEGA, SLAKE_IR_KIND_VALUE)
        != 0) {
      return 365;
    }
    if (slake_emit_body_from_compose(&hc, &body) != 0) {
      return 366;
    }
    if (body.valid != 1 || slake_emit_body_is_valid(&body) != 1) {
      return 367;
    }
    found = 0;
    for (i = 0; (uint16_t)(i + 3) <= body.len; i++) {
      if (body.buf[i] == 'r' && body.buf[i + 1] == '=' && body.buf[i + 2] == '1') {
        found = 1;
        break;
      }
    }
    if (found != 1) {
      return 368;
    }
    /* t0 mult=2 kind=0 */
    found = 0;
    for (i = 0; (uint16_t)(i + 16) <= body.len; i++) {
      if (body.buf[i] == 't' && body.buf[i + 1] == '0'
          && body.buf[i + 2] == ' ' && body.buf[i + 3] == 'm'
          && body.buf[i + 4] == 'u' && body.buf[i + 5] == 'l'
          && body.buf[i + 6] == 't' && body.buf[i + 7] == '='
          && body.buf[i + 8] == '2') {
        found = 1;
        /* kind=0 somewhere after */
        for (j = i; (uint16_t)(j + 6) <= body.len; j++) {
          if (body.buf[j] == 'k' && body.buf[j + 1] == 'i'
              && body.buf[j + 2] == 'n' && body.buf[j + 3] == 'd'
              && body.buf[j + 4] == '=' && body.buf[j + 5] == '0') {
            found = 2;
            break;
          }
        }
        break;
      }
    }
    if (found != 2) {
      return 369;
    }

    /* MULT-1 without mint: fail closed; out zeroed */
    if (slake_host_compose_push_node(&hc, 91, SLAKE_MULT_1, SLAKE_IR_KIND_LINEAR)
        != 0) {
      return 370;
    }
    body.valid = 1;
    body.len = 99;
    body.buf[0] = 'x';
    if (slake_emit_body_from_compose(&hc, &body) != -1) {
      return 371;
    }
    if (body.valid != 0 || body.len != 0 || body.buf[0] != 0) {
      return 372;
    }
    if (slake_emit_body_is_valid(&body) != 0) {
      return 373;
    }

    /* mint + OMEGA + LINEAR: r>=2; fragment lists both tags */
    if (slake_host_compose_mint(&hc, 121) != 0) {
      return 374;
    }
    if (slake_emit_body_from_compose(&hc, &body) != 0) {
      return 375;
    }
    if (body.valid != 1 || slake_emit_body_is_valid(&body) != 1) {
      return 376;
    }
    found = 0;
    for (i = 0; (uint16_t)(i + 3) <= body.len; i++) {
      if (body.buf[i] == 'r' && body.buf[i + 1] == '=' && body.buf[i + 2] == '2') {
        found = 1;
        break;
      }
    }
    if (found != 1) {
      return 377;
    }
    /* t1 mult=1 kind=1 (LINEAR) */
    found = 0;
    for (i = 0; (uint16_t)(i + 16) <= body.len; i++) {
      if (body.buf[i] == 't' && body.buf[i + 1] == '1'
          && body.buf[i + 2] == ' ' && body.buf[i + 3] == 'm'
          && body.buf[i + 4] == 'u' && body.buf[i + 5] == 'l'
          && body.buf[i + 6] == 't' && body.buf[i + 7] == '='
          && body.buf[i + 8] == '1') {
        found = 1;
        for (j = i; (uint16_t)(j + 6) <= body.len; j++) {
          if (body.buf[j] == 'k' && body.buf[j + 1] == 'i'
              && body.buf[j + 2] == 'n' && body.buf[j + 3] == 'd'
              && body.buf[j + 4] == '=' && body.buf[j + 5] == '1') {
            found = 2;
            break;
          }
        }
        break;
      }
    }
    if (found != 2) {
      return 378;
    }

    /* MULT-0 without mark: fail; mark then e>=1; MULT-0 still listed (honesty) */
    if (slake_host_compose_push_node(&hc, 92, SLAKE_MULT_0, SLAKE_IR_KIND_ERASED)
        != 0) {
      return 379;
    }
    body.valid = 1;
    body.len = 77;
    body.buf[0] = 'z';
    if (slake_emit_body_from_compose(&hc, &body) != -1) {
      return 380;
    }
    if (body.valid != 0 || body.len != 0 || body.buf[0] != 0) {
      return 381;
    }
    if (slake_host_compose_mark_erased(&hc) != 0) {
      return 382;
    }
    if (slake_emit_body_from_compose(&hc, &body) != 0) {
      return 383;
    }
    if (body.valid != 1 || slake_emit_body_is_valid(&body) != 1) {
      return 384;
    }
    found = 0;
    for (i = 0; (uint16_t)(i + 3) <= body.len; i++) {
      if (body.buf[i] == 'e' && body.buf[i + 1] == '=' && body.buf[i + 2] == '1') {
        found = 1;
        break;
      }
    }
    if (found != 1) {
      return 385;
    }
    /* t2 mult=0 kind=2 (erased inventory honesty) */
    found = 0;
    for (i = 0; (uint16_t)(i + 16) <= body.len; i++) {
      if (body.buf[i] == 't' && body.buf[i + 1] == '2'
          && body.buf[i + 2] == ' ' && body.buf[i + 3] == 'm'
          && body.buf[i + 4] == 'u' && body.buf[i + 5] == 'l'
          && body.buf[i + 6] == 't' && body.buf[i + 7] == '='
          && body.buf[i + 8] == '0') {
        found = 1;
        for (j = i; (uint16_t)(j + 6) <= body.len; j++) {
          if (body.buf[j] == 'k' && body.buf[j + 1] == 'i'
              && body.buf[j + 2] == 'n' && body.buf[j + 3] == 'd'
              && body.buf[j + 4] == '=' && body.buf[j + 5] == '2') {
            found = 2;
            break;
          }
        }
        break;
      }
    }
    if (found != 2) {
      return 386;
    }

    /* is_valid null -> 0; invalid body -> 0 */
    if (slake_emit_body_is_valid(0) != 0) {
      return 387;
    }
    body.valid = 0;
    if (slake_emit_body_is_valid(&body) != 0) {
      return 388;
    }
  }

  return 0;
}
