{
  description = "Systems Lean";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSystem =
        f:
        lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );

      novelSource = import ./nix/novel-source.nix {
        inherit lib;
        src = ./.;
      };

      progress = import ./nix/progress { inherit lib; };
      progressAt = progress.mk self;

      sourceHygiene = import ./nix/source-hygiene.nix {
        inherit lib;
        root = novelSource;
      };

      professionalTone = import ./nix/professional-tone.nix {
        inherit lib;
        root = novelSource;
      };

      systemsHostPresence = import ./nix/systems-host-presence {
        inherit lib;
        root = novelSource;
      };

      systemsEmitWire = import ./nix/systems-emit-wire {
        inherit lib;
        root = novelSource;
      };

      idrisSidePresence = import ./nix/idris-side-presence {
        inherit lib;
        root = novelSource;
      };

      leanSidePresence = import ./nix/lean-side-presence {
        inherit lib;
        root = novelSource;
      };

      # Pure check: throw at eval time with violation list, or a tiny text drv.
      mkSourceHygieneCheck =
        pkgs:
        if sourceHygiene.ok then
          pkgs.writeText "source-hygiene-ok" sourceHygiene.summary
        else
          throw sourceHygiene.summary;

      mkProfessionalToneCheck =
        pkgs:
        if professionalTone.ok then
          pkgs.writeText "professional-tone-ok" professionalTone.summary
        else
          throw professionalTone.summary;

      mkSystemsHostPresenceCheck =
        pkgs:
        if systemsHostPresence.ok then
          pkgs.writeText "systems-host-presence-ok" systemsHostPresence.summary
        else
          throw systemsHostPresence.summary;

      mkSystemsEmitWireCheck =
        pkgs:
        if systemsEmitWire.ok then
          pkgs.writeText "systems-emit-wire-ok" systemsEmitWire.summary
        else
          throw systemsEmitWire.summary;

      mkIdrisSidePresenceCheck =
        pkgs:
        if idrisSidePresence.ok then
          pkgs.writeText "idris-side-presence-ok" idrisSidePresence.summary
        else
          throw idrisSidePresence.summary;

      mkLeanSidePresenceCheck =
        pkgs:
        if leanSidePresence.ok then
          pkgs.writeText "lean-side-presence-ok" leanSidePresence.summary
        else
          throw leanSidePresence.summary;

      mkProgressReport =
        pkgs:
        pkgs.writeText "PROGRESS.md" progressAt.report;
    in
    {
      # Reusable pure APIs (no packages, no shell).
      lib = {
        inherit progress;
        novelSource = import ./nix/novel-source.nix;
        sourceHygiene = import ./nix/source-hygiene.nix;
        professionalTone = import ./nix/professional-tone.nix;
        systemsHostPresence = import ./nix/systems-host-presence;
        systemsEmitWire = import ./nix/systems-emit-wire;
        idrisSidePresence = import ./nix/idris-side-presence;
        leanSidePresence = import ./nix/lean-side-presence;
      };

      # Live pure-Nix meter text (system-independent). `just progress` redirects these.
      progressReportText = progressAt.report;
      progressConsoleText = progressAt.console;

      checks = forEachSystem (
        { pkgs, ... }:
        {
          source-hygiene = mkSourceHygieneCheck pkgs;
          professional-tone = mkProfessionalToneCheck pkgs;
          systems-host-presence = mkSystemsHostPresenceCheck pkgs;
          systems-emit-wire = mkSystemsEmitWireCheck pkgs;
          idris-side-presence = mkIdrisSidePresenceCheck pkgs;
          lean-side-presence = mkLeanSidePresenceCheck pkgs;
        }
      );

      packages = forEachSystem (
        { pkgs, ... }:
        {
          # Frozen snapshot of the pure progress report (CI artifact / nix build).
          progress-report = mkProgressReport pkgs;
          default = mkSourceHygieneCheck pkgs;
        }
      );

      devShells = forEachSystem (
        { pkgs, ... }:
        {
          default = pkgs.mkShell {
            name = "systems-lean";
            packages = [
              pkgs.git
              pkgs.just
              pkgs.nixfmt
              pkgs.scc
              # Search: agents and humans use `rg` (ripgrep), not ad-hoc grep mills.
              pkgs.ripgrep
              # Lean/Lake: elan manages the offline pin in src/systems/lean-toolchain
              # and src/lean4/lean-toolchain (leanprover/lean4:v4.32.0). Do not put
              # pkgs.lean4 here -- nixpkgs lean4 lags the pin and would mismatch.
              # Install once: elan toolchain install "$(tr -d '[:space:]' < src/systems/lean-toolchain)"
              # Workspace checks skip Lake when the pin is not installed (no network).
              pkgs.elan
              # Idris 2 elaborator for bridge-side checks (skip-if-missing honesty in
              # src/idris2/check.sh when binary absent outside this shell).
              pkgs.idris2
            ];
            shellHook = ''
              echo "systems-lean: just | just check | just progress | just watch | just build"
              echo "tooling: pure Nix under nix/; search with rg; elan + idris2 in PATH"
              echo "Lean pin: install via elan from src/systems/lean-toolchain (or src/lean4/)"
            '';
          };
        }
      );

      formatter = forEachSystem ({ pkgs, ... }: pkgs.nixfmt);
    };
}
