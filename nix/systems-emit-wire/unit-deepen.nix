# SPDX-License-Identifier: Unlicense
# Data only: UNIT_DEEPEN_V1 freestanding units + companion notes + README stage light touch.
# Imported by ./specs.nix.
{
  requiredDeepenFiles = [
    "src/systems/Mult.slake"
    "src/systems/Linear.slake"
    "src/systems/Erasure.slake"
    "src/systems/Extract.slake"
    "src/systems/Types.slake"
    "src/systems/mult.md"
    "src/systems/linear.md"
    "src/systems/erasure.md"
    "src/systems/extract.md"
    "src/systems/types.md"
    "src/systems/README.md"
  ];

  contentSpecs = [
    {
      rel = "src/systems/Mult.slake";
      all = [
        "UNIT_DEEPEN_V1"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
      ];
      anyGroups = [
        [
          "multIsValid"
          "MultIsValid"
          "slake_mult_is_valid"
        ]
      ];
    }
    {
      rel = "src/systems/Linear.slake";
      all = [
        "UNIT_DEEPEN_V1"
      ];
      anyGroups = [
        [
          "JOIN-ALG"
          "ConsumeToken"
        ]
        [
          "slake_linear_consume"
          "linearConsume"
          "LinearConsume"
        ]
      ];
      anyGroupsInsensitive = [
        [
          "fail-closed"
          "fail closed"
          "exact-once"
          "exact once"
        ]
      ];
    }
    {
      rel = "src/systems/Erasure.slake";
      all = [
        "UNIT_DEEPEN_V1"
        "MULT-0"
      ];
      anyGroups = [
        [
          "EDGE-PROP"
          "ERASE-PROP"
        ]
        [
          "slake_erasure_is_runtime_absent"
          "erasureIsRuntimeAbsent"
          "ErasureIsRuntimeAbsent"
        ]
      ];
    }
    {
      rel = "src/systems/Extract.slake";
      all = [
        "UNIT_DEEPEN_V1"
        "RUNTIME-FS"
        "SLAKE_EMIT_FREESTANDING_C_V0"
        "FAIL_CLOSED_CHECKER_V1"
        "HOST_COMPOSE_V0"
        "EMIT_PLAN_V0"
        "EMIT_APPLY_V0"
        "EMIT_BODY_V0"
      ];
      anyGroups = [
        [
          "slake_check_fail_closed"
          "slake_extract_with_checks"
        ]
        [
          "slake_host_compose"
          "host_compose"
        ]
        [
          "slake_emit_plan"
          "emit_plan"
        ]
        [
          "slake_emit_apply"
          "emit_apply"
        ]
        [
          "slake_emit_body"
          "emit_body"
        ]
        [
          "empty graph"
          "empty well-typed"
          "empty compose"
        ]
      ];
    }
    {
      rel = "src/systems/Types.slake";
      all = [
        "UNIT_DEEPEN_V1"
        "TYPED_IR_V0"
        "IR_PROGRAM_V0"
        "IR_GRAPH_EDGES_V0"
        "HOST_COMPOSE_V0"
        "EMIT_PLAN_V0"
        "EMIT_APPLY_V0"
        "EMIT_BODY_V0"
        "SLAKE_IR_PROGRAM_CAP"
        "SLAKE_IR_EDGE_MAX"
      ];
      none = [
        "SLAKE_IR_PROGRAM_MAX"
        "SLAKE_IR_EDGE_CAP"
      ];
      anyGroups = [
        [
          "slake_ir_node"
          "ir_node"
        ]
        [
          "slake_ir_program"
          "ir_program"
        ]
        [
          "slake_ir_graph"
          "ir_graph"
        ]
        [
          "empty edges OK"
          "empty valid graph"
        ]
      ];
      anyGroupsInsensitive = [
        [
          "empty program (count=0) is not well-typed"
          "empty fails closed"
          "count>=1"
          "not well-typed as a program"
        ]
        [
          "-2 full"
        ]
      ];
    }
    {
      rel = "src/systems/mult.md";
      all = [ "UNIT_DEEPEN_V1" ];
    }
    {
      rel = "src/systems/linear.md";
      all = [
        "UNIT_DEEPEN_V1"
        "CONSUME_TOKEN_HOST_V0"
        "HOST_COMPOSE_V0"
        "slake_consume_token"
      ];
      anyGroups = [
        [
          "JOIN-ALG"
          "ConsumeToken"
        ]
        [
          "slake_host_compose"
          "host_compose"
        ]
      ];
    }
    {
      rel = "src/systems/erasure.md";
      all = [ "UNIT_DEEPEN_V1" ];
    }
    {
      rel = "src/systems/extract.md";
      all = [
        "UNIT_DEEPEN_V1"
        "FAIL_CLOSED_CHECKER_V1"
        "HOST_COMPOSE_V0"
        "EMIT_PLAN_V0"
        "EMIT_APPLY_V0"
        "EMIT_BODY_V0"
      ];
      anyGroups = [
        [
          "slake_check_fail_closed"
          "slake_extract_with_checks"
        ]
        [
          "slake_host_compose"
          "host_compose"
        ]
        [
          "slake_emit_plan"
          "emit_plan"
        ]
        [
          "slake_emit_apply"
          "emit_apply"
        ]
        [
          "slake_emit_body"
          "emit_body"
        ]
        [
          "empty graph"
          "empty well-typed"
          "empty compose"
        ]
      ];
    }
    {
      rel = "src/systems/types.md";
      all = [
        "UNIT_DEEPEN_V1"
        "TYPED_IR_V0"
        "IR_PROGRAM_V0"
        "IR_GRAPH_EDGES_V0"
        "HOST_COMPOSE_V0"
        "EMIT_PLAN_V0"
        "EMIT_APPLY_V0"
        "EMIT_BODY_V0"
        "SLAKE_IR_PROGRAM_CAP"
        "SLAKE_IR_EDGE_MAX"
      ];
      none = [
        "SLAKE_IR_PROGRAM_MAX"
        "SLAKE_IR_EDGE_CAP"
      ];
      anyGroups = [
        [
          "slake_ir_node"
          "ir_node"
        ]
        [
          "slake_ir_program"
          "ir_program"
        ]
        [
          "slake_ir_graph"
          "ir_graph"
        ]
        [
          "empty edges OK"
          "empty valid graph"
        ]
      ];
      anyGroupsInsensitive = [
        [
          "empty fails closed"
          "count>=1"
          "not well-typed"
        ]
        [
          "-2 full"
        ]
      ];
    }
    {
      rel = "src/systems/README.md";
      all = [
        "HOST_COMPOSE_V0"
        "EMIT_PLAN_V0"
        "EMIT_APPLY_V0"
        "EMIT_BODY_V0"
      ];
    }
  ];
}
