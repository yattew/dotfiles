vim.g.mapleader = " "

-- keymaps --
local keymap = vim.keymap
keymap.set("i", "jk", "<ESC>")                                 -- jk to exit inset mode
keymap.set("i", "<C-l>", "<right>")
keymap.set("n", "<leader>nh", ":nohl<CR>")                     -- nh to clear the search highlights
keymap.set("n", "x", "x")                                      -- delete a character but don't copy it to the register
keymap.set("n", "<leader>sv", "<C-w>v")                        -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s")                        -- split window horizontally
keymap.set("n", "<leader>sx", ":close<CR>")                    -- close a split window
keymap.set("n", "<leader>to", ":tabnew<CR>")                   -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>")                 -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>")                     -- move to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>")                     -- move to previous tab
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")            -- toggle nvim-tree
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
keymap.set("n", "<leader>fmt", ":lua vim.lsp.buf.format()<CR>") -- format open buffer
-- keymaps end --

-- options --
local opt = vim.opt
-- line numbers
opt.relativenumber = true
opt.number = true
-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
-- line wrapping
-- opt.wrap = false
-- search settings
opt.ignorecase = true
opt.smartcase = true
-- cursor line
opt.cursorline = true
-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
-- backspace
opt.backspace = "indent,eol,start"
-- clipboard
opt.clipboard:append("unnamedplus")
--split windows
opt.splitright = true
opt.splitbelow = true
opt.iskeyword:append("-")
opt.guicursor = ""
-- options end --

-- plugins  --
plugins = {
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            terminal_colors = true, -- add neovim terminal colors
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            contrast = "", -- can be "hard", "soft" or empty string
            palette_overrides = {
                dark0 = "#1D2021",
            },
            overrides = {},
            dim_inactive = false,
            transparent_mode = false,
        },
        init = function()
            vim.cmd("colorscheme gruvbox")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
            auto_install = false,
            highlight = {
                enable = true,
                disable = {},
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
        },
        init = function()
            vim.filetype.add({
                extension = {
                    templ = "templ",
                },
            })

            -- Make sure we have a tree-sitter grammar for the language
            local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            treesitter_parser_config.templ = treesitter_parser_config.templ
                or {
                    install_info = {
                        url = "https://github.com/vrischmann/tree-sitter-templ.git",
                        files = { "src/parser.c", "src/scanner.c" },
                        branch = "master",
                    },
                }

            vim.treesitter.language.register("templ", "templ")

            -- Register the LSP as a config
            local configs = require("lspconfig.configs")
            if not configs.templ then
                configs.templ = {
                    default_config = {
                        cmd = { "templ", "lsp" },
                        filetypes = { "templ" },
                        root_dir = require("lspconfig.util").root_pattern("go.mod", ".git"),
                        settings = {},
                    },
                }
            end
        end,
    },
    { "nvim-lua/plenary.nvim" },
    { "christoomey/vim-tmux-navigator" },
    {
        "nvim-tree/nvim-tree.lua",
        opts = {
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                },
            },
        },
        init = function()
            vim.g.loaded = 1
            vim.g.loaded_netrwPlugin = 1
        end,
    },
    { "kyazdani42/nvim-web-devicons" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { options = { theme = "gruvbox" } },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build =
                "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
        },
        config = function()
            local telescope_setup, telescope = pcall(require, "telescope")
            if not telescope_setup then
                return
            end

            local actions_setup, actions = pcall(require, "telescope.actions")
            if not actions_setup then
                return
            end

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        },
                    },
                },
            })

            telescope.load_extension("fzf")
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- LSP Support
            {
                "neovim/nvim-lspconfig",
            },
            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" },
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)
            vim.diagnostic.config({
                virtual_text = true,
            })
            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "tsserver",
                    "rust_analyzer",
                    "lua_ls",
                    "gopls",
                    "clangd",
                    "ocamllsp",
                    "html",
                    "templ",
                },
                handlers = {
                    lsp_zero.default_setup,
                },
            })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.completion.spell,
                },
            })
        end,
    },
    { "jiangmiao/auto-pairs" },
}
-- plugins end --

-- lazy.nvim --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins)
-- lazy.nvim --
