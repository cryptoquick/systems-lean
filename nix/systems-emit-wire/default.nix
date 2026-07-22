# SPDX-License-Identifier: Unlicense
# Pure Nix systems emit-wire presence: compile/emit drivers, freestanding emit
# product tokens (UNIT_TRANSLATION_V0 through EMIT_BODY_V0), UNIT_DEEPEN_V1
# units + companions, optional release surface, dynamic unit-surface walk, and
# required hosted behavioral probe path (smoke debt under src/systems/smoke/;
# not product emit residual). Fail-closed on missing required paths or honesty
# tokens. No bash, no ripgrep, no Python.
#
#   import ./systems-emit-wire { inherit lib; root = novelSourceOrRepo; }
#   -> { ok, violations, summary }
#
# Specs data: ./specs.nix. Flake: checks.systems-emit-wire.
# Live gate (does not require git-tracked flake store): just systems-emit-wire
# Shell check.sh no longer owns these static mills (driver runs + link/run smoke remain).
{ lib, root }:
let
  specs = import ./specs.nix;
  inherit (specs)
    requiredFiles
    optionalFiles
    contentSpecs
    optionalContentSpecs
    unitWalkRoot
    unitWalkSkipDirs
    unitWalkExtensions
    unitSurfaceRequiredAny
    unitSurfaceRequiredAll
    unitSurfaceModuleAny
    ;

  exists = rel: builtins.pathExists (root + "/${rel}");
  readRel =
    rel:
    if exists rel then
      builtins.readFile (root + "/${rel}")
    else
      null;

  has = needle: hay: lib.hasInfix needle hay;
  hasI = needle: hay: lib.hasInfix (lib.toLower needle) (lib.toLower hay);

  # all / anyGroups (case-sensitive) + insensitive variants + none (forbidden).
  checkContent =
    rel: content:
    {
      all ? [ ],
      anyGroups ? [ ],
      allInsensitive ? [ ],
      anyGroupsInsensitive ? [ ],
      none ? [ ],
      noneInsensitive ? [ ],
    }:
    (lib.concatMap (
      t: if has t content then [ ] else [ "${rel}: missing token ${t}" ]
    ) all)
    ++ (lib.concatMap (
      t: if hasI t content then [ ] else [ "${rel}: missing token (ci) ${t}" ]
    ) allInsensitive)
    ++ (lib.concatMap (
      group:
      if lib.any (t: has t content) group then
        [ ]
      else
        [ "${rel}: missing any of [${lib.concatStringsSep " | " group}]" ]
    ) anyGroups)
    ++ (lib.concatMap (
      group:
      if lib.any (t: hasI t content) group then
        [ ]
      else
        [ "${rel}: missing any of (ci) [${lib.concatStringsSep " | " group}]" ]
    ) anyGroupsInsensitive)
    ++ (lib.concatMap (
      t: if has t content then [ "${rel}: forbidden token ${t}" ] else [ ]
    ) none)
    ++ (lib.concatMap (
      t: if hasI t content then [ "${rel}: forbidden token (ci) ${t}" ] else [ ]
    ) noneInsensitive);

  fileViolations = lib.concatMap (
    rel: if exists rel then [ ] else [ "missing file: ${rel}" ]
  ) requiredFiles;

  contentViolations = lib.concatMap (
    spec:
    let
      content = readRel spec.rel;
    in
    if content == null then
      [ ]
    else
      checkContent spec.rel content {
        all = spec.all or [ ];
        anyGroups = spec.anyGroups or [ ];
        allInsensitive = spec.allInsensitive or [ ];
        anyGroupsInsensitive = spec.anyGroupsInsensitive or [ ];
        none = spec.none or [ ];
        noneInsensitive = spec.noneInsensitive or [ ];
      }
  ) contentSpecs;

  # Optional release: missing is OK; present must satisfy tokens.
  optionalContentViolations = lib.concatMap (
    spec:
    let
      content = readRel spec.rel;
    in
    if content == null then
      [ ]
    else
      checkContent spec.rel content {
        all = spec.all or [ ];
        anyGroups = spec.anyGroups or [ ];
        allInsensitive = spec.allInsensitive or [ ];
        anyGroupsInsensitive = spec.anyGroupsInsensitive or [ ];
        none = spec.none or [ ];
        noneInsensitive = spec.noneInsensitive or [ ];
      }
  ) optionalContentSpecs;

  # --- dynamic unit walk: *.lean / *.slake under src/systems ---
  hasExt =
    name: lib.any (ext: lib.hasSuffix ext name) unitWalkExtensions;

  # Recurse; return list of relative paths from repo root.
  # unitWalkSkipDirs (.lake, .git, ...) from specs -- avoid Lake build noise.
  walkUnits =
    rel:
    let
      abs = root + "/${rel}";
    in
    if !(builtins.pathExists abs) then
      [ ]
    else
      let
        entries = builtins.readDir abs;
      in
      lib.concatMap (
        name:
        let
          ty = entries.${name};
          child = "${rel}/${name}";
        in
        if ty == "directory" then
          if lib.elem name unitWalkSkipDirs then
            [ ]
          else
            walkUnits child
        else if ty == "regular" && hasExt name then
          [ child ]
        else
          [ ]
      ) (builtins.attrNames entries);

  unitPaths = walkUnits unitWalkRoot;

  unitFileViolations = lib.concatMap (
    rel:
    let
      content = readRel rel;
      hasUs = content != null && has "UNIT_SURFACE" content;
      hasSk = content != null && has "SKELETON" content;
    in
    if content == null then
      [ "unit walk: unreadable ${rel}" ]
    else if !hasUs && !hasSk then
      [ "${rel}: missing SKELETON or UNIT_SURFACE honesty marker" ]
    else if hasUs then
      (if lib.any (t: has t content) unitSurfaceModuleAny then
        [ ]
      else
        [ "${rel}: UNIT_SURFACE missing module/namespace name" ])
      ++ (lib.concatMap (
        t: if has t content then [ ] else [ "${rel}: UNIT_SURFACE missing '${t}'" ]
      ) unitSurfaceRequiredAll)
      ++ (
        if lib.any (t: has t content) unitSurfaceRequiredAny then
          [ ]
        else
          [
            "${rel}: UNIT_SURFACE missing IR contract id (MULT-* / JOIN-ALG / erasure / extract / ...)"
          ]
      )
    else
      [ ]
  ) unitPaths;

  unitSurfaceCount = lib.length (
    lib.filter (
      rel:
      let
        c = readRel rel;
      in
      c != null && has "UNIT_SURFACE" c
    ) unitPaths
  );

  unitCountViolations =
    if unitPaths == [ ] then
      [ ]
    else if unitSurfaceCount == 0 then
      [ "unit walk: at least one UNIT_SURFACE freestanding unit required (beyond pure SKELETON)" ]
    else
      [ ];

  violations =
    fileViolations
    ++ contentViolations
    ++ optionalContentViolations
    ++ unitFileViolations
    ++ unitCountViolations;

  ok = violations == [ ];
  maxShow = 40;
  shown = lib.take maxShow violations;
  more =
    let
      n = builtins.length violations;
    in
    if n > maxShow then "\n... and ${toString (n - maxShow)} more" else "";
  summary =
    if ok then
      "systems-emit-wire OK (${toString (builtins.length requiredFiles)} required paths; "
      + "compile/emit drivers + UNIT_DEEPEN_V1 + emit product UNIT_TRANSLATION..EMIT_BODY; "
      + "unit-surface count=${toString unitSurfaceCount}; optional release checked if present)"
    else
      "systems-emit-wire FAILED:\n" + lib.concatStringsSep "\n" shown + more;
in
{
  inherit
    ok
    violations
    summary
    requiredFiles
    optionalFiles
    unitPaths
    unitSurfaceCount
    ;
}
