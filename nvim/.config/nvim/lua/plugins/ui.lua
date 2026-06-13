return {
    -- Colorscheme
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "none" })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#c0caf5", bg = "none" })
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                component_separators = "",
                section_separators = { left = "", right = "" },
                theme = "rose-pine",
            },
            sections = {
                lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
                lualine_y = {
                    { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                },
                lualine_z = {
                    {
                        function()
                            return " " .. os.date("%R")
                        end,
                        separator = { right = "" },
                    },
                },
            },
        },
    },

    -- Tabline
    {
        "crispgm/nvim-tabline",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
    },

    -- Smooth Scrolling
    { "psliwka/vim-smoothie" },

    -- Auto-focus and resize split windows
    {
        "beauwilliams/focus.nvim",
        config = function()
            require("focus").setup({
                enable = true,
                commands = true,
                autoresize = {
                    enable = true,
                    width = 0, -- Calculates based on Golden Ratio
                    height = 0,
                    min_width = 80, -- Minimum width of active split
                    min_height = 10,
                },
                ui = {
                    number = false, -- Don't let focus manage line numbers
                    relativenumber = false,
                    hybridnumber = false,
                    cursorline = true, -- Highlight active window cursorline
                    signcolumn = true,
                }
            })
        end,
    },

    -- Smooth window resizing animation
    {
        "echasnovski/mini.animate",
        event = "VeryLazy",
        config = function()
            local animate = require("mini.animate")
            animate.setup({
                resize = {
                    enable = true,
                    timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
                },
                cursor = { enable = false },
                scroll = { enable = false },
                open = { enable = false },
                close = { enable = false },
            })
        end,
    },

    -- Colorful Rainbow Brackets
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "VeryLazy",
    },

    -- Liquid smooth cursor smear effect
    {
        "sphamba/smear-cursor.nvim",
        opts = {
            stiffness = 0.8,               -- 0.1 (loose) to 1.0 (strict)
            trailing_stiffness = 0.5,      -- 0.1 (loose) to 1.0 (strict)
            distance_stop_animating = 0.5, 
        },
    },

}
