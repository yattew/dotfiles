return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Global LSP config
            vim.lsp.config("*", { capabilities = capabilities })

            -- Server-specific configs
            vim.lsp.config("lua_ls", {
                root_dir = function(fname)
                    return vim.fs.root(fname, {
                        ".luarc.json",
                        ".luacheckrc",
                        ".stylua.toml",
                        "selene.toml",
                        "init.lua",
                        ".git",
                    })
                end,
            })

            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                },
            })

            vim.lsp.config("erlangls", {
                cmd = { "erlang_ls" },
                filetypes = { "erlang" },
                handlers = {
                    ["textDocument/publishDiagnostics"] = function() end, -- Mute all diagnostics from erlang_ls
                    ["window/showMessage"] = function(err, result, ctx, config)
                        -- Ignore the annoying popup warning about missing erlang_ls.config
                        if result and result.message and result.message:find("missing an erlang_ls.config file") then
                            return
                        end
                        vim.lsp.handlers["window/showMessage"](err, result, ctx, config)
                    end,
                },
                on_attach = function(client, bufnr)
                    -- Disable definition and formatting to let elp handle it
                    client.server_capabilities.definitionProvider = false
                    client.server_capabilities.documentFormattingProvider = false
                end,
                settings = {
                    erlang_ls = {
                        -- Disable diagnostics in erlang_ls to avoid duplicate reports with elp
                        diagnostics = {
                            disabled = { "dialyzer", "elvis" }
                        }
                    }
                }
            })

            vim.lsp.config("elp", {
                filetypes = { "erlang" },
            })

            vim.lsp.config("elixirls", {
                filetypes = { "elixir", "eelixir", "heex", "surface" },
            })

            -- Enable servers
            local servers = {
                "ts_ls",
                "rust_analyzer",
                "lua_ls",
                "gopls",
                "clangd",
                "html",
                "templ",
                "jedi_language_server",
                "elp",
                "erlangls",
                "elixirls",
            }
            for _, server in ipairs(servers) do
                vim.lsp.enable(server)
            end

            -- LSP Keymaps
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
        end,
    },

    -- Mason for managing LSP servers, formatters, and linters
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        commit = "43894ad",
        opts = {
            ensure_installed = {
                "ts_ls",
                "rust_analyzer",
                "lua_ls",
                "gopls",
                "clangd",
                "html",
                "jedi_language_server",
                "elp",
                "templ",
                "elixirls",
                },
                automatic_installation = true,
        },
    },

    -- Conform.nvim for formatting
    {
        "stevearc/conform.nvim",
        config = function()
            local conform = require("conform")
            conform.setup({
                formatters_by_ft = {
                    json = { "prettier" },
                    jsonc = { "prettier" },
                    lua = { "stylua" },
                    python = { "black" },
                    erlang = { "erlfmt" },
                    elixir = { "mix" },
                },
            })

            vim.keymap.set("n", "<leader>fmt", function()
                conform.format({
                    lsp_fallback = true,
                    async = true,
                }, function(err)
                    if err then
                        local view = vim.fn.winsaveview()
                        vim.cmd("normal! gg=G")
                        vim.fn.winrestview(view)
                        vim.notify("Formatted with built-in indentation", vim.log.levels.INFO)
                    end
                end)
            end, { desc = "Format buffer (Conform -> LSP -> Built-in)" })
        end,
    },

    -- Prettier
    {
        "MunifTanjim/prettier.nvim",
        config = function()
            require("prettier").setup({
                ["null-ls"] = {
                    condition = function()
                        return require("prettier").config_exists({
                            check_package_json = true,
                        })
                    end,
                    timeout = 5000,
                },
            })
        end,
    },

    -- Hover
    {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup({
                init = function()
                    require("hover.providers.lsp")
                    require("hover.providers.diagnostic")
                    require("hover.providers.man")
                end,
                preview_opts = { border = "single", focusable = true },
                preview_window = false,
                title = true,
                mouse_delay = 1000,
            })

            vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
            vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
            vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end)
            vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end)
            vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse)
            vim.o.mousemoveevent = true
        end,
    },
}
