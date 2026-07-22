/-
  SYSTEMS_LEAN_HOST partial -- Systems Lean package root (classic elaborator).
  Imports Mult + Linear + Types + ordered IR program + Erasure + Extract +
  IrGraph + HostCompose + EmitPlan + EmitApply + EmitBody + CompilePath +
  JoinMap + SelfHost + SurfaceMatrix + KernelMult + EmitMult + ParityMult +
  KernelLinear + ParityLinear + KernelTypes + ParityTypes + KernelProgram +
  ParityProgram + KernelEmit + ParityEmit + SelfApply + SelfApplyFs + LlvmHold +
  InventoryClose + ProductPath host modules (unit-surface markers live on those
  files).
  SKELETON package root only (import shell; not freestanding residual free).
  Not freestanding residual free. Not product C. Not PROVABLY.
  Not freestanding emit residual free. Not llvm unlocked (SH6 hold).
  Inventory close is readiness only (not residual free).
  Product path is readiness only (not freestanding product self-host complete).
  Module: SystemsLean
-/

import SystemsLean.Mult
import SystemsLean.Linear
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.IrGraph
import SystemsLean.Erasure
import SystemsLean.Extract
import SystemsLean.HostCompose
import SystemsLean.EmitPlan
import SystemsLean.EmitApply
import SystemsLean.EmitBody
import SystemsLean.CompilePath
import SystemsLean.JoinMap
import SystemsLean.SelfHost
import SystemsLean.SurfaceMatrix
import SystemsLean.KernelMult
import SystemsLean.EmitMult
import SystemsLean.ParityMult
import SystemsLean.KernelLinear
import SystemsLean.ParityLinear
import SystemsLean.KernelTypes
import SystemsLean.ParityTypes
import SystemsLean.KernelProgram
import SystemsLean.ParityProgram
import SystemsLean.KernelEmit
import SystemsLean.ParityEmit
import SystemsLean.SelfApply
import SystemsLean.SelfApplyFs
import SystemsLean.LlvmHold
import SystemsLean.InventoryClose
import SystemsLean.ProductPath
