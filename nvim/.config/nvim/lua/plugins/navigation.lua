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
            local lga_actions = require("telescope-live-grep-args.actions")
            local lga_shortcuts = require("telescope-live-grep-args.shortcuts")

            local lga_mappings = {
                i = {
                    ["<C-k>"] = lga_actions.quote_prompt(),
                    ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t " }),
                    ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                },
            }

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
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = lga_mappings,
                    },
                },
            })

            telescope.load_extension("ui-select")
            telescope.load_extension("fzf")
            telescope.load_extension("live_grep_args")

            local action_state = require("telescope.actions.state")
            local function find_files_filtered(ext)
                local cmd = { "rg", "--files", "--hidden", "--glob", "!.git" }
                if ext and ext ~= "" then
                    table.insert(cmd, "--glob")
                    table.insert(cmd, "*." .. ext)
                end
                require("telescope.builtin").find_files({
                    find_command = cmd,
                    attach_mappings = function(_, map)
                        map("i", "<C-t>", function(prompt_bufnr)
                            local prompt = action_state.get_current_picker(prompt_bufnr):_get_prompt()
                            actions.close(prompt_bufnr)
                            vim.ui.input({ prompt = "Extension filter (e.g. py, lua): " }, function(input)
                                find_files_filtered(input)
                            end)
                        end)
                        return true
                    end,
                })
            end

            local keymap = vim.keymap
            keymap.set("n", "<leader>ff", function() find_files_filtered() end)
            keymap.set("n", "<leader>fs", function()
                require("telescope").extensions.live_grep_args.live_grep_args({
                    mappings = lga_mappings,
                })
            end)
            keymap.set("n", "<leader>fc", function()
                lga_shortcuts.grep_word_under_cursor()
            end)
            keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
            keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
        end,
    },

    -- Tmux Navigation
    { "christoomey/vim-tmux-navigator" },

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
