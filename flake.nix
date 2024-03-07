{
  # Your existing flake.nix content
  outputs = { self, nixpkgs, home-manager, ... }: {

    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          environment.systemPackages = with pkgs; [
            # Your existing packages
          ];

          # Modified Home Manager users configuration
          home-manager.users.tor = { pkgs, ... }: {
            home.stateVersion = "22.05"; # Ensure this matches your NixOS state version

            home.file.".config" = {
              source = builtins.path { 
                path = ./dotfiles/.config;
                name = "dotfiles-config";
              };
              recursive = true;
            };

            # Your existing home-manager configurations
          };
        })
      ];
    };
  };
}

