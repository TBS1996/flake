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
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {

          home-manager.users.tor = { pkgs, ... }: {
            home.stateVersion = "22.05";

            imports = [
              nixvim.homeManagerModules.nixvim
            ];

            programs.git = {
              enable = true;
              userName = "tor";
              userEmail = "torberge@outlook.com";
            };

	    programs.firefox = {
	      enable = true;
	      policies = {
	      ExtensionSettings = {
		#"*".installation_mode = "blocked"; # blocks all addons except the ones specified below

		# uBlock Origin:
		"uBlock0@raymondhill.net" = {
		  install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
		  installation_mode = "force_installed";
		  };

		# Privacy Badger:
		"jid1-MnnxcxisBPnSXQ@jetpack" = {
		  install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
		  installation_mode = "force_installed";
	  	  };

		# Privacy Badger:
		"446900e4-71c2-419f-a6a7-df9c091e268b" = {
		  install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
		  installation_mode = "force_installed";
	  	  };
		
	        };

	      };

	    };

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

              extraConfigVim = ''
                autocmd BufEnter,WinEnter * set signcolumn=yes
                " Any additional custom Vimscript
              '';

              extraConfigLua = ''
                require('rust-tools').setup({})
                require('lspconfig').rust_analyzer.setup({
                  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
                })
                vim.api.nvim_create_autocmd("BufWritePre", {
                  pattern = {"*.rs"},
                  callback = function()
                    vim.lsp.buf.format({ timeout_ms = 1000, async = false })
                  end,
                })
                -- Additional Lua configuration for LSP, cmp, treesitter, etc.
              '';
            };


            home.file.".config/newsboat/config".source = ./dotfiles/newsboat/config;
            home.file.".config/newsboat/urls".source = ./dotfiles/newsboat/urls;
            home.file.".config/sway/config".source = ./dotfiles/sway/config;
            home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh/.zshrc;
            home.file.".config/aerc/binds.conf".source = ./dotfiles/aerc/binds.conf;
            home.file.".config/aerc/aerc.conf".source = ./dotfiles/aerc/aerc.conf;
          };
        })
      ];
    };
  };
}

