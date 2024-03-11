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


	  # Assuming `home` is your home directory's path
	    xdg.cacheHome = "${pkgs.lib.home.homeDirectory}/.cache";

	    home.sessionVariables = {
	      # Directly reference the path without using `config`
	      CARGO_HOME = "/home/tor/.cache/cargo";
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

