{
  description = "R Data Science Project";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;  # For Positron
        };

      # Define shell (system-level) tools for the project environment here:
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            positron-bin
            quarto
            R
            # pkgs.tectonic  # for LaTeX

            # Define R environment packages here:
            rPackages.cli
            rPackages.devtools
            rPackages.fs
            rPackages.here
            rPackages.quarto
            rPackages.testthat
            rPackages.tidyverse
            rPackages.yaml
          ];
          
          # Confirmation message:
          shellHook = ''
            echo "📊 $(basename $PWD) R & Quarto Environment Ready"
          '';
        };
      });
}
