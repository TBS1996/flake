{ pkgs, ... }: {

  pkgs.programs.nixvim = {
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
      chadtree.enable = true;
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

    extraConfigVim = ''
      autocmd BufEnter,WinEnter * set signcolumn=yes
    '';

    extraConfigLua = ''
      vim.g.mapleader = " "
      vim.api.nvim_set_keymap('n', '<leader>lg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>gs', ':Telescope grep_string<CR>', { noremap = true, silent = true })

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
    '';
  };
}

