vim.g.mapleader = " "

-- keymaps
local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>") -- jk to exit inset mode
keymap.set("n", "<leader>nh", ":nohl<CR>") -- nh to clear the search highlights
keymap.set("n", "x", "_x") -- delete a character but don't copy it to the register
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>sx", ":close<CR>") -- close a split window
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- move to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- move to previous tab
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle nvim-tree
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
