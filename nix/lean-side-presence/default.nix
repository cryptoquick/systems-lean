# SPDX-License-Identifier: Unlicense
# Pure Nix Lean-side dual presence: required files, honesty tokens, and
# banned-jargon walk under src/lean4/examples/*.lean. Fail-closed on missing
# paths, missing tokens, or forbidden jargon. No bash, no ripgrep, no Python.
#
#   import ./lean-side-presence { inherit lib; root = novelSourceOrRepo; }
#   -> { ok, violations, summary }
#
# Specs data: ./specs.nix. Flake: checks.lean-side-presence.
# Live gate (does not require git-tracked flake store): just lean-side
# Thin src/lean4/check.sh retains optional Lake elaborator only.
{ lib, root }:
let
  specs = import ./specs.nix;
  inherit (specs)
    requiredFiles
    contentSpecs
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
  ) contentSpecs;

  # Banned jargon under examples/*.lean. Case-folded substring, fail-closed
  # (stricter than word-boundary; same style as systems-host-presence).
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
      "lean-side-presence OK (${toString (builtins.length requiredFiles)} required paths; content tokens; jargon ban files=${toString (builtins.length jargonPaths)})"
    else
      "lean-side-presence FAILED:\n" + lib.concatStringsSep "\n" shown + more;
in
{
  inherit
    ok
    violations
    summary
    requiredFiles
    jargonPaths
    ;
}
