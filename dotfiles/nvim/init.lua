-- Load external Lua configuration files
require('plugins')
require('keymaps')
require('rust')  -- Add this line to load the Rust configuration

vim.cmd('syntax enable')            -- Enable syntax highlighting
vim.o.background = "dark"           -- Use dark background (or "light" for a light version)
vim.cmd('colorscheme gruvbox')      -- Set the color scheme to Gruvbox
