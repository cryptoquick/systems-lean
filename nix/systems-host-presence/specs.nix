# SPDX-License-Identifier: Unlicense
# Data only: required paths + unit-surface / SYSTEMS_LEAN_HOST token specs +
# tree-wide banned-jargon walk config. Imported by ./default.nix.
# Edit here when a host stage gains honesty tokens or jargon scope changes.
{
  # Tree-wide jargon walk under src/systems (former check.sh grep -rqi mill).
  # Skip package-local Lake / VCS / cache (same set as emit-wire unit walk).
  jargonWalkRoot = "src/systems";
  jargonWalkSkipDirs = [
    ".lake"
    ".git"
    ".cache"
  ];
  # Match former shell --include set.
  jargonWalkExtensions = [
    ".md"
    ".slake"
    ".lean"
    ".c"
    ".h"
  ];
  # Case-folded substring ban (fail-closed; see default.nix comment on FP risk).
  jargonForbidden = [
    "pole"
    "spine"
  ];

  # Skeleton docs/slake + Lake pin + Mult..ProductPath host ladder.
  requiredFiles = [
    "src/systems/README.md"
    "src/systems/check.sh"
    "src/systems/types.md"
    "src/systems/mult.md"
    "src/systems/linear.md"
    "src/systems/erasure.md"
    "src/systems/extract.md"
    "src/systems/host-partial-inventory.md"
    "src/systems/surface-matrix.md"
    "src/systems/self-host.md"
    "src/systems/Types.slake"
    "src/systems/Mult.slake"
    "src/systems/Linear.slake"
    "src/systems/Erasure.slake"
    "src/systems/Extract.slake"
    "src/systems/lakefile.toml"
    "src/systems/lean-toolchain"
    "src/systems/lake-manifest.json"
    "src/systems/SystemsLean.lean"
    "src/systems/SystemsLean/Mult.lean"
    "src/systems/SystemsLean/Linear.lean"
    "src/systems/SystemsLean/Types.lean"
    "src/systems/SystemsLean/IrProgram.lean"
    "src/systems/SystemsLean/Erasure.lean"
    "src/systems/SystemsLean/Extract.lean"
    "src/systems/SystemsLean/IrGraph.lean"
    "src/systems/SystemsLean/HostCompose.lean"
    "src/systems/SystemsLean/EmitPlan.lean"
    "src/systems/SystemsLean/EmitApply.lean"
    "src/systems/SystemsLean/EmitBody.lean"
    "src/systems/SystemsLean/CompilePath.lean"
    "src/systems/SystemsLean/JoinMap.lean"
    "src/systems/SystemsLean/SelfHost.lean"
    "src/systems/SystemsLean/SurfaceMatrix.lean"
    "src/systems/SystemsLean/KernelMult.lean"
    "src/systems/SystemsLean/EmitMult.lean"
    "src/systems/SystemsLean/ParityMult.lean"
    "src/systems/SystemsLean/KernelLinear.lean"
    "src/systems/SystemsLean/ParityLinear.lean"
    "src/systems/SystemsLean/KernelTypes.lean"
    "src/systems/SystemsLean/ParityTypes.lean"
    "src/systems/SystemsLean/KernelProgram.lean"
    "src/systems/SystemsLean/ParityProgram.lean"
    "src/systems/SystemsLean/KernelEmit.lean"
    "src/systems/SystemsLean/ParityEmit.lean"
    "src/systems/SystemsLean/SelfApply.lean"
    "src/systems/SystemsLean/SelfApplyFs.lean"
    "src/systems/SystemsLean/LlvmHold.lean"
    "src/systems/SystemsLean/InventoryClose.lean"
    "src/systems/SystemsLean/ProductPath.lean"
    # HOST-EMIT-SSOT durable empty-compose / dialect artifact (P2).
    "src/systems/emit/host_emit_body_fragment.ssot.txt"
    # HOST-EMIT-MULT durable Mult product text (SH2).
    "src/systems/emit/host_emit_mult.ssot.txt"
  ];

  hostLeans = [
    "src/systems/SystemsLean/Mult.lean"
    "src/systems/SystemsLean/Linear.lean"
    "src/systems/SystemsLean/Types.lean"
    "src/systems/SystemsLean/IrProgram.lean"
    "src/systems/SystemsLean/Erasure.lean"
    "src/systems/SystemsLean/Extract.lean"
    "src/systems/SystemsLean/IrGraph.lean"
    "src/systems/SystemsLean/HostCompose.lean"
    "src/systems/SystemsLean/EmitPlan.lean"
    "src/systems/SystemsLean/EmitApply.lean"
    "src/systems/SystemsLean/EmitBody.lean"
    "src/systems/SystemsLean/CompilePath.lean"
    "src/systems/SystemsLean/JoinMap.lean"
    "src/systems/SystemsLean/SelfHost.lean"
    "src/systems/SystemsLean/SurfaceMatrix.lean"
    "src/systems/SystemsLean/KernelMult.lean"
    "src/systems/SystemsLean/EmitMult.lean"
    "src/systems/SystemsLean/ParityMult.lean"
    "src/systems/SystemsLean/KernelLinear.lean"
    "src/systems/SystemsLean/ParityLinear.lean"
    "src/systems/SystemsLean/KernelTypes.lean"
    "src/systems/SystemsLean/ParityTypes.lean"
    "src/systems/SystemsLean/KernelProgram.lean"
    "src/systems/SystemsLean/ParityProgram.lean"
    "src/systems/SystemsLean/KernelEmit.lean"
    "src/systems/SystemsLean/ParityEmit.lean"
    "src/systems/SystemsLean/SelfApply.lean"
    "src/systems/SystemsLean/SelfApplyFs.lean"
    "src/systems/SystemsLean/LlvmHold.lean"
    "src/systems/SystemsLean/InventoryClose.lean"
    "src/systems/SystemsLean/ProductPath.lean"
  ];

  # Unit-surface docs + .slake honesty (former check.sh need[] greps).
  # types.md: COMMON-UNIVERSE only; HOST-RESIDUAL / PRODUCT-WIRE-RESIDUAL
  # stay on Types.slake + SystemsLean/Types.lean.
  unitSurfaceSpecs = [
    {
      rel = "src/systems/types.md";
      all = [
        "COMMON-UNIVERSE"
        "HOST-PARITY-TYPES"
        "SELF-HOST-PARITY-TYPES"
        "HOST-PARITY-PROGRAM"
        "SELF-HOST-PARITY-PROGRAM"
        "HOST-PARITY-EMIT"
        "SELF-HOST-PARITY-EMIT"
      ];
    }
    {
      rel = "src/systems/mult.md";
      all = [
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "FAIL-CLOSED-UNKNOWN-GRADE"
      ];
    }
    {
      rel = "src/systems/Mult.slake";
      all = [ "FAIL-CLOSED-UNKNOWN-GRADE" ];
    }
    {
      rel = "src/systems/linear.md";
      all = [
        "LINEAR-EXACT-ONCE"
        "SELF-HOST-KERNEL-LINEAR"
        "HOST-KERNEL-LINEAR"
        "HOST-PARITY-LINEAR"
        "SELF-HOST-PARITY-LINEAR"
      ];
    }
    {
      rel = "src/systems/Linear.slake";
      all = [
        "LINEAR-EXACT-ONCE"
        "JOIN-ALG"
        "ConsumeToken"
      ];
    }
    {
      rel = "src/systems/erasure.md";
      all = [ "ERASE-RULE-MULT-0" ];
    }
    {
      rel = "src/systems/Erasure.slake";
      all = [
        "ERASE-RULE-MULT-0"
        "EDGE-PROP"
        "ERASE-PROP"
      ];
    }
    {
      rel = "src/systems/Extract.slake";
      all = [
        "RUNTIME-FS"
        "EDGE-RUNTIME"
        "RUNTIME-CLASSIC"
        "EMIT-BOUNDARY"
      ];
    }
    {
      rel = "src/systems/extract.md";
      all = [ "EMIT-BOUNDARY" ];
    }
    {
      # Host PARTIAL inventory Mult..ProductPath (greppable miss list / empty).
      rel = "src/systems/host-partial-inventory.md";
      all = [
        "HOST-PARTIAL-INVENTORY"
        "SYSTEMS_LEAN_HOST"
        "CLOSABLE-MISS-COUNT-0"
        "intentional PARTIAL"
        "Mult..LlvmHold"
        "Mult..InventoryClose"
        "Mult..ProductPath"
        "HOST-INVENTORY-CLOSE"
        "SELF-HOST-INVENTORY-CLOSE"
        "HOST-PRODUCT-PATH"
        "SELF-HOST-PRODUCT-PATH"
        "SELF-HOST-KERNEL-MULT"
        "HOST-EMIT-MULT"
        "HOST-PARITY-MULT"
        "SELF-HOST-KERNEL-LINEAR"
        "HOST-KERNEL-LINEAR"
        "HOST-PARITY-LINEAR"
        "SELF-HOST-PARITY-LINEAR"
        "SELF-HOST-KERNEL-TYPES"
        "HOST-KERNEL-TYPES"
        "HOST-PARITY-TYPES"
        "SELF-HOST-PARITY-TYPES"
        "SELF-HOST-KERNEL-PROGRAM"
        "HOST-KERNEL-PROGRAM"
        "HOST-PARITY-PROGRAM"
        "SELF-HOST-PARITY-PROGRAM"
        "SELF-HOST-KERNEL-EMIT"
        "HOST-KERNEL-EMIT"
        "HOST-PARITY-EMIT"
        "SELF-HOST-PARITY-EMIT"
        "HOST-SELF-APPLY"
        "SELF-HOST-SELF-APPLY"
        "HOST-SELF-APPLY-FS"
        "SELF-HOST-SELF-APPLY-FS"
        "HOST-LLVM-HOLD"
        "SELF-HOST-LLVM-HOLD"
        "HOST-PROVABLY-HOLD"
      ];
    }
    {
      # SURFACE-MATRIX inventory prose (P7 progressive superset surface).
      rel = "src/systems/surface-matrix.md";
      all = [
        "SURFACE-MATRIX"
        "SLAKE_SURFACE_MATRIX_V0"
        "HOST-SURFACE-MATRIX"
        "present-partial"
        "open"
        "SYSTEMS_LEAN_HOST"
        "ConsumeToken"
        "ErasedIndex"
        "UnrestrictedShare"
      ];
    }
    {
      rel = "src/systems/Types.slake";
      all = [
        "COMMON-UNIVERSE"
        "HOST-RESIDUAL"
        "PRODUCT-WIRE-RESIDUAL"
      ];
    }
  ];

  # SYSTEMS_LEAN_HOST modules: marker + namespaces + smoke helpers.
  hostSpecs = [
    {
      rel = "src/systems/SystemsLean/Mult.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "FAIL-CLOSED-UNKNOWN-GRADE"
        "SystemsLean.Mult"
      ];
      anyGroups = [
        [
          "isValid"
          "multIsValid"
        ]
      ];
    }
    {
      rel = "src/systems/SystemsLean/Linear.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "JOIN-ALG"
        "ConsumeToken"
        "MULT-1"
        "LINEAR-EXACT-ONCE"
        "SystemsLean.Linear"
      ];
    }
    {
      rel = "src/systems/SystemsLean/Types.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "COMMON-UNIVERSE"
        "HOST-RESIDUAL"
        "PRODUCT-WIRE-RESIDUAL"
        "FAIL-CLOSED-UNKNOWN-KIND"
        "SystemsLean.Types"
      ];
      anyGroups = [
        [
          "kindMultOk"
          "isWellTyped"
        ]
      ];
    }
    {
      rel = "src/systems/SystemsLean/IrProgram.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "ORDERED-IR-PROGRAM"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "SystemsLean.IrProgram"
      ];
      anyGroups = [
        [
          "push"
          "foldWellTyped"
          "isWellTyped"
        ]
      ];
    }
    {
      rel = "src/systems/SystemsLean/Erasure.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "ERASE-RULE-MULT-0"
        "ERASE-NO-RUNTIME"
        "EDGE-PROP"
        "ERASE-PROP"
        "SystemsLean.Erasure"
      ];
      anyGroups = [
        [
          "isRuntimeAbsent"
          "mark"
        ]
      ];
    }
    {
      rel = "src/systems/SystemsLean/Extract.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "EMIT-BOUNDARY"
        "RUNTIME-FS"
        "EDGE-RUNTIME"
        "RUNTIME-CLASSIC"
        "SystemsLean.Extract"
      ];
      anyGroups = [
        [
          "extractOk"
          "checkFailClosed"
        ]
      ];
    }
    {
      rel = "src/systems/SystemsLean/IrGraph.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "IR_GRAPH_EDGES_V0"
        "IR-GRAPH-EDGES"
        "EMPTY-GRAPH-OK"
        "SLAKE_IR_EDGE_MAX"
        "IR-GRAPH-SMOKE"
        "example"
        "edgesSound"
        "SystemsLean.IrGraph"
      ];
      anyGroups = [
        [
          "addEdge"
          "pushNode"
          "isWellTyped"
        ]
      ];
    }
    {
      rel = "src/systems/SystemsLean/HostCompose.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "HOST_COMPOSE_V0"
        "HOST-COMPOSE"
        "EMIT-BOUNDARY"
        "RUNTIME-FS"
        "HOST-SMOKE"
        "example"
        "SystemsLean.HostCompose"
      ];
      anyGroups = [
        [
          "extractOk"
          "checkFailClosed"
        ]
        [
          "JOIN-ALG"
          "ConsumeToken"
        ]
        [
          "mint"
          "consume"
          "markErased"
        ]
        [
          "pushHostNode"
          "addHostEdge"
          "hostIsWellTyped"
        ]
        [
          "multPreScan"
          "nodeMultOk"
        ]
      ];
    }
    {
      rel = "src/systems/SystemsLean/EmitPlan.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "EMIT_PLAN_V0"
        "EMIT-PLAN"
        "planFromCompose"
        "isReady"
        "checkFailClosed"
        "SystemsLean.EmitPlan"
        "EMIT-PLAN-SMOKE"
        "example"
      ];
    }
    {
      rel = "src/systems/SystemsLean/EmitApply.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "EMIT_APPLY_V0"
        "EMIT-APPLY"
        "applyFromCompose"
        "applyIsValid"
        "checkFailClosed"
        "SystemsLean.EmitApply"
        "applyCap"
        "packTag"
        "EMIT-APPLY-SMOKE"
        "example"
      ];
      anyGroups = [
        [
          "APPLY_CAP"
          "SLAKE_EMIT_APPLY_CAP"
        ]
      ];
    }
    {
      rel = "src/systems/SystemsLean/EmitBody.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "EMIT_BODY_V0"
        "EMIT-BODY"
        "bodyFromCompose"
        "bodyIsValid"
        "buildFragment"
        "SystemsLean.EmitBody"
        "bodyCap"
        "EMIT-BODY-SMOKE"
        "example"
        "RUNTIME-FS"
        "EMIT-BOUNDARY"
        "HOST-EMIT-SSOT"
        "emptyComposeFragmentSsot"
        "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */"
      ];
      anyGroups = [
        [
          "BODY_CAP"
          "SLAKE_EMIT_BODY_CAP"
        ]
      ];
    }
    {
      # HOST-COMPILE-PATH (P3): host-informed compile-path readiness (V1).
      rel = "src/systems/SystemsLean/CompilePath.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_COMPILE_PATH_V1"
        "HOST-COMPILE-PATH"
        "COMPILE-PATH"
        "compileReady"
        "unitCompileReady"
        "programCompileReady"
        "gradeSurfaceOk"
        "SystemsLean.CompilePath"
        "COMPILE-PATH-SMOKE"
        "example"
        "RUNTIME-FS"
        "EMIT-BOUNDARY"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "FAIL-CLOSED"
        "HOST-COMPOSE"
      ];
      anyGroups = [
        [
          "verdictOf"
          "checkHost"
        ]
      ];
    }
    {
      # HOST-JOIN-MAP (P4): dual / JOIN honesty into compile-path readiness.
      rel = "src/systems/SystemsLean/JoinMap.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_JOIN_MAP_V0"
        "HOST-JOIN-MAP"
        "JOIN-MAP"
        "JOIN-ALG"
        "ConsumeToken"
        "joinAlgContractOk"
        "joinUnitCompileReady"
        "joinProgramCompileReady"
        "joinCompileReady"
        "SystemsLean.JoinMap"
        "JOIN-MAP-SMOKE"
        "example"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "FAIL-CLOSED"
        "HOST-COMPILE-PATH"
        "LINEAR-EXACT-ONCE"
        "src/idris2/examples/ConsumeToken.idr"
        "src/lean4/examples/ConsumeToken.lean"
      ];
      anyGroups = [
        [
          "verdictOf"
          "joinLinearCiteOk"
        ]
      ];
    }
    {
      # HOST-SELF-HOST (P5): self-host direction readiness from join map + surface.
      rel = "src/systems/SystemsLean/SelfHost.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_V0"
        "HOST-SELF-HOST"
        "SELF-HOST"
        "hostSurfaceOk"
        "selfHostUnitReady"
        "selfHostProgramReady"
        "selfHostReady"
        "SystemsLean.SelfHost"
        "SELF-HOST-SMOKE"
        "example"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "FAIL-CLOSED"
        "HOST-JOIN-MAP"
        "SLAKE_JOIN_MAP_V0"
        "HOST-COMPILE-PATH"
        "SLAKE_COMPILE_PATH_V1"
        "src/systems/SystemsLean.lean"
        "src/systems/SystemsLean/SelfHost.lean"
      ];
      anyGroups = [
        [
          "verdictOf"
          "packageRootPath"
        ]
      ];
    }
    {
      # HOST-SURFACE-MATRIX (P7): progressive superset surface inventory + gate.
      rel = "src/systems/SystemsLean/SurfaceMatrix.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SURFACE_MATRIX_V0"
        "HOST-SURFACE-MATRIX"
        "SURFACE-MATRIX"
        "matrixSurfaceOk"
        "matrixUnitReady"
        "matrixProgramReady"
        "matrixReady"
        "SystemsLean.SurfaceMatrix"
        "SURFACE-MATRIX-SMOKE"
        "example"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "FAIL-CLOSED"
        "HOST-SELF-HOST"
        "SLAKE_SELF_HOST_V0"
        "HOST-JOIN-MAP"
        "HOST-COMPILE-PATH"
        "present-partial"
        "open"
        "ConsumeToken"
        "ErasedIndex"
        "UnrestrictedShare"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "src/idris2/examples/ConsumeToken.idr"
        "src/lean4/examples/ConsumeToken.lean"
        "src/idris2/examples/ErasedIndex.idr"
        "src/lean4/examples/ErasedIndex.lean"
        "src/idris2/examples/UnrestrictedShare.idr"
        "src/lean4/examples/UnrestrictedShare.lean"
        "src/systems/surface-matrix.md"
        "src/systems/SystemsLean/SurfaceMatrix.lean"
      ];
      anyGroups = [
        [
          "verdictOf"
          "dualCiteOk"
        ]
      ];
    }
    {
      # SELF-HOST acceptance prose (SH0..SH5 partial + SH5 freestanding deepen + SH6 hold).
      rel = "src/systems/self-host.md";
      all = [
        "SELF-HOST"
        "SELF-HOST-ACCEPTANCE"
        "SLAKE_SELF_HOST_KERNEL_MULT_V0"
        "SELF-HOST-KERNEL-MULT"
        "SLAKE_SELF_HOST_EMIT_MULT_V0"
        "HOST-EMIT-MULT"
        "SLAKE_SELF_HOST_PARITY_MULT_V0"
        "HOST-PARITY-MULT"
        "SELF-HOST-PARITY-MULT"
        "SLAKE_SELF_HOST_KERNEL_LINEAR_V0"
        "SELF-HOST-KERNEL-LINEAR"
        "HOST-KERNEL-LINEAR"
        "SLAKE_SELF_HOST_PARITY_LINEAR_V0"
        "HOST-PARITY-LINEAR"
        "SELF-HOST-PARITY-LINEAR"
        "SLAKE_SELF_HOST_KERNEL_TYPES_V0"
        "SELF-HOST-KERNEL-TYPES"
        "HOST-KERNEL-TYPES"
        "SLAKE_SELF_HOST_PARITY_TYPES_V0"
        "HOST-PARITY-TYPES"
        "SELF-HOST-PARITY-TYPES"
        "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0"
        "SELF-HOST-KERNEL-PROGRAM"
        "HOST-KERNEL-PROGRAM"
        "SLAKE_SELF_HOST_PARITY_PROGRAM_V0"
        "HOST-PARITY-PROGRAM"
        "SELF-HOST-PARITY-PROGRAM"
        "SLAKE_SELF_HOST_KERNEL_EMIT_V0"
        "SELF-HOST-KERNEL-EMIT"
        "HOST-KERNEL-EMIT"
        "SLAKE_SELF_HOST_PARITY_EMIT_V0"
        "HOST-PARITY-EMIT"
        "SELF-HOST-PARITY-EMIT"
        "SLAKE_SELF_HOST_SELF_APPLY_V0"
        "HOST-SELF-APPLY"
        "SELF-HOST-SELF-APPLY"
        "SLAKE_SELF_HOST_SELF_APPLY_FS_V0"
        "HOST-SELF-APPLY-FS"
        "SELF-HOST-SELF-APPLY-FS"
        "SLAKE_SELF_HOST_LLVM_HOLD_V0"
        "HOST-LLVM-HOLD"
        "SELF-HOST-LLVM-HOLD"
        "HOST-PROVABLY-HOLD"
        "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0"
        "HOST-INVENTORY-CLOSE"
        "SELF-HOST-INVENTORY-CLOSE"
        "SLAKE_SELF_HOST_PRODUCT_PATH_V0"
        "HOST-PRODUCT-PATH"
        "SELF-HOST-PRODUCT-PATH"
        "product wire"
        "Host model"
        "not residual free"
        "Not PROVABLY"
      ];
    }
    {
      # Mult self-host kernel IR fixture (SH1 start).
      rel = "src/systems/SystemsLean/KernelMult.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_KERNEL_MULT_V0"
        "SELF-HOST-KERNEL-MULT"
        "SELF-HOST"
        "lowerMultKernel"
        "multKernelProgram"
        "multKernelReady"
        "kernelOk"
        "SystemsLean.KernelMult"
        "KERNEL-MULT-SMOKE"
        "example"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "FAIL-CLOSED-UNKNOWN-GRADE"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "ORDERED-IR-PROGRAM"
        "HOST-COMPILE-PATH"
        "src/systems/self-host.md"
        "src/systems/SystemsLean/KernelMult.lean"
      ];
      anyGroups = [
        [
          "unknownTagRejected"
          "kernelSurfaceOk"
        ]
      ];
    }
    {
      # Host-owned Mult freestanding product emit (SH2).
      rel = "src/systems/SystemsLean/EmitMult.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_EMIT_MULT_V0"
        "HOST-EMIT-MULT"
        "SELF-HOST-EMIT-MULT"
        "multHeaderFragment"
        "multBodyFragment"
        "emitMultReady"
        "SystemsLean.EmitMult"
        "EMIT-MULT-SMOKE"
        "HOST-EMIT-MULT-SMOKE"
        "example"
        "FAIL-CLOSED-UNKNOWN-GRADE"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "slake_mult_is_valid"
        "NON-SSOT"
        "src/systems/emit/host_emit_mult.ssot.txt"
        "src/systems/SystemsLean/EmitMult.lean"
        "UNIT_SURFACE"
        "Not freestanding emit"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding emit residual free"
      ];
      anyGroups = [
        [
          "emitMultOk"
          "headerHonestyOk"
        ]
      ];
    }
    {
      # Mult closed-loop parity host + product contracts (SH3).
      rel = "src/systems/SystemsLean/ParityMult.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_PARITY_MULT_V0"
        "HOST-PARITY-MULT"
        "SELF-HOST-PARITY-MULT"
        "multParityReady"
        "gradeParityOk"
        "SystemsLean.ParityMult"
        "PARITY-MULT-SMOKE"
        "HOST-PARITY-MULT-SMOKE"
        "example"
        "FAIL-CLOSED-UNKNOWN-GRADE"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "slake_mult_is_valid"
        "slake_mult_is_known"
        "slake_mult_name"
        "SELF-HOST-KERNEL-MULT"
        "HOST-EMIT-MULT"
        "src/systems/smoke/slake_behavioral_probe.c"
        "src/systems/SystemsLean/ParityMult.lean"
        "UNIT_SURFACE"
        "Not freestanding emit"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding emit residual free"
      ];
      anyGroups = [
        [
          "multParityOk"
          "paritySurfaceOk"
        ]
      ];
    }
    {
      # Linear self-host kernel IR + host compose path (SH4 start).
      rel = "src/systems/SystemsLean/KernelLinear.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_KERNEL_LINEAR_V0"
        "SELF-HOST-KERNEL-LINEAR"
        "HOST-KERNEL-LINEAR"
        "SELF-HOST"
        "lowerLinearKernel"
        "linearKernelProgram"
        "linearKernelReady"
        "linearHostPathReady"
        "linearKernelOk"
        "SystemsLean.KernelLinear"
        "KERNEL-LINEAR-SMOKE"
        "example"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "LINEAR-EXACT-ONCE"
        "JOIN-ALG"
        "ConsumeToken"
        "MULT-1"
        "HOST-COMPOSE"
        "ORDERED-IR-PROGRAM"
        "HOST-COMPILE-PATH"
        "CONSUME_TOKEN_HOST_V0"
        "slake_linear_consume"
        "src/systems/self-host.md"
        "src/systems/SystemsLean/KernelLinear.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
      ];
      anyGroups = [
        [
          "linearSurfaceOk"
          "linearMismatchRejected"
        ]
      ];
    }
    {
      # Linear freestanding path parity host + product contracts (Mult+Linear deepen).
      rel = "src/systems/SystemsLean/ParityLinear.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_PARITY_LINEAR_V0"
        "HOST-PARITY-LINEAR"
        "SELF-HOST-PARITY-LINEAR"
        "linearParityReady"
        "linearContractParityOk"
        "multLinearParityReady"
        "SystemsLean.ParityLinear"
        "PARITY-LINEAR-SMOKE"
        "HOST-PARITY-LINEAR-SMOKE"
        "example"
        "LINEAR-EXACT-ONCE"
        "JOIN-ALG"
        "ConsumeToken"
        "CONSUME_TOKEN_HOST_V0"
        "slake_linear_consume"
        "slake_linear_token_init"
        "slake_linear_token_is_live"
        "slake_linear_token_consume"
        "slake_consume_token_mint"
        "slake_consume_token_consume"
        "slake_consume_token_is_live"
        "HOST-KERNEL-LINEAR"
        "HOST-PARITY-MULT"
        "src/systems/smoke/slake_behavioral_probe.c"
        "src/systems/SystemsLean/ParityLinear.lean"
        "UNIT_SURFACE"
        "Not freestanding emit"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding emit residual free"
      ];
      anyGroups = [
        [
          "linearParityOk"
          "paritySurfaceOk"
          "productApiSurfaceOk"
        ]
      ];
    }
    {
      # Types self-host kernel IR + program path honesty (SH4 growth).
      rel = "src/systems/SystemsLean/KernelTypes.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_KERNEL_TYPES_V0"
        "SELF-HOST-KERNEL-TYPES"
        "HOST-KERNEL-TYPES"
        "SELF-HOST"
        "lowerTypesKernel"
        "typesKernelProgram"
        "typesKernelReady"
        "typesProgramPathReady"
        "typesKernelOk"
        "SystemsLean.KernelTypes"
        "KERNEL-TYPES-SMOKE"
        "example"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "FAIL-CLOSED-UNKNOWN-KIND"
        "TYPED_IR_V0"
        "COMMON-UNIVERSE"
        "ORDERED-IR-PROGRAM"
        "HOST-COMPILE-PATH"
        "foldWellTyped"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "slake_ir_node"
        "src/systems/self-host.md"
        "src/systems/SystemsLean/KernelTypes.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
      ];
      anyGroups = [
        [
          "typesSurfaceOk"
          "unknownKindRejected"
          "kindMultMismatchRejected"
        ]
      ];
    }
    {
      # Types freestanding path parity host + product contracts (Mult+Linear+Types).
      rel = "src/systems/SystemsLean/ParityTypes.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_PARITY_TYPES_V0"
        "HOST-PARITY-TYPES"
        "SELF-HOST-PARITY-TYPES"
        "typesParityReady"
        "typesContractParityOk"
        "multLinearTypesParityReady"
        "SystemsLean.ParityTypes"
        "PARITY-TYPES-SMOKE"
        "HOST-PARITY-TYPES-SMOKE"
        "example"
        "TYPED_IR_V0"
        "slake_ir_node"
        "slake_ir_node_init"
        "slake_ir_node_is_well_typed"
        "slake_ir_node_check_fail_closed"
        "kindMultMismatchRejected"
        "typesProgramPathReady"
        "HOST-KERNEL-TYPES"
        "HOST-PARITY-LINEAR"
        "HOST-PARITY-MULT"
        "src/systems/smoke/slake_behavioral_probe.c"
        "src/systems/SystemsLean/ParityTypes.lean"
        "UNIT_SURFACE"
        "Not freestanding emit"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding emit residual free"
      ];
      anyGroups = [
        [
          "typesParityOk"
          "paritySurfaceOk"
          "productApiSurfaceOk"
        ]
      ];
    }
    {
      # Program / graph / compose self-host kernel (SH4 remainder).
      rel = "src/systems/SystemsLean/KernelProgram.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0"
        "SELF-HOST-KERNEL-PROGRAM"
        "HOST-KERNEL-PROGRAM"
        "SELF-HOST"
        "lowerProgramKernel"
        "programKernelProgram"
        "programKernelReady"
        "programPathReady"
        "programGraphPathReady"
        "programComposePathReady"
        "programKernelOk"
        "SystemsLean.KernelProgram"
        "KERNEL-PROGRAM-SMOKE"
        "example"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "EMPTY-GRAPH-OK"
        "IR-GRAPH-EDGES"
        "HOST-COMPOSE"
        "ORDERED-IR-PROGRAM"
        "HOST-COMPILE-PATH"
        "foldWellTyped"
        "IR_PROGRAM_V0"
        "IR_GRAPH_EDGES_V0"
        "HOST_COMPOSE_V0"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "slake_ir_program"
        "slake_ir_graph"
        "slake_host_compose"
        "src/systems/self-host.md"
        "src/systems/SystemsLean/KernelProgram.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
      ];
      anyGroups = [
        [
          "programSurfaceOk"
          "programPathReady"
          "programGraphPathReady"
          "programComposePathReady"
        ]
      ];
    }
    {
      # Program freestanding path parity host + product contracts
      # (Mult+Linear+Types+Program).
      rel = "src/systems/SystemsLean/ParityProgram.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_PARITY_PROGRAM_V0"
        "HOST-PARITY-PROGRAM"
        "SELF-HOST-PARITY-PROGRAM"
        "programParityReady"
        "programContractParityOk"
        "multLinearTypesProgramParityReady"
        "SystemsLean.ParityProgram"
        "PARITY-PROGRAM-SMOKE"
        "HOST-PARITY-PROGRAM-SMOKE"
        "example"
        "IR_PROGRAM_V0"
        "IR_GRAPH_EDGES_V0"
        "HOST_COMPOSE_V0"
        "slake_ir_program"
        "slake_ir_program_init"
        "slake_ir_program_push"
        "slake_ir_program_is_well_typed"
        "slake_ir_program_check_fail_closed"
        "slake_ir_graph"
        "slake_ir_graph_init"
        "slake_ir_graph_push_node"
        "slake_ir_graph_add_edge"
        "slake_host_compose"
        "slake_host_compose_init"
        "slake_host_compose_mint"
        "slake_host_compose_consume"
        "programPathReady"
        "programGraphPathReady"
        "programComposePathReady"
        "HOST-KERNEL-PROGRAM"
        "HOST-PARITY-TYPES"
        "HOST-PARITY-LINEAR"
        "HOST-PARITY-MULT"
        "ORDERED-IR-PROGRAM"
        "src/systems/smoke/slake_behavioral_probe.c"
        "src/systems/SystemsLean/ParityProgram.lean"
        "UNIT_SURFACE"
        "Not freestanding emit"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding emit residual free"
      ];
      anyGroups = [
        [
          "programParityOk"
          "paritySurfaceOk"
          "productApiSurfaceOk"
        ]
      ];
    }
    {
      # Freestanding codegen host honesty (SH4 remainder: plan/apply/body).
      rel = "src/systems/SystemsLean/KernelEmit.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_KERNEL_EMIT_V0"
        "SELF-HOST-KERNEL-EMIT"
        "HOST-KERNEL-EMIT"
        "SELF-HOST"
        "lowerEmitCompose"
        "emitHost"
        "emitKernelReady"
        "emitPlanPathReady"
        "emitApplyPathReady"
        "emitBodyPathReady"
        "emitKernelOk"
        "SystemsLean.KernelEmit"
        "KERNEL-EMIT-SMOKE"
        "example"
        "EMIT-PLAN"
        "EMIT-APPLY"
        "EMIT-BODY"
        "HOST-EMIT-SSOT"
        "HOST-EMIT-MULT"
        "HOST-KERNEL-PROGRAM"
        "programKernelReady"
        "emitMultReady"
        "planOk"
        "applyOk"
        "bodyOk"
        "EMIT_PLAN_V0"
        "EMIT_APPLY_V0"
        "EMIT_BODY_V0"
        "RUNTIME-FS"
        "FAIL-CLOSED"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "slake_emit_plan"
        "slake_emit_apply"
        "slake_emit_body"
        "src/systems/self-host.md"
        "src/systems/SystemsLean/KernelEmit.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
      ];
      anyGroups = [
        [
          "emitSurfaceOk"
          "emitPlanPathReady"
          "emitApplyPathReady"
          "emitBodyPathReady"
        ]
      ];
    }
    {
      # Emit freestanding path parity host + product contracts
      # (Mult+Linear+Types+Program+Emit).
      rel = "src/systems/SystemsLean/ParityEmit.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_PARITY_EMIT_V0"
        "HOST-PARITY-EMIT"
        "SELF-HOST-PARITY-EMIT"
        "emitParityReady"
        "emitContractParityOk"
        "multLinearTypesProgramEmitParityReady"
        "SystemsLean.ParityEmit"
        "PARITY-EMIT-SMOKE"
        "HOST-PARITY-EMIT-SMOKE"
        "example"
        "EMIT_PLAN_V0"
        "EMIT_APPLY_V0"
        "EMIT_BODY_V0"
        "HOST-EMIT-SSOT"
        "HOST-EMIT-MULT"
        "slake_emit_plan"
        "slake_emit_plan_id"
        "slake_emit_plan_from_compose"
        "slake_emit_plan_is_ready"
        "slake_emit_apply"
        "slake_emit_apply_id"
        "slake_emit_apply_from_compose"
        "slake_emit_apply_is_valid"
        "slake_emit_body"
        "slake_emit_body_id"
        "slake_emit_body_from_compose"
        "slake_emit_body_is_valid"
        "emitPlanPathReady"
        "emitApplyPathReady"
        "emitBodyPathReady"
        "emitMultReady"
        "HOST-KERNEL-EMIT"
        "HOST-PARITY-PROGRAM"
        "HOST-PARITY-TYPES"
        "HOST-PARITY-LINEAR"
        "HOST-PARITY-MULT"
        "RUNTIME-FS"
        "FAIL-CLOSED"
        "src/systems/smoke/slake_behavioral_probe.c"
        "src/systems/SystemsLean/ParityEmit.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding emit residual free"
      ];
      anyGroups = [
        [
          "emitParityOk"
          "paritySurfaceOk"
          "productApiSurfaceOk"
        ]
      ];
    }
    {
      # Compiler self-application readiness (SH5 partial).
      rel = "src/systems/SystemsLean/SelfApply.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_SELF_APPLY_V0"
        "HOST-SELF-APPLY"
        "SELF-HOST-SELF-APPLY"
        "SELF-HOST"
        "selfApplyReady"
        "kernelRebuildsKernel"
        "multKernelSideReady"
        "linearKernelSideReady"
        "typesKernelSideReady"
        "programKernelSideReady"
        "emitKernelSideReady"
        "selfApplyOk"
        "SystemsLean.SelfApply"
        "SELF-APPLY-SMOKE"
        "HOST-SELF-APPLY-SMOKE"
        "example"
        "HOST-PARITY-MULT"
        "SELF-HOST-KERNEL-LINEAR"
        "SELF-HOST-KERNEL-TYPES"
        "SELF-HOST-KERNEL-PROGRAM"
        "SELF-HOST-KERNEL-EMIT"
        "multParityReady"
        "linearKernelReady"
        "typesKernelReady"
        "programKernelReady"
        "emitKernelReady"
        "src/systems/self-host.md"
        "src/systems/SystemsLean/SelfApply.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding emit residual free"
      ];
      anyGroups = [
        [
          "selfApplySurfaceOk"
          "kernelRebuildsKernel"
        ]
      ];
    }
    {
      # Freestanding self-application deepen (SH5 freestanding deepen partial).
      # Fail-closed pins: freestandingProductSelfHostComplete must remain := false.
      # Composes freestanding Mult..Emit parity ladder (ParityEmit) into readiness.
      rel = "src/systems/SystemsLean/SelfApplyFs.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_SELF_APPLY_FS_V0"
        "HOST-SELF-APPLY-FS"
        "SELF-HOST-SELF-APPLY-FS"
        "SELF-HOST"
        "freestandingExtractPathReady"
        "freestandingBodyPathReady"
        "freestandingSelfApplyPathReady"
        "freestandingParityLadderReady"
        "freestandingEmitParityReady"
        "freestandingSelfApplyReady"
        "freestandingProductSelfHostComplete"
        "selfApplyFsDoesNotComplete"
        "selfApplyFsOk"
        "SystemsLean.SelfApplyFs"
        "SELF-APPLY-FS-SMOKE"
        "HOST-SELF-APPLY-FS-SMOKE"
        "example"
        "HOST-SELF-APPLY"
        "selfApplyReady"
        "HOST-PARITY-EMIT"
        "SELF-HOST-PARITY-EMIT"
        "SLAKE_SELF_HOST_PARITY_EMIT_V0"
        "emitParityReady"
        "multLinearTypesProgramEmitParityReady"
        "RUNTIME-FS"
        "EMIT-BOUNDARY"
        "HOST-EMIT-SSOT"
        "EMIT_BODY_V0"
        "HOST-EMIT-MULT"
        "SELF-HOST-KERNEL-EMIT"
        "lowerEmitCompose"
        "extractOkFs"
        "bodyOk"
        "emitMultReady"
        "import SystemsLean.ParityEmit"
        "src/systems/self-host.md"
        "src/systems/SystemsLean/SelfApplyFs.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding product"
        "Not freestanding emit residual free"
        "Not llvm unlocked"
        # Complete-claim pin (presence fail-closed without Lake): def + smoke.
        "def freestandingProductSelfHostComplete : Bool := false"
        "example : freestandingProductSelfHostComplete = false"
        "example : freestandingSelfApplyReady = true"
        "example : selfApplyFsDoesNotComplete = true"
        "example : freestandingParityLadderReady = true"
        "example : freestandingEmitParityReady = true"
        # Structural compose pin: readiness must fold Mult..Emit parity ladder
        # (name tokens alone can survive if the conjunct is dropped from the def).
        "&& freestandingParityLadderReady"
      ];
      anyGroups = [
        [
          "selfApplyFsSurfaceOk"
          "freestandingSelfApplyPathReady"
          "freestandingParityLadderReady"
        ]
      ];
    }
    {
      # llvm / PROVABLY hold gate (SH6 held, documented -- not unlock).
      # Fail-closed pins: unlock/complete defs must remain := false (not name-only).
      rel = "src/systems/SystemsLean/LlvmHold.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_LLVM_HOLD_V0"
        "HOST-LLVM-HOLD"
        "SELF-HOST-LLVM-HOLD"
        "HOST-PROVABLY-HOLD"
        "SELF-HOST"
        "llvmHoldReady"
        "sh6HoldReady"
        "llvmUnlocked"
        "provablyUnlocked"
        "freestandingProductSelfHostComplete"
        "selfApplyDoesNotUnlockLlvm"
        "holdHonestyOk"
        "llvmHoldOk"
        "SystemsLean.LlvmHold"
        "LLVM-HOLD-SMOKE"
        "HOST-LLVM-HOLD-SMOKE"
        "example"
        "HOST-SELF-APPLY"
        "selfApplyReady"
        "src/systems/self-host.md"
        "src/systems/SystemsLean/LlvmHold.lean"
        "out/llvm-ir"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding emit residual free"
        "Not llvm unlocked"
        # Hold-contract pins (presence fail-closed without Lake): defs + smoke.
        "def llvmUnlocked : Bool := false"
        "def provablyUnlocked : Bool := false"
        "def freestandingProductSelfHostComplete : Bool := false"
        "example : llvmUnlocked = false"
        "example : provablyUnlocked = false"
        "example : freestandingProductSelfHostComplete = false"
        "example : llvmHoldReady = true"
        "example : sh6HoldReady = true"
      ];
      anyGroups = [
        [
          "llvmHoldSurfaceOk"
          "holdHonestyOk"
        ]
      ];
    }
    {
      # Host inventory close readiness (after Mult..Emit parity + SelfApplyFs + SH6 hold).
      # Fail-closed pins: residual free / complete / unlock claims must remain false.
      # Structural compose pins: readiness must fold freestandingSelfApplyReady +
      # llvmHoldReady (name tokens alone can survive if conjuncts are dropped).
      rel = "src/systems/SystemsLean/InventoryClose.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0"
        "HOST-INVENTORY-CLOSE"
        "SELF-HOST-INVENTORY-CLOSE"
        "SELF-HOST"
        "inventoryCloseReady"
        "inventoryCloseSurfaceOk"
        "inventoryPartialCarryHonest"
        "inventoryCloseDoesNotMeanResidualFree"
        "residualFreeClaimed"
        "productSelfHostCompleteClaimed"
        "inventoryCloseOk"
        "SystemsLean.InventoryClose"
        "INVENTORY-CLOSE-SMOKE"
        "HOST-INVENTORY-CLOSE-SMOKE"
        "example"
        "HOST-SELF-APPLY-FS"
        "HOST-LLVM-HOLD"
        "CLOSABLE-MISS-COUNT-0"
        "HOST-PARTIAL-INVENTORY"
        "intentional PARTIAL"
        "freestandingSelfApplyReady"
        "llvmHoldReady"
        "freestandingProductSelfHostComplete"
        "llvmUnlocked"
        "provablyUnlocked"
        "import SystemsLean.SelfApplyFs"
        "import SystemsLean.LlvmHold"
        "src/systems/self-host.md"
        "src/systems/host-partial-inventory.md"
        "src/systems/SystemsLean/InventoryClose.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding product"
        "Not freestanding emit residual free"
        "Not llvm unlocked"
        # Claim pins (presence fail-closed without Lake): defs + smoke.
        "def residualFreeClaimed : Bool := false"
        "def productSelfHostCompleteClaimed : Bool := false"
        "example : residualFreeClaimed = false"
        "example : productSelfHostCompleteClaimed = false"
        "example : inventoryCloseReady = true"
        "example : inventoryCloseDoesNotMeanResidualFree = true"
        "example : inventoryPartialCarryHonest = true"
        # Structural compose pins: readiness must fold FS self-apply + llvm hold.
        "SelfApplyFs.freestandingSelfApplyReady"
        "LlvmHold.llvmHoldReady"
        "&& inventoryCloseSurfaceOk"
        "&& inventoryPartialCarryHonest"
        "&& !SelfApplyFs.freestandingProductSelfHostComplete"
        "&& !LlvmHold.llvmUnlocked"
        "&& !LlvmHold.provablyUnlocked"
      ];
      anyGroups = [
        [
          "inventoryCloseSurfaceOk"
          "inventoryPartialCarryHonest"
          "inventoryCloseReady"
        ]
      ];
    }
    {
      # Freestanding product path readiness (after HOST-INVENTORY-CLOSE).
      # Fail-closed pins: residual free / complete / unlock claims stay false.
      # Structural compose pins: readiness must fold inventoryCloseReady + unit
      # path + program path + surface (name tokens alone can survive if dropped).
      rel = "src/systems/SystemsLean/ProductPath.lean";
      all = [
        "SYSTEMS_LEAN_HOST"
        "SLAKE_SELF_HOST_PRODUCT_PATH_V0"
        "HOST-PRODUCT-PATH"
        "SELF-HOST-PRODUCT-PATH"
        "SELF-HOST"
        "productPathReady"
        "productPathSurfaceOk"
        "freestandingUnitProductPathReady"
        "freestandingProgramProductPathReady"
        "freestandingProductPathReady"
        "productPathDoesNotComplete"
        "productPathDoesNotMeanResidualFree"
        "residualFreeClaimed"
        "productSelfHostCompleteClaimed"
        "productPathOk"
        "SystemsLean.ProductPath"
        "PRODUCT-PATH-SMOKE"
        "HOST-PRODUCT-PATH-SMOKE"
        "example"
        "HOST-INVENTORY-CLOSE"
        "HOST-SELF-APPLY-FS"
        "HOST-COMPILE-PATH"
        "inventoryCloseReady"
        "unitCompileReady"
        "programCompileReady"
        "extractOkFs"
        "lowerEmitCompose"
        "lowerProgramKernel"
        "RUNTIME-FS"
        "EMIT-BOUNDARY"
        "EMIT_BODY_V0"
        "HOST-EMIT-SSOT"
        "HOST-EMIT-MULT"
        "EMPTY-PROGRAM-FAIL-CLOSED"
        "freestandingProductSelfHostComplete"
        "llvmUnlocked"
        "provablyUnlocked"
        "import SystemsLean.InventoryClose"
        "import SystemsLean.CompilePath"
        "import SystemsLean.KernelEmit"
        "import SystemsLean.KernelProgram"
        "import SystemsLean.HostCompose"
        "import SystemsLean.IrProgram"
        "import SystemsLean.SelfApplyFs"
        "import SystemsLean.LlvmHold"
        "src/systems/self-host.md"
        "src/systems/host-partial-inventory.md"
        "src/systems/SystemsLean/ProductPath.lean"
        "UNIT_SURFACE"
        "Not freestanding residual free"
        "Not PROVABLY"
        "Not freestanding product"
        "Not freestanding emit residual free"
        "Not llvm unlocked"
        # Claim pins (presence fail-closed without Lake): defs + smoke.
        "def residualFreeClaimed : Bool := false"
        "def productSelfHostCompleteClaimed : Bool := false"
        "example : residualFreeClaimed = false"
        "example : productSelfHostCompleteClaimed = false"
        "example : productPathReady = true"
        "example : productPathDoesNotComplete = true"
        "example : productPathDoesNotMeanResidualFree = true"
        "example : freestandingUnitProductPathReady = true"
        "example : freestandingProgramProductPathReady = true"
        # Structural compose pins: readiness must fold inventory close + paths.
        "InventoryClose.inventoryCloseReady"
        "freestandingUnitProductPathReady"
        "freestandingProgramProductPathReady"
        "&& productPathSurfaceOk"
        "&& !residualFreeClaimed"
        "&& !productSelfHostCompleteClaimed"
        "&& !SelfApplyFs.freestandingProductSelfHostComplete"
        "&& !LlvmHold.llvmUnlocked"
        "&& !LlvmHold.provablyUnlocked"
        "CompilePath.unitCompileReady HostCompose.empty"
        "KernelEmit.unmintedEmitCompose"
        "KernelEmit.lowerEmitCompose"
        "KernelProgram.lowerProgramKernel"
        "CompilePath.programCompileReady IrProgram.empty"
      ];
      anyGroups = [
        [
          "productPathSurfaceOk"
          "freestandingUnitProductPathReady"
          "freestandingProgramProductPathReady"
          "productPathReady"
        ]
      ];
    }
    {
      # HOST-EMIT-SSOT durable artifact: empty fragment + dialect keys.
      rel = "src/systems/emit/host_emit_body_fragment.ssot.txt";
      all = [
        "HOST-EMIT-SSOT"
        "EMPTY_FRAGMENT"
        "HEADER_OPEN"
        "HEADER_E"
        "HEADER_CLOSE"
        "TAG_OPEN"
        "TAG_MULT"
        "TAG_KIND"
        "TAG_CLOSE"
        "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */"
        "NON-SSOT"
        "buildFragment"
      ];
    }
    {
      # HOST-EMIT-MULT durable Mult product text (SH2).
      rel = "src/systems/emit/host_emit_mult.ssot.txt";
      all = [
        "HOST-EMIT-MULT"
        "NON-SSOT"
        "SELF-HOST-EMIT-MULT"
        "SLAKE_SELF_HOST_EMIT_MULT_V0"
        "MULT_NAME_0"
        "MULT_NAME_1"
        "MULT_NAME_OMEGA"
        "MULT-0"
        "MULT-1"
        "MULT-OMEGA"
        "slake_mult_is_valid"
        "FAIL-CLOSED-UNKNOWN-GRADE"
        "MULT_C_HEADER_BEGIN"
        "MULT_C_BODY_BEGIN"
        "EmitMult"
      ];
    }
    {
      rel = "src/systems/SystemsLean.lean";
      all = [
        "import SystemsLean.Mult"
        "import SystemsLean.Linear"
        "import SystemsLean.Types"
        "import SystemsLean.IrProgram"
        "import SystemsLean.Erasure"
        "import SystemsLean.Extract"
        "import SystemsLean.IrGraph"
        "import SystemsLean.HostCompose"
        "import SystemsLean.EmitPlan"
        "import SystemsLean.EmitApply"
        "import SystemsLean.EmitBody"
        "import SystemsLean.CompilePath"
        "import SystemsLean.JoinMap"
        "import SystemsLean.SelfHost"
        "import SystemsLean.SurfaceMatrix"
        "import SystemsLean.KernelMult"
        "import SystemsLean.EmitMult"
        "import SystemsLean.ParityMult"
        "import SystemsLean.KernelLinear"
        "import SystemsLean.ParityLinear"
        "import SystemsLean.KernelTypes"
        "import SystemsLean.ParityTypes"
        "import SystemsLean.KernelProgram"
        "import SystemsLean.ParityProgram"
        "import SystemsLean.KernelEmit"
        "import SystemsLean.ParityEmit"
        "import SystemsLean.SelfApply"
        "import SystemsLean.SelfApplyFs"
        "import SystemsLean.LlvmHold"
        "import SystemsLean.InventoryClose"
        "import SystemsLean.ProductPath"
      ];
    }
  ];
}
