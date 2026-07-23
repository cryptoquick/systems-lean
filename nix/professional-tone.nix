# SPDX-License-Identifier: Unlicense
# Pure Nix professional tone / profanity gate for novel markdown (v1).
#
# Scope: walk novel *.md under root; fail closed on a short ASCII banned-token
# list (clear profanity and demeaning slurs). Case-insensitive whole-token
# match after non-alphanumeric characters are treated as separators (not bare
# substring, so technical words like "class" / "pass" are not hit by short
# list entries). Does not scan Lean, C, shell, or other extensions in v1.
#
# Skips: .git, ref/, .cache, .lake, __pycache__, result*, flake.lock-style
# non-md (only *.md are collected). Prefer root = novelSource from
# novel-source.nix so ref/ is already filtered; local skipDir is defense in
# depth when root is a worktree path.
#
#   import ./professional-tone.nix { inherit lib; root = novelSource; }
#   -> { ok, violations, summary, files, bannedWords }
#
# No bash, no ripgrep, no Python. Live: just professional-tone / just hygiene.
# Flake: checks.professional-tone (human-in-the-loop stage new nix/ paths).
{ lib, root }:
let
  # Short professional-repo list. Edit here only; keep narrow to limit
  # false positives. Whole-token match (see normalizeLine). Not an essay
  # dictionary -- clear profanity and common demeaning slurs.
  bannedWords = [
    "fuck"
    "fucking"
    "fucked"
    "fucker"
    "motherfucker"
    "shit"
    "shitty"
    "bullshit"
    "asshole"
    "bitch"
    "bitches"
    "bastard"
    "cunt"
    "dickhead"
    "cocksucker"
    "piss"
    "pissed"
    "whore"
    "slut"
    "twat"
    "nigger"
    "nigga"
    "faggot"
    "retard"
    "retarded"
  ];

  skipDir =
    name:
    name == ".git"
    || name == "ref"
    || name == ".cache"
    || name == ".lake"
    || name == "__pycache__"
    || lib.hasPrefix "result" name;

  isMarkdown = name: lib.hasSuffix ".md" name;

  collectMd =
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
        if skipDir name then [ ] else collectMd childPath childRel
      else if typ == "regular" && isMarkdown name then
        [ { path = childPath; rel = childRel; } ]
      else
        [ ]
    ) (builtins.attrNames entries);

  files = collectMd root "";

  # a-z0-9 only after toLower; used to split tokens at punctuation/whitespace.
  alphaNum = lib.listToAttrs (
    map (c: {
      name = c;
      value = true;
    }) (lib.stringToCharacters "abcdefghijklmnopqrstuvwxyz0123456789")
  );

  # Lowercase line; non-alnum -> space; pad so edge tokens match as " word ".
  normalizeLine =
    line:
    let
      lower = lib.toLower line;
      mapped = map (
        c: if builtins.hasAttr c alphaNum then c else " "
      ) (lib.stringToCharacters lower);
    in
    " " + lib.concatStrings mapped + " ";

  checkLine =
    rel: lineNum: line:
    let
      padded = normalizeLine line;
    in
    lib.concatMap (
      word:
      if lib.hasInfix (" ${word} ") padded then
        [ "${rel}:${toString lineNum}: banned token '${word}'" ]
      else
        [ ]
    ) bannedWords;

  checkFile =
    { path, rel }:
    let
      content = builtins.readFile path;
      lines = lib.splitString "\n" content;
    in
    lib.concatLists (
      lib.imap1 (lineNum: line: checkLine rel lineNum line) lines
    );

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
      "professional-tone OK (${toString (builtins.length files)} markdown files; ${toString (builtins.length bannedWords)} banned tokens; whole-token; novel *.md only)"
    else
      "professional-tone FAILED:\n" + lib.concatStringsSep "\n" shown + more;
in
{
  inherit
    ok
    violations
    summary
    files
    bannedWords
    ;
}
