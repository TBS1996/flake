{ pkgs, ... }:


{
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
      neo-tree.enable = true;
      barbar.enable = true;

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

    keymaps = [
      {
	action = ":Telescope live_grep<CR>";
	key = "<leader>lg";
	options = {
	  silent = true;
	};
      }
      {
	action = ":Telescope grep_string<CR>";
	key = "<leader>gs";
	options = {
	  silent = true;
	};
      }
      {
	action = ":Neotree<CR>";
	key = "<leader>o";
	options = {
	  silent = true;
	};
      }
      {
	action = ":vertical resize -4<CR>";
	key = "<leader>a";
	options = {
	  silent = true;
	  noremap = true;
	};
      }
      {
	action = ":vertical resize +4<CR>";
	key = "<leader>d";
	options = {
	  silent = true;
	};
      }
      {
	action = ":horizontal resize -4<CR>";
	key = "<leader>w";
	options = {
	  silent = true;
	};
      }
      {
	action = ":horizontal resize +4<CR>";
	key = "<leader>s";
	options = {
	  silent = true;
	};
      }
      {
	action = ":vertical resize -8<CR>";
	key = "<leader>A";
	options = {
	  silent = true;
	};
      }
      {
	action = ":vertical resize +8<CR>";
	key = "<leader>D";
	options = {
	  silent = true;
	};
      }
      {
	action = ":horizontal resize -8<CR>";
	key = "<leader>W";
	options = {
	  silent = true;
	};
      }
      {
	action = ":horizontal resize +8<CR>";
	key = "<leader>S";
	options = {
	  silent = true;
	};
      }
    ];





    extraConfigLua = ''
      vim.g.mapleader = " "
      vim.api.nvim_set_keymap('n', '<leader>lg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>gs', ':Telescope grep_string<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>o', ':Neotree<CR>', { noremap = true, silent = true })

      vim.api.nvim_set_keymap('n', '<leader>a', ':vertical resize -4<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>d', ':vertical resize +4<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>w', ':horizontal resize -4<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>s', ':horizontal resize +4<CR>', { noremap = true, silent = true })


      vim.api.nvim_set_keymap('n', '<leader>A', ':vertical resize -8<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>D', ':vertical resize +8<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>W', ':horizontal resize -8<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>S', ':horizontal resize +8<CR>', { noremap = true, silent = true })


      -- Orients the cursor correctly after pressing enter within curly braces.
      vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
	  local function check_and_execute()
	    local line = vim.api.nvim_get_current_line()
	    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	    if line:sub(col - 1, col) == "{}" then
	      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR><Esc>ko", true, false, true), 'n', false)
	    else
	      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), 'n', false)
	    end
	  end
	  vim.keymap.set('i', '<CR>', check_and_execute, {silent = true, buffer = true})
	end,
      })


      -- Define an 'on_attach' function to set up key mappings when an LSP client attaches to a buffer
        local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Key mappings
        local opts = { noremap=true, silent=true }
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        -- Add more mappings as needed
      end



      -- Setup 'rust-tools'
      require('rust-tools').setup({
        server = {
          on_attach = on_attach,
          capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        },
      })

      require('lspconfig').rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = {"*.rs"},
        callback = function()
          vim.lsp.buf.format({ timeout_ms = 1000, async = false })
        end,
      })

      -- Set up nvim-cmp
      local cmp = require('cmp')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    '';
  };
}

