# SPDX-License-Identifier: Unlicense
# Data only: dynamic freestanding unit walk under src/systems.
# Imported by ./specs.nix. Every *.lean / *.slake needs SKELETON or UNIT_SURFACE.
{
  unitWalkRoot = "src/systems";
  # Package-local Lake / VCS / cache (novel-source only filters repo-root .lake/).
  unitWalkSkipDirs = [
    ".lake"
    ".git"
    ".cache"
  ];
  unitWalkExtensions = [
    ".lean"
    ".slake"
  ];
  unitSurfaceRequiredAny = [
    "MULT-0"
    "MULT-1"
    "MULT-OMEGA"
    "JOIN-ALG"
    "ConsumeToken"
    "EDGE-PROP"
    "ERASE-PROP"
    "RUNTIME-FS"
    "EDGE-RUNTIME"
    "linear resource"
    "erasure rule"
    "extract boundary"
  ];
  unitSurfaceRequiredAll = [
    "Not freestanding emit"
  ];
  unitSurfaceModuleAny = [
    "module "
    "namespace "
  ];
}
