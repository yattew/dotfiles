local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)
vim.diagnostic.config({
  virtual_text = false,
})
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'rust_analyzer', 'lua_ls', 'gopls', 'clangd', 'ocamllsp'},
  handlers = {
    lsp_zero.default_setup,
  },
})
