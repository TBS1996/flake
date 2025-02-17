{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	home-manager.url = "github:nix-community/home-manager/master"; 

  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.sys = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        ./systemd-services.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;

          imports = [
            ./options/firefox-config.nix
          ];

          home-manager.users.tor = { pkgs, ... }: {
            home.stateVersion = "24.11";

            home.sessionVariables = {
              PATH = "${pkgs.lib.makeBinPath [ "/home/tor/.cache/cargo/bin" ]}";
            };

            services.syncthing = {
              enable = true;
            };

	    programs.gammastep = {
		  enable = true;
		  tray = true; # Optional system tray icon
		  temperature.day = 5500; # Adjust for preference
		  temperature.night = 3000;
		  dusk-time = "20:00"; # Start shift at 8 PM
		  dawn-time = "07:00"; # End shift at 7 AM
		};


            programs.git = {
              enable = true;
              userName = "tor";
              userEmail = "torberge@outlook.com";
            };

            programs.neomutt = {
              enable = true;
            };

            home.file.".config/zed/settings.json".source = ./dotfiles/zed/config;
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

