return {
    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        opts = {
            actions = {
                open_file = {
                    window_picker = { enable = false },
                    resize_window = false,
                },
            },
            view = {
                relativenumber = true,
                width = 50,
                preserve_window_proportions = true,
            },
            update_focused_file = { enable = true },
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<esc>"] = actions.close,
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            telescope.load_extension("ui-select")
            telescope.load_extension("fzf")
            telescope.load_extension("live_grep_args")
            local keymap = vim.keymap
            keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
            keymap.set("n", "<leader>fs", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
            keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
            keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
            keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
        end,
    },

    -- (vim-tmux-navigator removed in favor of native custom Herdr mapping)

    -- Flash.nvim (jump navigation)
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        },
    },
}
