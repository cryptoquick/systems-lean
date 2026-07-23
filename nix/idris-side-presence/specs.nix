# SPDX-License-Identifier: Unlicense
# Data only: Idris-side dual required paths, honesty tokens, and banned jargon
# under examples/*.idr. Imported by ./default.nix.
# Former static mill lived in src/idris2/check.sh (Wave A pure Nix port).
{
  # Required dual artifacts (presence only; elaborator stays process glue).
  requiredFiles = [
    "src/idris2/multiplicity-map.md"
    "src/idris2/examples/ConsumeToken.idr"
    "src/idris2/examples/ErasedIndex.idr"
    "src/idris2/examples/UnrestrictedShare.idr"
    "src/idris2/examples/TRUST.md"
    "src/idris2/JOIN.md"
    "src/idris2/check.sh"
  ];

  # File content honesty tokens (all must appear; anyGroups optional).
  contentSpecs = [
    {
      rel = "src/idris2/examples/ConsumeToken.idr";
      all = [ "ConsumeToken" ];
    }
    {
      rel = "src/idris2/examples/ErasedIndex.idr";
      all = [ "ErasedIndex" ];
    }
    {
      rel = "src/idris2/examples/UnrestrictedShare.idr";
      all = [ "UnrestrictedShare" ];
    }
    {
      rel = "src/idris2/multiplicity-map.md";
      all = [
        "MULT-1"
        "MULT-0"
        "MULT-OMEGA"
        "ERASE-PROP"
        "EDGE-PROP"
      ];
    }
    {
      rel = "src/idris2/JOIN.md";
      all = [
        "ErasedIndex"
        "UnrestrictedShare"
      ];
    }
  ];

  # Banned jargon under novel Idris examples only (not check.sh self-text).
  jargonWalkRoot = "src/idris2/examples";
  jargonWalkSkipDirs = [
    ".git"
    ".cache"
  ];
  jargonWalkExtensions = [ ".idr" ];
  # Case-folded substring ban (fail-closed; match systems-host-presence style).
  jargonForbidden = [
    "pole"
    "spine"
  ];
}
