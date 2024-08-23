-- Plugin management using packer.nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
  end
end

ensure_packer()

-- Initialize plugins
return require('packer').startup(function()
  use 'wbthomason/packer.nvim'            -- Plugin manager
  use 'tpope/vim-sensible'                -- Sensible defaults for Vim
  use 'preservim/nerdtree'                -- File explorer
  use 'neovim/nvim-lspconfig'             -- LSP configurations
  use 'simrat39/rust-tools.nvim'          -- Rust tools for Neovim
  use 'hrsh7th/nvim-cmp'                  -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'              -- LSP source for nvim-cmp
  use 'nvim-lua/plenary.nvim'             -- Common utilities
  use 'jose-elias-alvarez/null-ls.nvim'   -- Linter and formatter integration
  use 'gruvbox-community/gruvbox'         -- Gruvbox color scheme
end)

