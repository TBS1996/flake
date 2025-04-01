{
  description = "A simple hello world Rust project with a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        # A development shell with the Rust toolchain
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.rustc
            pkgs.cargo
          ];
        };

        # Package to build the hello binary using Nix's Rust builder
        packages.hello = pkgs.rustPlatform.buildRustPackage {
          pname = "hello";
          version = "0.1.0";
          src = ./.;
          # Generate a Cargo.lock file by running:
          #   cargo generate-lockfile
          # Then update the cargoSha256 with the hash provided by Nix on first build.
          cargoSha256 = "0000000000000000000000000000000000000000000000000000";
        };

        # An app entry to easily run your project via `nix run`
        apps.default = {
          type = "app";
          program = "${self.packages.hello}/bin/hello";
        };
      }
    );
}
