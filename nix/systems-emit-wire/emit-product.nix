# SPDX-License-Identifier: Unlicense
# Data only: freestanding emit product paths, APIs, stage tokens, driver path specs.
# Imported by ./specs.nix. Driver *runs* stay shell; tokens here are presence only.
# Pure Nix supersets emit-driver self-greps (SLAKE_EMIT_FREESTANDING_C_V0 + UNIT_DEEPEN_V1).
let
  emitH = "src/systems/emit/slake_freestanding.h";
  emitC = "src/systems/emit/slake_freestanding.c";
  releaseH = "out/freestanding-c/slake_freestanding.h";
  releaseC = "out/freestanding-c/slake_freestanding.c";
  # Hosted behavioral smoke source (test debt; not product emit residual).
  behavioralProbe = "src/systems/smoke/slake_behavioral_probe.c";

  unitTranslationApis = [
    "slake_mult_is_valid"
    "slake_linear_consume"
    "slake_erasure_is_runtime_absent"
    "slake_check_fail_closed"
    "slake_extract_with_checks"
    "slake_typed_ir_id"
    "slake_ir_node_init"
    "slake_ir_node_is_well_typed"
    "slake_ir_node_check_fail_closed"
    "slake_ir_program_id"
    "slake_ir_program_init"
    "slake_ir_program_push"
    "slake_ir_program_is_well_typed"
    "slake_ir_program_check_fail_closed"
    "slake_ir_graph_id"
    "slake_ir_graph_init"
    "slake_ir_graph_push_node"
    "slake_ir_graph_add_edge"
    "slake_ir_graph_is_well_typed"
    "slake_ir_graph_check_fail_closed"
    "slake_host_compose_id"
    "slake_host_compose_init"
    "slake_host_compose_push_node"
    "slake_host_compose_add_edge"
    "slake_host_compose_mint"
    "slake_host_compose_consume"
    "slake_host_compose_mark_erased"
    "slake_host_compose_is_well_typed"
    "slake_host_compose_check_fail_closed"
    "slake_host_compose_extract"
    "slake_emit_plan_id"
    "slake_emit_plan_from_compose"
    "slake_emit_plan_is_ready"
    "slake_emit_apply_id"
    "slake_emit_apply_from_compose"
    "slake_emit_apply_is_valid"
    "slake_emit_body_id"
    "slake_emit_body_from_compose"
    "slake_emit_body_is_valid"
  ];

  emitProductAll = [
    "SLAKE_EMIT_FREESTANDING_C_V0"
    "UNIT_DEEPEN_V1"
    "UNIT_TRANSLATION_V0"
    "MULT-0"
    "MULT-1"
    "MULT-OMEGA"
    "RUNTIME-FS"
    "not residual free"
    "FAIL_CLOSED_CHECKER_V1"
    "CONSUME_TOKEN_HOST_V0"
    "JOIN-ALG"
    "ConsumeToken"
    "LINEAR-EXACT-ONCE"
    "TYPED_IR_V0"
    "IR_PROGRAM_V0"
    "IR_GRAPH_EDGES_V0"
    "HOST_COMPOSE_V0"
    "EMIT_PLAN_V0"
    "EMIT_APPLY_V0"
    "EMIT_BODY_V0"
    "HOST-EMIT-SSOT"
    "HOST-EMIT-MULT"
    "HOST-EMIT-LINEAR"
    "SLAKE_IR_KIND_VALUE"
    "SLAKE_IR_KIND_LINEAR"
    "SLAKE_IR_KIND_ERASED"
    "slake_ir_node"
    "SLAKE_IR_PROGRAM_CAP"
    "slake_ir_program"
    "SLAKE_IR_EDGE_MAX"
    "slake_ir_graph"
    "slake_ir_edge"
    "slake_host_compose"
    "EMIT-BOUNDARY"
    "slake_emit_plan"
    "slake_emit_apply"
    "SLAKE_EMIT_APPLY_CAP"
    "slake_emit_body"
    "SLAKE_EMIT_BODY_CAP"
    "slake_check_bundle"
    "slake_consume_token_mint"
    "slake_consume_token_consume"
    "slake_consume_token_check_fail_closed"
    "slake_consume_token_host_id"
    "slake_consume_token_init"
    "slake_consume_token_is_live"
    "slake_emit_version"
    "slake_type_tag_init"
    "slake_mult_is_known"
    "slake_mult_name"
    "slake_linear_token_consume"
    "slake_erased_mark"
    "slake_extract_product_runtime"
    "slake_type_tag_get"
    "slake_unit_translation_id"
  ]
  ++ unitTranslationApis;

  emitProductNone = [
    "SLAKE_IR_PROGRAM_MAX"
    "SLAKE_IR_EDGE_CAP"
  ];

  releaseAll = emitProductAll;
  releaseNone = emitProductNone;
in
{
  inherit
    emitH
    emitC
    releaseH
    releaseC
    behavioralProbe
    unitTranslationApis
    emitProductAll
    emitProductNone
    releaseAll
    releaseNone
    ;

  # Wave B: build + out-freestanding-c live in justfile (scripts deleted).
  # Wave C: Lean FreestandingEmit owns product wire write; bash emit deleted.
  requiredDriverAndEmit = [
    "justfile"
    "script/slake-compile-path.sh"
    "src/systems/SystemsLean/FreestandingEmit.lean"
    "src/systems/emit/template_slake_freestanding.h.in"
    "src/systems/emit/template_slake_freestanding.c.in"
    emitH
    emitC
    behavioralProbe
    # HOST-EMIT-SSOT durable fragment dialect (Lean buildFragment owner).
    "src/systems/emit/host_emit_body_fragment.ssot.txt"
    # HOST-EMIT-MULT durable Mult product text (Lean EmitMult owner).
    "src/systems/emit/host_emit_mult.ssot.txt"
    # HOST-EMIT-LINEAR durable Linear product text (Lean EmitLinear owner).
    "src/systems/emit/host_emit_linear.ssot.txt"
  ];

  optionalFiles = [
    releaseH
    releaseC
  ];

  # Drivers + emit product wire content.
  contentSpecs = [
    {
      rel = "script/slake-compile-path.sh";
      all = [
        "SLAKE_COMPILE_PATH_V0"
        "SLAKE_COMPILE_PATH_V1"
        "HOST-COMPILE-PATH"
        "not product C"
      ];
    }
    {
      # Wave B/C: just build + just out-freestanding-c own process glue;
      # Lean FreestandingEmit is the emit writer.
      rel = "justfile";
      all = [
        "SLAKE_COMPILE_PATH_V0"
        "slake-compile-path"
        "slake-emit"
        "SLAKE_EMIT_FREESTANDING_C_V0"
        "FreestandingEmit"
        "not residual free"
        "not PROVABLY"
      ];
    }
    {
      rel = "src/systems/SystemsLean/FreestandingEmit.lean";
      all = [
        "SLAKE_EMIT_FREESTANDING_C_V0"
        "not residual free"
        "no product GC"
        "HOST-EMIT-SSOT"
        "HOST-EMIT-MULT"
        "HOST-EMIT-LINEAR"
        "host_emit_body_fragment.ssot.txt"
        "host_emit_mult.ssot.txt"
        "host_emit_linear.ssot.txt"
        "template_slake_freestanding"
      ];
    }
    {
      rel = "src/systems/emit/template_slake_freestanding.h.in";
      all = [
        "SLAKE_EMIT_FREESTANDING_C_V0"
        "HOST-EMIT-SSOT"
        "HOST-EMIT-MULT"
        "HOST-EMIT-LINEAR"
        "__HOST_EMIT_MULT_HEADER__"
        "__HOST_EMIT_LINEAR_HEADER__"
        "not residual free"
      ];
    }
    {
      rel = "src/systems/emit/template_slake_freestanding.c.in";
      all = [
        "SLAKE_EMIT_FREESTANDING_C_V0"
        "HOST-EMIT-SSOT"
        "HOST-EMIT-MULT"
        "HOST-EMIT-LINEAR"
        "__HOST_EMIT_MULT_BODY__"
        "__HOST_EMIT_LINEAR_BODY__"
        "__SSOT_EMPTY_FRAGMENT__"
        "not residual free"
      ];
    }
    {
      # HOST-EMIT-SSOT: empty-compose fragment + dialect keys for EMIT_BODY_V0.
      rel = "src/systems/emit/host_emit_body_fragment.ssot.txt";
      all = [
        "HOST-EMIT-SSOT"
        "EMPTY_FRAGMENT"
        "HEADER_OPEN"
        "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */"
        "NON-SSOT"
      ];
    }
    {
      # HOST-EMIT-MULT: Mult product C text owned by Lean EmitMult (SH2).
      rel = "src/systems/emit/host_emit_mult.ssot.txt";
      all = [
        "HOST-EMIT-MULT"
        "NON-SSOT"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "slake_mult_is_valid"
        "MULT_C_HEADER_BEGIN"
        "MULT_C_BODY_BEGIN"
      ];
    }
    {
      # HOST-EMIT-LINEAR: Linear product C text owned by Lean EmitLinear.
      rel = "src/systems/emit/host_emit_linear.ssot.txt";
      all = [
        "HOST-EMIT-LINEAR"
        "NON-SSOT"
        "LINEAR-EXACT-ONCE"
        "CONSUME_TOKEN_HOST_V0"
        "JOIN-ALG"
        "slake_linear_consume"
        "slake_consume_token_consume"
        "LINEAR_C_HEADER_BEGIN"
        "LINEAR_C_BODY_BEGIN"
      ];
    }
    {
      rel = emitH;
      all = emitProductAll;
      none = emitProductNone;
    }
    {
      rel = emitC;
      all = emitProductAll;
      none = emitProductNone;
    }
    {
      # Smoke debt only -- fail closed if probe stripped; not product wire growth.
      # HOST-PARITY-MULT (SH3): product Mult name / is_known / enum tag parity.
      # HOST-PARITY-LINEAR: product Linear / CONSUME_TOKEN path honesty labels.
      # HOST-PARITY-TYPES: product TYPED_IR / slake_ir_node path honesty labels.
      # HOST-PARITY-PROGRAM: product IR_PROGRAM / IR_GRAPH / HOST_COMPOSE path
      # honesty labels (Mult+Linear+Types+Program freestanding path).
      # HOST-PARITY-EMIT: product EMIT_PLAN / EMIT_APPLY / EMIT_BODY path
      # honesty labels (Mult+Linear+Types+Program+Emit freestanding path).
      rel = behavioralProbe;
      all = [
        "slake_freestanding.h"
        "UNIT_TRANSLATION_V0"
        "UNIT_DEEPEN_V1"
        "slake_emit_body_is_valid"
        "main"
        "HOST-PARITY-MULT"
        "SELF-HOST-PARITY-MULT"
        "SLAKE_SELF_HOST_PARITY_MULT_V0"
        "PARITY-MULT-SMOKE"
        "slake_mult_name"
        "slake_mult_is_known"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "HOST-PARITY-LINEAR"
        "SELF-HOST-PARITY-LINEAR"
        "SLAKE_SELF_HOST_PARITY_LINEAR_V0"
        "PARITY-LINEAR-SMOKE"
        "slake_linear_token_init"
        "slake_linear_consume"
        "slake_consume_token_mint"
        "CONSUME_TOKEN_HOST_V0"
        "HOST-PARITY-TYPES"
        "SELF-HOST-PARITY-TYPES"
        "SLAKE_SELF_HOST_PARITY_TYPES_V0"
        "PARITY-TYPES-SMOKE"
        "TYPED_IR_V0"
        "slake_ir_node"
        "slake_ir_node_init"
        "slake_ir_node_is_well_typed"
        "slake_ir_node_check_fail_closed"
        "HOST-PARITY-PROGRAM"
        "SELF-HOST-PARITY-PROGRAM"
        "SLAKE_SELF_HOST_PARITY_PROGRAM_V0"
        "PARITY-PROGRAM-SMOKE"
        "IR_PROGRAM_V0"
        "IR_GRAPH_EDGES_V0"
        "HOST_COMPOSE_V0"
        "slake_ir_program"
        "slake_ir_graph"
        "slake_host_compose"
        "HOST-PARITY-EMIT"
        "SELF-HOST-PARITY-EMIT"
        "SLAKE_SELF_HOST_PARITY_EMIT_V0"
        "PARITY-EMIT-SMOKE"
        "EMIT_PLAN_V0"
        "EMIT_APPLY_V0"
        "EMIT_BODY_V0"
        "slake_emit_plan"
        "slake_emit_apply"
        "slake_emit_body"
      ];
      none = [
        "SLAKE_EMIT_FREESTANDING_C_V0"
      ];
    }
  ];

  optionalContentSpecs = [
    {
      rel = releaseH;
      all = releaseAll;
      none = releaseNone;
    }
    {
      rel = releaseC;
      all = releaseAll;
      none = releaseNone;
    }
  ];
}
