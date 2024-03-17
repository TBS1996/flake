{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      rust-tools-nvim
    ];
    extraConfig = ''
      lua << EOF
      -- Set up nvim-cmp
      local cmp = require('cmp')
      cmp.setup({
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })

      -- Set up LSP client capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Set up Rust tools
      require('rust-tools').setup({
        server = {
          on_attach = function(_, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          end,
          capabilities = capabilities,
        },
      })

      -- Set up Rust analyzer
      require('lspconfig').rust_analyzer.setup({
        capabilities = capabilities,
      })
      EOF
    '';
  };
}
