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

    extraConfigVim = '''
      autocmd BufEnter,WinEnter * set signcolumn=yes
    ''';

    extraConfigLua = '''
      vim.g.mapleader = " "
      vim.api.nvim_set_keymap('n', '<leader>lg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>gs', ':Telescope grep_string<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>o', ':CHADopen<CR>', { noremap = true, silent = true })
      -- more configurations...
    ''';
  };
}

