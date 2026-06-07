return {
    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },

    -- Git Signs (gutter changes)
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            attach_to_untracked = true,
            numhl = true,
        },
    },

    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },

    -- Surround
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            local ft = require("Comment.ft")

            -- Avoid crash in Neovim 0.12+ when Treesitter parser is not installed
            local old_calculate = ft.calculate
            ft.calculate = function(ctx)
                local ok, parser = pcall(vim.treesitter.get_parser, 0)
                if not ok or not parser then
                    return ft.get(vim.bo.filetype, ctx.ctype)
                end
                return old_calculate(ctx)
            end

            require("Comment").setup()
            ft.set("erlang", "%% %s")
        end,
    },

    -- Undo history
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
        end,
    },

    -- Git
    { "tpope/vim-fugitive" },

    -- Gemini AI
    {
        "jonroosevelt/gemini-cli.nvim",
        config = function()
            require("gemini").setup()
        end,
    },

    -- CSV Viewer
    {
        "hat0uma/csvview.nvim",
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    },

    -- Essential utilities
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },

    -- Local AI Refactoring Assistant (Ollama)
    {
        "David-Kunz/gen.nvim",
        opts = {
            model = "qwen2.5-coder:7b",
            display_mode = "float",
            show_prompt = true,
            body = {
                stream = true,
                think = false,
            },
            win_config = {
                relative = "editor",
                width = 110,    -- Wider for better code reading
                height = 30,    -- Taller for displaying more code context
                border = "rounded",
            },
        },
        keys = {
            { "<leader>ai", ":Gen Ask<CR>", mode = { "v" }, desc = "Ask AI about code" },
            { "<leader>ai", ":Gen Chat<CR>", mode = { "n" }, desc = "Chat with AI" },
        },
    },
}
