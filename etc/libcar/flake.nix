{
  description = "A basic flake for testing a Rust library";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "rust-dev-shell";
      buildInputs = [
        pkgs.rustc
        pkgs.cargo
      ];
    };
  };
}
