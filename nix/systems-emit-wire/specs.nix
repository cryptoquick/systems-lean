# SPDX-License-Identifier: Unlicense
# Join only: import data slices for systems-emit-wire (one flake check / just recipe).
# Edit job-specific files when honesty tokens change:
#   emit-product.nix  -- drivers, emit product APIs/stages, optional release
#   unit-deepen.nix   -- UNIT_DEEPEN_V1 units + companions
#   unit-walk.nix     -- dynamic SKELETON|UNIT_SURFACE walk
# Imported by ./default.nix. No bash, no competing gate module names.
let
  emit = import ./emit-product.nix;
  deepen = import ./unit-deepen.nix;
  walk = import ./unit-walk.nix;
in
{
  inherit (emit)
    emitH
    emitC
    releaseH
    releaseC
    behavioralProbe
    unitTranslationApis
    optionalFiles
    optionalContentSpecs
    ;

  inherit (walk)
    unitWalkRoot
    unitWalkSkipDirs
    unitWalkExtensions
    unitSurfaceRequiredAny
    unitSurfaceRequiredAll
    unitSurfaceModuleAny
    ;

  requiredFiles = emit.requiredDriverAndEmit ++ deepen.requiredDeepenFiles;

  contentSpecs = emit.contentSpecs ++ deepen.contentSpecs;
}
