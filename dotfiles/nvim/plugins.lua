-- Plugin management using packer.nvim
-- Ensure packer.nvim is installed, or install it if not
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
  use 'wbthomason/packer.nvim'    -- Plugin manager
  use 'tpope/vim-sensible'        -- Sensible defaults for Vim
  use 'preservim/nerdtree'        -- File explorer
end)

