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
      vim-vsnip
      cmp-vsnip
    ];
    extraConfig = ''
      lua << EOF
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
