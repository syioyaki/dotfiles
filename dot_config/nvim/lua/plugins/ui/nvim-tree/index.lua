return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim"
  },
  lazy = false,
  config = function()
    require("nvim-tree").setup({
      sort_by = "extension",

      view = {
        width = "20%",
        side = "right",
        signcolumn = "no",
      },

      renderer = {
        highlight_git = true,
        highlight_opened_files = "name",
        icons = {
          glyphs = {
            git = {
              unstaged = "!",
              renamed = "»",
              untracked = "?",
              deleted = "✘",
              staged = "✓",
              unmerged = "",
              ignored = "◌",
            },
          },
        },
      },

      git = {
        enable = true,
        ignore = false,
      },

      actions = {
        expand_all = {
          max_folder_discovery = 100,
          exclude = { ".git", "target", "build" },
        },
      },

      -- on_attach = "default"
      on_attach = require("plugins.ui.nvim-tree.actions").on_attach,

    })
    vim.api.nvim_create_user_command("Ex", function() vim.cmd.NvimTreeToggle() end, {})
    vim.api.nvim_set_keymap("n", "<leader>ex", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
  end,
}
