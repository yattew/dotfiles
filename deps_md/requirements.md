## 1. Zsh (Shell Configuration)

### 📂 Config Files to Stow:
* `~/.zshrc`
* `~/.zprofile`

### 🛠️ Required Dependencies:
1. **Oh My Zsh**: The shell framework wrapper.
2. **zsh-syntax-highlighting**: Syntax highlighting plugin.
3. **zsh-autosuggestions**: Command auto-suggestion plugin.
4. **Starship**: The prompt customizer.
5. **eza**: Modern replacement for `ls`.
6. **bat**: Enhanced replacement for `cat`.
7. **fzf**: Fuzzy finder for command history (`Ctrl + r`).

---

## 2. Neovim (Editor Configuration)

### 📂 Config Files to Stow:
* `~/.config/nvim/`

### 🛠️ Required Dependencies:
1. **ripgrep (`rg`)**: Required globally for Telescope fuzzy code searching (`<leader>fs`).
2. **rebar3**: Erlang build tool (required for Mason to build `erlangls`).
3. **erlfmt**: Erlang code formatter (installed globally via Homebrew for `conform.nvim` formatting).
4. **erlang_ls**: Erlang Language Server (installed globally via Homebrew for autocomplete specs).
5. **LSPs & Formatters (Managed by Mason):**
   * `elp` (Erlang type-checking/navigation)
   * `ts_ls` (JavaScript/TypeScript)
   * `gopls` (Go)
   * `jedi-language-server` (Python)
   * `clangd` (C/C++)
   * `html` (HTML)
   * `templ` (Go templates)
6. **Ollama**: Local AI assistant engine (requires `qwen2.5-coder:3b` model downloaded).
7. **focus.nvim**: Auto-resizes active windows when splits are focused.
8. **mini.animate**: Smoothly animates window resizing transitions.
9. **rainbow-delimiters.nvim**: Adds colorful depth-based highlighting to nested brackets.
10. **smear-cursor.nvim**: Adds a liquid smooth comet tail trailing effect to the cursor.
11. **gitsigns.nvim**: Adds subtle git diff indicators to the sign column.

---

## 3. Tmux (Terminal Multiplexer)

### 📂 Config Files to Stow:
* `~/.tmux.conf`

### 🛠️ Required Dependencies:
1. **TPM (Tmux Plugin Manager)**: Manages tmux plugins like Catppuccin.
2. **pbcopy / pbpaste**: Native macOS clipboard tools (used by copy binds).

---

## 4. AeroSpace (Window Manager)

### 📂 Config Files to Stow:
* `~/.aerospace.toml`
* `~/.config/borders/bordersrc` (JankyBorders config)

### 🛠️ Required Dependencies:
1. **AeroSpace**: i3-like window manager app for macOS.
2. **JankyBorders**: Draws beautiful colored borders around active windows (`brew tap FelixKratz/formulae && brew install borders`).

