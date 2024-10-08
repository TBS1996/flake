{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    #nixvim.url = "github:nix-community/nixvim";
    #nixvim.inputs.nixpkgs.follows = "nixpkgs";
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

          # Import nixvim module
          imports = [
     #       nixvim.homeManagerModules.nixvim
            ./options/firefox-config.nix
          ];

          home-manager.users.tor = { pkgs, ... }: {
            home.stateVersion = "24.05";

            home.sessionVariables = {
              PATH = "${pkgs.lib.makeBinPath [ "/home/tor/.cache/cargo/bin" ]}";
            };


            services.syncthing = {
              enable = true;
            };

            services.mpd = {
              enable = true;
              musicDirectory = "/path/to/music";
              network.listenAddress = "any";
            };

            programs.git = {
              enable = true;
              userName = "tor";
              userEmail = "torberge@outlook.com";
            };

            programs.neomutt = {
              enable = true;
            };

            home.file.".config/newsboat/config".source = ./dotfiles/newsboat/config;
            home.file.".config/newsboat/urls".source = ./dotfiles/newsboat/urls;
            home.file.".config/foot/foot.ini".source = ./dotfiles/foot/config;
            home.file.".config/sway/config".source = ./dotfiles/sway/config;
            home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh/config;
            home.file.".config/aerc/binds.conf".source = ./dotfiles/aerc/binds.conf;
            home.file.".config/aerc/aerc.conf".source = ./dotfiles/aerc/aerc.conf;
            home.file.".config/nvim/init.lua".source = ./dotfiles/nvim/init.lua;
            home.file.".config/nvim/lua/keymaps.lua".source = ./dotfiles/nvim/keymaps.lua;
            home.file.".config/nvim/lua/plugins.lua".source = ./dotfiles/nvim/plugins.lua;
            home.file.".config/nvim/lua/rust.lua".source = ./dotfiles/nvim/rust.lua;
          };
        })
      ];
    };
  };
}

