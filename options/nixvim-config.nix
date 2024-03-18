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

      vim.api.nvim_set_keymap('n', '<leader>r', '<cmd>lua RunAndShowOutput("cargo run")<CR>', {noremap = true, silent = true})


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


    function RunCargoRunInProjectRoot()
      local current_file = vim.fn.expand('%:p') -- Get the full path of the current file
      local current_dir = vim.fn.fnamemodify(current_file, ':h') -- Get the directory of the current file

      -- Find the Cargo.toml file by searching upwards from the current directory
      local cargo_toml_path = vim.fn.findfile("Cargo.toml", current_dir .. ";")

      if cargo_toml_path == "" then
	print("Cargo.toml not found. Are you inside a Rust project?")
	return
      end

      local project_root = vim.fn.fnamemodify(cargo_toml_path, ':h') -- Get the directory of Cargo.toml

      -- Function to create and display the floating window with output
      local function show_output_in_floating_window(output)
	local buf = vim.api.nvim_create_buf(false, true) -- creates a new empty buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")
	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)
	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)

	local opts = {
	  relative = "editor",
	  width = win_width,
	  height = win_height,
	  row = row,
	  col = col,
	  style = "minimal",
	  border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
      end

      -- Run 'cargo run' in the project root directory and capture the output
      vim.fn.jobstart("cargo run", {
	cwd = project_root,
	on_stdout = function(_, data)
	  if data then
	    show_output_in_floating_window(data)
	  end
	end,
	stdout_buffered = true,
      })
    end





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

