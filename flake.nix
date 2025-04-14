{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    helix,
    ...
  }: let
    vars = import ./vars.nix;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations.sys = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        ./systemd-services.nix
        home-manager.nixosModules.home-manager
        ({pkgs, ...}: {
          nixpkgs.config.allowUnfree = true;

          imports = [./options/firefox-config.nix];

          environment.systemPackages = with pkgs; [gammastep];

          virtualisation.docker.enable = true;
          programs.foot = {
            enable = true;
            theme = "onehalf-dark";
            settings = {
              main = {
                font = "FreeMono:size=16";
              };
            };
          };

          home-manager.users.tor = {pkgs, ...}: {
            imports = [
              (import ./options/helix-config.nix {inherit pkgs helix;})
            ];
            home.stateVersion = "24.11";

            services.syncthing = {enable = true;};

            programs.git = {
              enable = true;
              userName = vars.git_name;
              userEmail = vars.git_email;
            };

            programs.yazi = {
              enable = true;
              settings = {
                manager = {
                  editor = "hx";
                  ratio = [1 1 2];
                };
              };
            };

            services.mako = {
              enable = true;
              anchor = "top-left";
              defaultTimeout = 10000;
              backgroundColor = "#1e1e2e";
              textColor = "#cdd6f4";
              borderColor = "#89b4fa";
              borderSize = 2;
              padding = "10";
              font = "JetBrainsMono 10";
            };

            /*
            services.git-sync = {
              enable = true;
              repositories = {
                infrastructure = {
                  path = "${vars.prog_folder}/infrastructure";
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
            */

            home.file.".config/nchat/ui.conf".source =
              ./dotfiles/nchat/ui.conf;
            home.file.".config/nchat/key.conf".source =
              ./dotfiles/nchat/key.conf;
            home.file.".config/zellij/config.kdl".source =
              ./dotfiles/zellij/config;
            home.file.".config/zellij/layouts/chat.kdl".source =
              ./dotfiles/zellij/chat;
            home.file.".config/newsboat/config".source =
              ./dotfiles/newsboat/config;
            home.file.".config/newsboat/urls".source =
              ./dotfiles/newsboat/urls;
            home.file.".config/sway/config".source = ./dotfiles/sway/config;
            home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh/config;
            home.file.".config/waybar/config".source =
              ./dotfiles/waybar/config;
            home.file.".cargo/config.toml".source = ./dotfiles/cargo/config;
            home.file.".config/Code/User/settings.json".source =
              ./dotfiles/vscode/settings.json;
          };
        })
      ];
    };
  };
}
