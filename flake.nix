{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master"; 
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
    let
      vars = import ./vars.nix;
    in {
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

            environment.systemPackages = with pkgs; [ gammastep ];

            home-manager.users.tor = { pkgs, ... }: {
              home.stateVersion = "24.11";

              services.syncthing = {
                enable = true;
              };

              programs.git = {
                enable = true;
                userName = vars.git_name;   
                userEmail = vars.git_email;
              };

	      services.mako = {
		  enable = true;
		  anchor = "top-left";
		  defaultTimeout = 5000;
		  backgroundColor = "#1e1e2e";
		  textColor = "#cdd6f4";
		  borderColor = "#89b4fa";
		  borderSize = 2;
		  padding = "10";
		  font = "JetBrainsMono 10";
		};

		  services.git-sync = {
		    enable = true;
		    repositories = {
		      infrastructure = {
			path = "/home/tor/prog/infrastructure";
			uri = "https://github.com/cognitedata/infrastructure.git";
			interval = 0; 
		      };
		      speki = {
			path = "/home/tor/prog/speki";
			uri = "https://github.com/tbs1996/speki.git";
			interval = 0; 
		      };
		      talecast = {
			path = "/home/tor/prog/talecast";
			uri = "https://github.com/tbs1996/talecast.git";
			interval = 0; 
		      };
		    };
		  };

              home.file.".config/zed/settings.json".source = ./dotfiles/zed/config;
              home.file.".config/newsboat/config".source = ./dotfiles/newsboat/config;
              home.file.".config/newsboat/urls".source = ./dotfiles/newsboat/urls;
              home.file.".config/foot/foot.ini".source = ./dotfiles/foot/config;
              home.file.".config/sway/config".source = ./dotfiles/sway/config;
              home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh/config;
              home.file.".config/aerc/binds.conf".source = ./dotfiles/aerc/binds.conf;
              home.file.".config/aerc/aerc.conf".source = ./dotfiles/aerc/aerc.conf;
              home.file.".config/waybar/config".source = ./dotfiles/waybar/config;
              home.file.".config/Code/User/settings.json".source = ./dotfiles/vscode/settings.json;
            };
          })
        ];
      };
    };
}

