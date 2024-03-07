{
  description = "a flakey flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        ({ pkgs, ... }: {
          environment.systemPackages = with pkgs; [
            (pkgs.writeShellScriptBin "rebuild-flake" ''
              #!/usr/bin/env bash
              sudo nixos-rebuild switch --flake './flake#mySystem'
            '')
          ];
        })
      ];
    };
  };
}
