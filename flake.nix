{
  description = "org-wild-notifier.el development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Emacs with required packages for testing
        emacsWithPackages = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: with epkgs; [
          dash
          alert
          async
        ]);

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            emacsWithPackages
            pkgs.just
          ];

          shellHook = ''
            echo "org-wild-notifier.el development environment"
            echo "Run 'just test' to run tests"
          '';
        };

        # Package for running tests
        packages.test = pkgs.runCommand "org-wild-notifier-test" {
          buildInputs = [ emacsWithPackages ];
          src = ./.;
        } ''
          cd $src
          emacs --batch \
            -L . \
            -L tests \
            -l ert \
            -l tests/org-wild-notifier-tests.el \
            -f ert-run-tests-batch-and-exit
          touch $out
        '';

        # Check for CI
        checks.default = self.packages.${system}.test;
      });
}
