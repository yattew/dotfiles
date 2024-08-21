vim.g.mapleader = " "

vim.cmd("set list")
vim.cmd("set listchars=trail:~,tab:>-,nbsp:␣")

-- keymaps --
local keymap = vim.keymap
keymap.set("i", "jk", "<ESC>") -- jk to exit inset mode
keymap.set("i", "<C-l>", "<right>")
keymap.set("n", "<leader>nh", ":nohl<CR>") -- nh to clear the search highlights
keymap.set("n", "x", "x") -- delete a character but don't copy it to the register
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<c-w>s") -- split window horizontally
keymap.set("n", "<leader>sx", ":close<CR>") -- close a split window
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- move to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- move to previous tab
keymap.set("n", "K", "") -- move to previous tab
-- keymaps end --

function diagnostic_window()
	local opts = {
		focusable = true,
		border = "rounded",
		source = "always",
		prefix = " ",
		scope = "line",
		severit_sort = true,
	}
	vim.diagnostic.open_float(opts)
end

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--     border = "rounded",
--
-- })

local set_hl_for_floating_window = function()
	vim.api.nvim_set_hl(0, "NormalFloat", {
		link = "Normal",
	})
end

set_hl_for_floating_window()
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	desc = "Avoid overwritten by loading color schemes later",
	callback = set_hl_for_floating_window,
})
keymap.set("n", "gl", ":lua diagnostic_window()<CR>")

-- options --
local opt = vim.opt
opt.relativenumber = true
opt.number = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.iskeyword:append("-")
opt.guicursor = ""
-- options end --

-- plugins  --
local plugins = {
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
			palette_overrides = {},
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
			auto_install = true,
			highlight = {
				enable = true,
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
		init = function() end,
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
			view = {
				relativenumber = true,
			},
		},
		init = function()
			vim.g.loaded = 1
			vim.g.loaded_netrwPlugin = 1
			keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle nvim-tree
		end,
	},
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
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<esc>"] = actions.close,
						},
					},
				},
			})

			telescope.load_extension("fzf")
			keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files
			-- keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
			keymap.set("n", "<leader>fs", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
			keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
			keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
			keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
		end,
	},
	{ "jiangmiao/auto-pairs" },
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- "tsserver",
					"lua_ls",
					"gopls",
					"clangd",
					"html",
					"jedi_language_server",
					-- "pylsp",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.tsserver.setup({ capabilities = capabilities })
			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.lua_ls.setup({
				root_dir = function(fname)
					local util = require("lspconfig.util")
					local root_files = {
						".luarc.json",
						".luacheckrc",
						".stylua.toml",
						"selene.toml",
						"init.lua",
					}
					return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
				end,
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({ capabilities = capabilities })
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--offset-encoding=utf-16",
				},
			})
			lspconfig.ocamllsp.setup({ capabilities = capabilities })
			lspconfig.html.setup({ capabilities = capabilities })
			lspconfig.templ.setup({ capabilities = capabilities })
			lspconfig.jedi_language_server.setup({ capabilities = capabilities })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier.with({}),
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.black,
					-- null_ls.builtins.completion.spell,
				},
			})
			keymap.set("n", "<leader>fmt", function()
				vim.lsp.buf.format()
			end)
			-- keymap.set("n", "<leader>fmt", ":lua vim.lsp.buf.format()<CR>") -- format open buffer
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "nvim_lsp_signature_help" },
					--{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
				}, {
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
			cmp.visible_docs()
			-- vim.cmd(':set winhighlight=' .. cmp.config.window.bordered().winhighlight)
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"lewis6991/hover.nvim",
		config = function()
			require("hover").setup({
				init = function()
					-- Require providers
					require("hover.providers.lsp")
					-- require('hover.providers.gh')
					-- require('hover.providers.gh_user')
					-- require('hover.providers.jira')
					-- require('hover.providers.dap')
					-- require('hover.providers.fold_preview')
					require("hover.providers.diagnostic")
					require("hover.providers.man")
					-- require('hover.providers.dictionary')
				end,
				preview_opts = {
					border = "single",
				},
				-- Whether the contents of a currently open hover window should be moved
				-- to a :h preview-window when pressing the hover keymap.
				preview_window = true,
				title = true,
				mouse_providers = {
					-- 'LSP'
				},
				mouse_delay = 1000,
			})

			-- Setup keymaps
			vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
			vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
			vim.keymap.set("n", "<C-p>", function()
				require("hover").hover_switch("previous")
			end, { desc = "hover.nvim (previous source)" })
			vim.keymap.set("n", "<C-n>", function()
				require("hover").hover_switch("next")
			end, { desc = "hover.nvim (next source)" })

			-- Mouse support
			vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
			vim.o.mousemoveevent = true
		end,
	},
	{ "github/copilot.vim" },
	{
		"MunifTanjim/prettier.nvim",
		config = function()
			local prettier = require("prettier")

			prettier.setup({
				["null-ls"] = {
					condition = function()
						return prettier.config_exists({
							-- if `false`, skips checking `package.json` for `"prettier"` key
							check_package_json = true,
						})
					end,
					runtime_condition = function(params)
						-- return false to skip running prettier
						return true
					end,
					timeout = 5000,
				},
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon") -- basic telescope configuration
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			vim.keymap.set("n", "<C-e>", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Open harpoon window" })

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end)
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
		end,
	},
	{ "tpope/vim-fugitive" },
}
-- plugins end --

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
-- lazy.nvim --

vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins)
-- lazy.nvim --
