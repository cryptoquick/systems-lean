# SPDX-License-Identifier: Unlicense
# Path probes for progress milestones (pure Nix).
{ lib, root }:
rec {
  exists = rel: builtins.pathExists (root + "/${rel}");

  dirNontrivial =
    rel:
    let
      p = root + "/${rel}";
    in
    if !(builtins.pathExists p) then
      false
    else
      let
        entries = builtins.readDir p;
        names = builtins.attrNames entries;
        files = builtins.filter (n: entries.${n} == "regular" && n != "README.md") names;
        dirs = builtins.filter (n: entries.${n} == "directory") names;
      in
      files != [ ] || dirs != [ ];

  hasSuffixIn =
    rel: suffixes:
    let
      p = root + "/${rel}";
      walk =
        path:
        if !(builtins.pathExists path) then
          false
        else
          let
            entries = builtins.readDir path;
            names = builtins.attrNames entries;
          in
          builtins.any (
            n:
            let
              t = entries.${n};
              full = path + "/${n}";
            in
            if t == "regular" then
              builtins.any (s: lib.hasSuffix s n) suffixes
            else if t == "directory" then
              walk full
            else
              false
          ) names;
    in
    walk p;

  fileContains =
    rel: needle:
    let
      p = root + "/${rel}";
    in
    if !(builtins.pathExists p) then
      false
    else
      lib.hasInfix needle (builtins.readFile p);

  freestandingC =
    exists "out/freestanding-c"
    && hasSuffixIn "out/freestanding-c" [
      ".c"
      ".h"
    ]
    && dirNontrivial "out/freestanding-c";
}
