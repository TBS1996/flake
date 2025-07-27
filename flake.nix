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
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
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
    nixvim,
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
            nixvim.homeManagerModules.nixvim
          ];
          home.stateVersion = "24.11";
          home.packages = with pkgs; [
            selvit.packages.${pkgs.system}.default
            taptest.packages.${pkgs.system}.default
            speki.packages.${pkgs.system}.default
            dagplan.packages.${pkgs.system}.default
            tordo.packages.${pkgs.system}.default
            rust-analyzer
            rustc
            cargo
            clippy
            rustfmt
            nerd-fonts.fira-code
            nerd-fonts.symbols-only
            waybar
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

          programs.nixvim = {
            enable = true;
            defaultEditor = true;

            plugins = {
              lsp.enable = true;
              treesitter.enable = true;
              lsp-format.enable = true;

              cmp.enable = true;
              luasnip.enable = true;
              telescope.enable = true;
              lualine.enable = true;
              which-key.enable = true;
              chadtree.enable = true;
            };

            # LSP server config
            extraConfigLua = ''
              vim.g.mapleader = " "

              -- Diagnostic popup on CursorHold
              vim.o.updatetime = 300
              vim.api.nvim_create_autocmd("CursorHold", {
                callback = function()
                  vim.diagnostic.open_float(nil, {
                    focusable = false,
                    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                    border = "rounded",
                    source = "always",
                    prefix = " ",
                  })
                end,
              })

              -- Set up completion engine (cmp)
              local cmp = require("cmp")
              cmp.setup({
                snippet = {
                  expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                  end,
                },
                mapping = cmp.mapping.preset.insert({
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  ['<Tab>'] = cmp.mapping.select_next_item(),
                  ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
                  { name = 'buffer' },
                  { name = 'path' },
                })
              })

              -- Rust LSP config
              require("lspconfig").rust_analyzer.setup({
                settings = {
                  ["rust-analyzer"] = {
                    cargo = { sysroot = { enable = false } },
                    diagnostics = { enable = true },
                  },
                },
              })
            '';

            extraPlugins = with pkgs.vimPlugins; [
              cmp-buffer
              cmp-path
              cmp-nvim-lsp
              cmp-nvim-lua
              cmp_luasnip
              tokyonight-nvim
            ];

            colorscheme = "tokyonight";

            keymaps = [
              {
                mode = "n";
                key = "<leader>ff";
                action = "<cmd>Telescope find_files<cr>";
                options.desc = "Find files";
              }
              {
                mode = "n";
                key = "<leader>fg";
                action = "<cmd>Telescope live_grep<cr>";
                options.desc = "Live grep";
              }
              {
                mode = "n";
                key = "<C-r>";
                action = "<cmd>CHADopen<cr>";
                options.desc = "Toggle CHADTree";
              }
              {
                mode = "n";
                key = "gd";
                action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
                options.desc = "Go to declaration";
              }
              {
                mode = "n";
                key = "<leader>ca";
                action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
                options.desc = "LSP code action (quick fix)";
              }
              {
                mode = "n";
                key = "gr";
                action = "<cmd>lua vim.lsp.buf.references()<cr>";
                options.desc = "Show references";
              }
            ];
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
          home.file.".config/sway/config".source = ./dotfiles/sway;
          home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh;
          home.file.".config/foot/foot.ini".source = ./dotfiles/foot;
          home.file.".config/waybar/config".source = ./dotfiles/waybar;
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
