local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()


-- autocmmand which will reload neovim when this file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")

if not status then
    return
end

return packer.startup(function(use)
    use("nvim-lua/plenary.nvim")
    use("wbthomason/packer.nvim")
    -- use("bluz71/vim-nightfly-guicolors")
    -- colors
    --use ('Mofiqul/dracula.nvim')
    use { "ellisonleao/gruvbox.nvim" }
    --use ('morhetz/gruvbox')
    --use ('luisiacc/gruvbox-baby')
    --use ('folke/tokyonight.nvim')
    --use { "alexanderbluhm/black.nvim" }
    use("christoomey/vim-tmux-navigator")
    use("nvim-tree/nvim-tree.lua")
    use("kyazdani42/nvim-web-devicons")
    use("nvim-lualine/lualine.nvim")
    --    use({"nvim-telescope/telescope-fzf-native.nvim", run = "make"}) -- dependency for telescope
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }
    --    use({
    --        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --        config = function()
    --            require("lsp_lines").setup()
    --                end,
    --        })
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use("jiangmiao/auto-pairs")
    use('neovim/nvim-lspconfig')
    use('jose-elias-alvarez/null-ls.nvim')
    use('MunifTanjim/prettier.nvim')
    use('ThePrimeagen/vim-be-good')
    if packer_bootstrap then
        require("packer").sync()
    end
end)
