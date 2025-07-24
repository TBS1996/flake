{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    selvit.url = "github:tbs1996/selvit-cli";
    taptest.url = "github:tbs1996/taptest";
    speki.url = "github:tbs1996/spekispace";
    dagplan.url = "github:tbs1996/dagplan";
    tordo.url = "github:tbs1996/tordo";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    helix,
    selvit,
    taptest,
    speki,
    dagplan,
    tordo,
    ...
  }: let
    vars = import ./vars.nix;

    sharedModules = [
      ./nixos/configuration.nix
      ./systemd-services.nix
      home-manager.nixosModules.home-manager
      ({pkgs, ...}: {
        nixpkgs.config.allowUnfree = true;

        imports = [./options/firefox-config.nix];

        environment.systemPackages = with pkgs; [
          gammastep
          xorg.xinit
        ];

        virtualisation.docker.enable = true;

        programs.foot = {
          enable = true;
          theme = "onehalf-dark";
          settings.main.font = "FreeMono:size=16";
        };

        home-manager.users.tor = {pkgs, ...}: {
          imports = [
            (import ./options/helix-config.nix {inherit pkgs helix;})
          ];
          home.stateVersion = "24.11";
          home.packages = [
            selvit.packages.${pkgs.system}.default
            taptest.packages.${pkgs.system}.default
            speki.packages.${pkgs.system}.default
            dagplan.packages.${pkgs.system}.default
            tordo.packages.${pkgs.system}.default
            pkgs.nerd-fonts.fira-code
            pkgs.nerd-fonts.symbols-only
            pkgs.waybar
          ];

          services.syncthing.enable = true;

          programs.git = {
            enable = true;
            userName = vars.git_name;
            userEmail = vars.git_email;
          };

          programs.yazi = {
            enable = true;
            settings.manager = {
              editor = "hx";
              ratio = [1 1 2];
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

          home.file.".gitconfig".source = ./dotfiles/gitconfig;
          home.file.".local/bin/sv" = {
            source = "${selvit.packages.${pkgs.system}.default}/bin/selvit";
          };
          home.file.".gitconfig-cognite".source = ./dotfiles/gitconfig-cognite;
          home.file.".config/nchat/ui.conf".source = ./dotfiles/nchat/ui.conf;
          home.file.".config/nchat/key.conf".source = ./dotfiles/nchat/key.conf;
          home.file.".config/zellij/config.kdl".source = ./dotfiles/zellij/config;
          home.file.".config/zellij/layouts/chat.kdl".source = ./dotfiles/zellij/chat;
          home.file.".config/newsboat/config".source = ./dotfiles/newsboat/config;
          home.file.".config/newsboat/urls".source = ./dotfiles/newsboat/urls;
          home.file.".config/sway/config".source = ./dotfiles/sway/config;
          home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh/config;
          home.file.".config/waybar/config".source = ./dotfiles/waybar/config;
          home.file.".cargo/config.toml".source = ./dotfiles/cargo/config;
          home.file.".config/Code/User/settings.json".source = ./dotfiles/vscode/settings.json;
          home.file.".xinitrc" = {
            source = ./dotfiles/xinit;
            executable = true;
          };
        };
      })
    ];
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = {
      sys = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ({...}: {
              programs.sway.enable = true;
            })
          ];
      };

      sys-x11 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ({pkgs, ...}: {
              services.xserver.enable = true;
              services.xserver.displayManager.startx.enable = true;
              environment.systemPackages = with pkgs; [
                xorg.xinit
                i3
                i3status
                i3lock
                dmenu
              ];
            })
          ];
      };
    };
  };
}
