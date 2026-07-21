{
  description = "Systems Lean";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      # Host platforms we build tooling for. Add here when expanding CI.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSystem =
        f: lib.genAttrs systems (system: f { inherit system; pkgs = nixpkgs.legacyPackages.${system}; });

      # Novel work only: never pull ref/ (or git / result) into check/drv contexts.
      novelSource = lib.cleanSourceWith {
        name = "systems-lean-novel";
        src = ./.;
        filter =
          path: _type:
          let
            rel = lib.removePrefix (toString ./. + "/") (toString path);
          in
          !(lib.hasPrefix "ref/" rel)
          && !(lib.hasPrefix ".git/" rel)
          && !(lib.hasPrefix "result" (baseNameOf path));
      };

      sourceHygiene =
        pkgs:
        pkgs.runCommand "systems-lean-source-hygiene" {
          nativeBuildInputs = [ pkgs.python3 ];
          src = novelSource;
          meta = {
            description = "ASCII-only + no trailing whitespace on novel work";
            license = lib.licenses.unlicense;
          };
        } ''
          set -euo pipefail
          cp -a "$src"/. .
          python3 script/check-source-hygiene.py --walk
          mkdir -p "$out"
          echo ok >"$out/ok"
        '';
    in
    {
      # Primary gate: nix flake check  ->  checks.<system>.source-hygiene
      checks = forEachSystem (
        { pkgs, ... }:
        {
          source-hygiene = sourceHygiene pkgs;
        }
      );

      # nix develop
      devShells = forEachSystem (
        { pkgs, ... }:
        {
          default = pkgs.mkShell {
            name = "systems-lean";
            packages = [
              pkgs.git
              pkgs.python3
              pkgs.gnumake
              pkgs.just
              pkgs.nixfmt
            ];
            shellHook = ''
              echo "systems-lean: just | just check | just build | just out-freestanding-c | just out-llvm-ir (deferred)"
            '';
          };
        }
      );

      # nix run .#source-hygiene
      apps = forEachSystem (
        { pkgs, ... }:
        {
          source-hygiene = {
            type = "app";
            program = lib.getExe (
              pkgs.writeShellApplication {
                name = "systems-lean-source-hygiene";
                runtimeInputs = [ pkgs.python3 ];
                text = ''
                  exec python3 "${self}/script/check-source-hygiene.py" "$@"
                '';
              }
            );
          };
        }
      );

      formatter = forEachSystem ({ pkgs, ... }: pkgs.nixfmt);
    };
}
