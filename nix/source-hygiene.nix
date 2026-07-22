# SPDX-License-Identifier: Unlicense
# Pure Nix source hygiene: printable ASCII (tab/LF/CR + 0x20-0x7E) outside
# allowlist; no trailing whitespace on any novel text path.
#
#   import ./source-hygiene.nix { inherit lib; root = novelSource; }
#   -> { ok, violations, summary }
#
# No bash, no ripgrep, no Python. Flake checks force-eval this module.
{ lib, root }:
let
  # Unicode allowed here; trailing whitespace still forbidden.
  allowlist = {
    "README.md" = true;
    "doc/vocabulary.md" = true;
    "doc/ascii-symbol-map.md" = true;
  };

  skipDir =
    name:
    name == ".git"
    || name == "ref"
    || name == ".cache"
    || name == ".lake"
    || name == "__pycache__"
    || lib.hasPrefix "result" name;

  skipFile = name: lib.hasSuffix ".pyc" name || name == "flake.lock";

  # tab, LF, CR, space..tilde
  printable =
    " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
  allowed = lib.listToAttrs (
    map (c: {
      name = c;
      value = true;
    }) (lib.stringToCharacters ("\t\n\r" + printable))
  );

  isAllowedChar = c: builtins.hasAttr c allowed;

  collectFiles =
    dir: rel:
    let
      entries = builtins.readDir dir;
    in
    lib.concatMap (
      name:
      let
        typ = entries.${name};
        childRel = if rel == "" then name else "${rel}/${name}";
        childPath = dir + "/${name}";
      in
      if typ == "directory" then
        if skipDir name then [ ] else collectFiles childPath childRel
      else if typ == "regular" then
        if skipFile name then [ ] else [ { path = childPath; rel = childRel; } ]
      else
        [ ]
    ) (builtins.attrNames entries);

  files = collectFiles root "";

  checkFile =
    { path, rel }:
    let
      content = builtins.readFile path;
      allowUnicode = builtins.hasAttr rel allowlist;
      badChars =
        if allowUnicode then
          [ ]
        else
          lib.filter (c: !(isAllowedChar c)) (lib.stringToCharacters content);
      lines = lib.splitString "\n" content;
      trailing = lib.filter (l: lib.hasSuffix " " l || lib.hasSuffix "\t" l) lines;
      msgs =
        (if badChars == [ ] then [ ] else [ "${rel}: non-ASCII outside allowlist" ])
        ++ (
          if trailing == [ ] then
            [ ]
          else
            [ "${rel}: trailing whitespace (${toString (builtins.length trailing)} line(s))" ]
        );
    in
    msgs;

  violations = lib.concatMap checkFile files;
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
      "source-hygiene OK (${toString (builtins.length files)} files; ASCII except allowlist; no trailing whitespace)"
    else
      "source-hygiene FAILED:\n" + lib.concatStringsSep "\n" shown + more;
in
{
  inherit ok violations summary files;
}
