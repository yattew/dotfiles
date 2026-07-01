local keymap = vim.keymap

-- General keymaps
keymap.set("x", "p", "pgvy", { noremap = true, silent = true })
keymap.set("i", "jk", "<ESC>")                           -- jk to exit inset mode
keymap.set("i", "<C-l>", "<right>")
keymap.set("n", "<leader>nh", ":nohl<CR>")               -- nh to clear the search highlights
keymap.set("n", "x", "x")                                -- delete a character but don't copy it to the register
keymap.set("n", "<leader>sv", "<C-w>v")                  -- split window vertically
keymap.set("n", "<leader>sh", "<c-w>s")                  -- split window horizontally
keymap.set("n", "<leader>sx", ":close<CR>")              -- close a split window
keymap.set("n", "<leader>to", ":tabnew<CR>")             -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>")           -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>")               -- move to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>")               -- move to previous tab
keymap.set("n", "<leader>ts", ":tab split<CR>")          -- move to previous tab
keymap.set("n", "<leader>rj", ":resize +5<CR>")          -- resize pane vertically larger
keymap.set("n", "<leader>rk", ":resize -5<CR>")          -- resize pane vertically smaller
keymap.set("n", "<leader>rl", ":vertical resize +5<CR>") -- resize pane horizontally larger
keymap.set("n", "<leader>rh", ":vertical resize -5<CR>") -- resize pane horizontally smaller
keymap.set("n", "<leader>rsz", ":wincmd =<CR>")          -- balance windows

-- Buffer path copying
function CopyBufferPath()
    local filepath = vim.fn.expand("%:p")
    vim.fn.setreg("+", filepath)
    print("Copied file path to clipboard: " .. filepath)
end
keymap.set("n", "<leader>cfp", CopyBufferPath, { noremap = true, silent = true, desc = "Copy buffer path" })

-- Diagnostic window
function diagnostic_window()
    local opts = {
        focusable = true,
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "line",
        severity_sort = true,
    }
    vim.diagnostic.open_float(opts)
end
keymap.set("n", "gl", diagnostic_window, { desc = "Open diagnostic window" })

-- Herdr Smart Navigation
local function herdr_navigate(dir_vim, dir_herdr)
    local cur_win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd " .. dir_vim)
    if vim.api.nvim_get_current_win() == cur_win then
        if vim.env.HERDR_SOCKET_PATH then
            vim.fn.system("herdr pane focus --direction " .. dir_herdr)
        elseif vim.env.TMUX then
            local dir_tmux = dir_vim == "h" and "L" or dir_vim == "j" and "D" or dir_vim == "k" and "U" or "R"
            vim.fn.system("tmux select-pane -" .. dir_tmux)
        end
    end
end
keymap.set("n", "<C-h>", function() herdr_navigate("h", "left") end, { silent = true })
keymap.set("n", "<C-j>", function() herdr_navigate("j", "down") end, { silent = true })
keymap.set("n", "<C-k>", function() herdr_navigate("k", "up") end, { silent = true })
keymap.set("n", "<C-l>", function() herdr_navigate("l", "right") end, { silent = true })
