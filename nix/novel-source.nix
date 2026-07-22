# SPDX-License-Identifier: Unlicense
# Filter flake source to novel work only (no ref/, git, cache, result).
{ lib, src }:
lib.cleanSourceWith {
  name = "systems-lean-novel";
  inherit src;
  filter =
    path: _type:
    let
      rel = lib.removePrefix (toString src + "/") (toString path);
      base = baseNameOf path;
    in
    !(lib.hasPrefix "ref/" rel)
    && !(lib.hasPrefix ".git/" rel)
    && !(lib.hasInfix "/.git/" rel)
    && !(lib.hasPrefix ".cache/" rel)
    && !(lib.hasInfix "/.cache/" rel)
    && !(lib.hasPrefix ".lake/" rel)
    && !(lib.hasInfix "/.lake/" rel)
    && !(lib.hasPrefix "result" base)
    && !(lib.hasSuffix ".pyc" rel)
    && !(lib.hasInfix "__pycache__" rel);
}
