{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim,  ... }: {

    nixosConfigurations.sys = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
	./systemd-services.nix
	#./nixvim-config.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {

          home-manager.users.tor = { pkgs, ... }: {
            home.stateVersion = "22.05";

	    home.sessionVariables = {
              PATH = "${pkgs.lib.makeBinPath [ "/home/tor/.cache/cargo/bin" ]}";
            };

            imports = [
              nixvim.homeManagerModules.nixvim
	      ./options/nixvim-config.nix
	      #./options/foo.nix
	      #./options/bar.nix
	      ./options/firefox-config.nix
            ];

            programs.git = {
              enable = true;
              userName = "tor";
              userEmail = "torberge@outlook.com";
            };

	    programs.neomutt = {
	      enable = true;
	    };

	    programs.waybar.enable = true;


            home.file.".config/newsboat/config".source = ./dotfiles/newsboat/config;
            home.file.".config/newsboat/urls".source = ./dotfiles/newsboat/urls;
            home.file.".config/foot/foot.ini".source = ./dotfiles/foot/config;
            home.file.".config/sway/config".source = ./dotfiles/sway/config;
            home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh/config;
            home.file.".config/aerc/binds.conf".source = ./dotfiles/aerc/binds.conf;
            home.file.".config/aerc/aerc.conf".source = ./dotfiles/aerc/aerc.conf;
          };
        })
      ];
    };
  };
}
