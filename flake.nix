{
  outputs = { self, nixpkgs, home-manager, ... }: {

    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {

          home-manager.users.tor = { pkgs, ... }: {
            home.stateVersion = "22.05";

            # Include Newsboat configuration files
            home.file.".config/newsboat/config".source = ./dotfiles/newsboat/config;
            home.file.".config/newsboat/urls".source = ./dotfiles/newsboat/urls;

            # Other configurations...
          };
        })
      ];
    };
  };
}
