{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }: {

    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {

          home-manager.users.tor = { pkgs, ... }: {
            home.stateVersion = "22.05";

            imports = [
              nixvim.homeManagerModules.nixvim
            ];

            programs.nixvim = {
              enable = true;

	      plugins = {
		rust-tools.enable = true;
		lsp.enable = true;
		cmp.enable = true;
		cmp-nvim-lsp.enable = true;
		treesitter.enable = true;
		treesitter-refactor.enable = true;
		gitsigns.enable = true;
		telescope.enable = true;
		lightline.enable = true;

		cmp-buffer.enable = true;
		cmp-path.enable = true;
		cmp-cmdline.enable = true;
	      };




	      colorschemes.dracula.enable = true;
	      options = {
	      number = true;
	      relativenumber = true;
	            shiftwidth = 2;     
	      };
            };

            home.file.".config/newsboat/config".source = ./dotfiles/newsboat/config;
            home.file.".config/newsboat/urls".source = ./dotfiles/newsboat/urls;
            home.file.".config/sway/config".source = ./dotfiles/sway/config;

          };
        })
      ];
    };
  };
}
