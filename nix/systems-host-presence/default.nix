# SPDX-License-Identifier: Unlicense
# Pure Nix systems host presence: skeleton files, unit-surface tokens,
# SYSTEMS_LEAN_HOST Lean modules (Mult..ProductPath), and tree-wide banned-jargon
# walk under src/systems. Fail-closed on missing paths, honesty tokens, or
# forbidden jargon. No bash, no ripgrep, no Python.
#
#   import ./systems-host-presence { inherit lib; root = novelSourceOrRepo; }
#   -> { ok, violations, summary }
#
# Specs data: ./specs.nix. Flake: checks.systems-host-presence.
# Live gate (does not require git-tracked flake store): just systems-host
# Shell check.sh no longer owns host presence or tree-wide jargon.
{ lib, root }:
let
  specs = import ./specs.nix;
  inherit (specs)
    requiredFiles
    hostLeans
    unitSurfaceSpecs
    hostSpecs
    jargonWalkRoot
    jargonWalkSkipDirs
    jargonWalkExtensions
    jargonForbidden
    ;

  exists = rel: builtins.pathExists (root + "/${rel}");
  readRel =
    rel:
    if exists rel then
      builtins.readFile (root + "/${rel}")
    else
      null;

  has = needle: hay: lib.hasInfix needle hay;

  # Every token in `all` must appear; each list in `anyGroups` needs at least one.
  checkContent =
    rel: content:
    {
      all ? [ ],
      anyGroups ? [ ],
    }:
    (lib.concatMap (
      t: if has t content then [ ] else [ "${rel}: missing token ${t}" ]
    ) all)
    ++ (lib.concatMap (
      group:
      if lib.any (t: has t content) group then
        [ ]
      else
        [ "${rel}: missing any of [${lib.concatStringsSep " | " group}]" ]
    ) anyGroups);

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
      }
  ) (unitSurfaceSpecs ++ hostSpecs);

  # Tree-wide banned jargon under src/systems (md/slake/lean/c/h).
  # Case-folded substring, fail-closed (stricter than word-boundary): can
  # false-positive on dipole/polemic/spines -- tighten only if a real hit appears.
  # Covers host Lean (no separate host-only pass). Skip Lake/VCS/cache dirs.
  # Former shell mill in check.sh; residual shell no longer greps jargon.
  hasJargonExt =
    name: lib.any (ext: lib.hasSuffix ext name) jargonWalkExtensions;

  walkJargon =
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
          if lib.elem name jargonWalkSkipDirs then
            [ ]
          else
            walkJargon child
        else if ty == "regular" && hasJargonExt name then
          [ child ]
        else
          [ ]
      ) (builtins.attrNames entries);

  jargonPaths = walkJargon jargonWalkRoot;

  jargonViolations = lib.concatMap (
    rel:
    let
      content = readRel rel;
      lower = if content == null then "" else lib.toLower content;
    in
    if content == null then
      [ "jargon walk: unreadable ${rel}" ]
    else
      lib.concatMap (
        word:
        if has word lower then
          [ "${rel}: forbidden jargon '${word}'" ]
        else
          [ ]
      ) jargonForbidden
  ) jargonPaths;

  violations = fileViolations ++ contentViolations ++ jargonViolations;
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
      "systems-host-presence OK (${toString (builtins.length requiredFiles)} required paths; unit-surface + SYSTEMS_LEAN_HOST Mult..ProductPath tokens; tree-wide jargon ban files=${toString (builtins.length jargonPaths)})"
    else
      "systems-host-presence FAILED:\n" + lib.concatStringsSep "\n" shown + more;
in
{
  inherit
    ok
    violations
    summary
    requiredFiles
    hostLeans
    jargonPaths
    ;
}
