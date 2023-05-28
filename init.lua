return {
  options = {
    opt = {
      colorcolumn = "120",
    },
  },
  lsp = {
    formatting = {
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
      },
    },
    config = {
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              flake8 = { enabled = false },
              mccabe = { enabled = false },
              pycodestyle = { enabled = false },
              pyflakes = { enabled = false },
              pylint = { enabled = false },
            },
          },
        },
      },
    }

  },

  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      -- mappings seen under group name "Buffer"
      ["<leader>r"] = { 'oimport pdb;<Space>pdb.set_trace()<Esc>k', desc = "Insert breakpoint" },
      ["s"] = { ':nohlsearch<cr>', desc = "Clear search highlights" },
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  },

  plugins = {
    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end
    },
    {
      "dense-analysis/ale",
      event = "BufEnter *.py",
      init = function()
        vim.g.ale_lint_on_insert_leave = 1
      end
    },
  },
}
