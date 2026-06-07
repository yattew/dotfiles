local opt = vim.opt

-- General options
opt.number = true          -- absolute line numbers
opt.relativenumber = true  -- relative line numbers
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
opt.splitright = true
opt.splitbelow = true
opt.backspace = "indent,eol,start"
opt.iskeyword:append("-")
opt.clipboard:append("unnamedplus")
opt.guicursor = ""
opt.scrolloff = 5

-- Commands
vim.cmd("set list")
vim.cmd("set listchars=trail:~,tab:>-,nbsp:␣")
vim.cmd([[highlight ColorColumn ctermbg=0 guibg=lightgrey]])

-- Diagnostic config
vim.diagnostic.config({
    virtual_text = false, -- Disable inline virtual text to prevent visual clutter
    severity_sort = true,
    float = { border = "rounded" },
})
