{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts = { url = "github:hercules-ci/flake-parts"; inputs.nixpkgs-lib.follows = "nixpkgs"; };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem = { pkgs, ... }: {
        packages.default = pkgs.writeShellApplication {
          name = "rotator";
          runtimeInputs = with pkgs; [
            gum
            curl
            jq
            coreutils
            findutils
          ];
          text = builtins.readFile ./src/rotator.sh;
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
          programs.shfmt.enable = true;
          programs.shellcheck.enable = true;
          settings.formatter.shellcheck.options = [ "-s" "bash" ];
        };
      };
    };
}
