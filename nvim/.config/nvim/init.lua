-- Set mapleader before anything else
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim and load plugins from lua/plugins/*.lua
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    install = { colorscheme = { "rose-pine" } },
    checker = { enabled = false }, -- disable automatic update checks
    change_detection = { notify = false }, -- disable notifications when config changes
})

-- Load general settings and keymaps
require("config.options")
require("config.keymaps")
