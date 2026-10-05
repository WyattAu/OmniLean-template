{
  # OmniLean dev environment — nix owns Lean + elan; lean-toolchain pins
  # the exact version elan selects.
  description = "OmniLean-template development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            lean4
            elan # overrides lean4 when lean-toolchain asks for another version
            git
          ];
          shellHook = ''
            echo "OmniLean: elan manages $(cat lean-toolchain | cut -d: -f2)"
          '';
        };
      });
    };
}
