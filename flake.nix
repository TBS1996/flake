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

	  environment.systemPackages = with pkgs; [ gammastep ];

          home-manager.users.tor = { pkgs, ... }: {
            home.stateVersion = "24.11";

            services.syncthing = {
              enable = true;
            };

	    programs.helix = {
  enable = true;
  settings = {
    theme = "autumn_night_transparent";
    editor.cursor-shape = {
      normal = "block";
      insert = "bar";
      select = "underline";
    };
  };
  languages.language = [{
    name = "nix";
    auto-format = true;
    formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
  }];
  themes = {
    autumn_night_transparent = {
      "inherits" = "autumn_night";
      "ui.background" = { };
    };
  };
};

            programs.git = {
              enable = true;
              userName = "tor";
              userEmail = "torberge@outlook.com";
            };

	    #programs.light.enable = true;

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
            home.file.".config/waybar/config".source = ./dotfiles/waybar/config;
          };
        })
      ];
    };
  };
}

