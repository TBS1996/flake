-- LSP and Rust configuration

-- Set up nvim-cmp (autocompletion)
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)  -- For `vsnip` users
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  })
})

-- Configure rust-analyzer with rust-tools.nvim
local nvim_lsp = require('lspconfig')
local rust_tools = require('rust-tools')

rust_tools.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Key mappings for LSP functions
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local opts = { noremap=true, silent=true }

      -- LSP keybindings
      buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    end,
  }
})

-- Configure diagnostics and formatting with null-ls.nvim
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.rustfmt,  -- Use rustfmt for formatting
    null_ls.builtins.diagnostics.clippy   -- Use Clippy for linting
  }
})

