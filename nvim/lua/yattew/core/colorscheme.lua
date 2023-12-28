-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
    palette_overrides = {
        dark0 = "#1D2021",
    }
})
vim.cmd("colorscheme gruvbox")
