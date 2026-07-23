# SPDX-License-Identifier: Unlicense
# Data only: Lean-side dual required paths, honesty tokens, and banned jargon
# under examples/*.lean. Imported by ./default.nix.
# Former static mill lived in src/lean4/check.sh (Wave A pure Nix port).
{
  # Required dual artifacts (presence only; Lake elaborator stays process glue).
  requiredFiles = [
    "src/lean4/multiplicity-map.md"
    "src/lean4/examples/ConsumeToken.lean"
    "src/lean4/examples/ErasedIndex.lean"
    "src/lean4/examples/UnrestrictedShare.lean"
    "src/lean4/examples/TRUST.md"
    "src/lean4/JOIN.md"
    "src/lean4/check.sh"
    "src/lean4/lakefile.toml"
    "src/lean4/lean-toolchain"
    "src/lean4/lake-manifest.json"
  ];

  # File content honesty tokens (all must appear; anyGroups optional).
  contentSpecs = [
    {
      rel = "src/lean4/examples/ConsumeToken.lean";
      all = [
        "ConsumeToken"
        "SystemsLean.LeanBridge.ConsumeToken"
      ];
    }
    {
      rel = "src/lean4/examples/ErasedIndex.lean";
      all = [
        "ErasedIndex"
        "SystemsLean.LeanBridge.ErasedIndex"
      ];
    }
    {
      rel = "src/lean4/examples/UnrestrictedShare.lean";
      all = [
        "UnrestrictedShare"
        "SystemsLean.LeanBridge.UnrestrictedShare"
      ];
    }
    {
      rel = "src/lean4/multiplicity-map.md";
      all = [ "MULT-1" ];
    }
    {
      rel = "src/lean4/JOIN.md";
      all = [
        "ErasedIndex"
        "UnrestrictedShare"
      ];
    }
  ];

  # Banned jargon under novel Lean examples only (not check.sh self-text).
  jargonWalkRoot = "src/lean4/examples";
  jargonWalkSkipDirs = [
    ".git"
    ".cache"
    ".lake"
  ];
  jargonWalkExtensions = [ ".lean" ];
  # Case-folded substring ban (fail-closed; match systems-host-presence style).
  jargonForbidden = [
    "pole"
    "spine"
  ];
}
