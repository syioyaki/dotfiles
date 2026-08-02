-- telescope.nvimと競合するため無効化
vim.api.nvim_set_var("loaded_netrw", 1)
vim.api.nvim_set_var("loaded_netrwPlugin", 1)
-- タイムアウトの設定
vim.opt.timeoutlen = 500


-- 言語設定
vim.cmd.language("ja_JP.utf8")
vim.opt.helplang = "ja"
if vim.fn.has("gui_running") == 1 then
    vim.o.guifont = "HackGen Console NF:h14"
end

require("config.indent")
require("config.ui")
require("config.keymaps")

require("config.lazy")

vim.cmd.colorscheme("catppuccin")
