# System Configuration & Tool Requirements

This document lists all the core applications, CLI utilities, LSPs, and formatters currently configured and integrated into your macOS workspace, along with their active versions and installation scopes.

---

## 1. Core Environments & Shells

| Tool / Dependency | Active Version | Install Manager | Command / Path | Purpose & Comments |
| :--- | :--- | :--- | :--- | :--- |
| **Homebrew** | `5.1.15` | System (macOS) | `brew` | System package manager used to install shell tools and formatters. |
| **Zsh** | `5.9` | macOS Native | `zsh` | Active shell runtime. Configured via `~/.zshrc` and `~/.zprofile`. |
| **Tmux** | `3.6a` | Homebrew | `tmux` | Terminal multiplexer. Configured with mouse-drag copy and custom status bars. |
| **Node.js** | `v26.0.0` | System Global | `node` | JavaScript/TypeScript runtime used globally (detected by Starship). |
| **Erlang/OTP** | `29` | System Global | `erl` | Erlang runtime engine. |
| **Ollama** | *Active* | System (Local) | `ollama` | Offline local LLM engine. Powers the local Neovim AI assistant. |

---

## 2. CLI Shell & Telescope Utilities

| Tool / Dependency | Active Version | Install Manager | Command / Path | Purpose & Comments |
| :--- | :--- | :--- | :--- | :--- |
| **Starship** | `1.25.1` | Homebrew | `starship` | Modern, Rust-based shell prompt customizer. |
| **eza** | `0.23.4` | Homebrew | `eza` | Modern, icon-enabled directory lister (aliased to `ls` and `ll`). |
| **bat** | `0.26.1` | Homebrew | `bat` | Enhanced `cat` replacement with syntax highlighting and git diff margins. |
| **fzf** | `0.73.1` | Homebrew | `fzf` | Command-line fuzzy finder. Active on `Ctrl + r` for shell history search. |
| **ripgrep (rg)** | `15.1.0` | Homebrew | `rg` | High-performance code search tool. Required by Telescope `<leader>fs`. |

---

## 3. Editors & Language Servers (LSPs)

| Tool / Dependency | Active Version | Install Manager | Command / Path | Purpose & Comments |
| :--- | :--- | :--- | :--- | :--- |
| **Neovim** | `v0.12.2` | Homebrew (nightly) | `nvim` (alias `v`, `vim`) | Primary IDE. Configured with Lazy, autocomplete, and diagnostics. |
| **elp** (Erlang) | `1.1.0` | Neovim (Mason) | `~/.../mason/bin/elp` | Erlang Language Platform LSP. Handles jump-to-definition, errors, and Eqwalizer. |
| **erlangls** (Erlang) | *Auto-installed* | Neovim (Mason) | `~/.../mason/bin/erlang_ls` | Erlang LS. Provides autocomplete for type specs (`integer()`, etc.). |
| **gopls** (Go) | `v0.22.0` | Neovim (Mason) | `~/.../mason/bin/gopls` | Go Language Server LSP. |
| **clangd** (C/C++) | `17.0.0` | Xcode Command Tools | `clangd` | C/C++ compiler-front LSP. |
| **ts_ls** (JS/TS) | `5.3.0` | Neovim (Mason) | `~/.../mason/bin/typescript-language-server` | TypeScript & JavaScript LSP. |
| **jedi-language-server** | `0.46.0` | Neovim (Mason) | `~/.../mason/bin/jedi-language-server` | Python LSP. |

---

## 4. Formatters & AI Assist (Conform / Local LLM)

| Tool / Dependency | Active Version | Install Manager | Command / Path | Purpose & Comments |
| :--- | :--- | :--- | :--- | :--- |
| **erlfmt** (Erlang) | `1.8.0` | Homebrew | `/opt/homebrew/bin/erlfmt` | WhatsApp-standard Erlang formatter. Integrated via `conform.nvim`. |
| **stylua** (Lua) | *Auto-detected* | System Global / Mason | `stylua` | Opinionated Lua formatter. |
| **black** (Python) | *Auto-detected* | Python env / Mason | `black` | Uncompromising Python code formatter. |
| **prettier** (JSON/C) | *Auto-detected* | NPM Global / Mason | `prettier` | Standard web formatting engine for JSON files. |
| **gen.nvim** (AI assistant)| `v0.1.0` | Neovim (Lazy) | `:Gen` / `<leader>ai` | Local Neovim AI interface. Integrates with **Ollama**. |
| **qwen2.5-coder:3b** | *Required* | Ollama (Local) | `ollama run qwen2.5-coder:3b` | 3B parameter coding model. Configured inside `gen.nvim`. |

---

### 💡 Portability Tips:
* To restore your **Homebrew** packages on a new machine:
  ```bash
  brew install tmux starship eza bat fzf erlfmt ripgrep nvim
  ```
* To pull the active AI coding model locally inside **Ollama**:
  ```bash
  ollama pull qwen2.5-coder:3b
  ```
* To set up your **Neovim LSPs** on a fresh install, just open Neovim and run:
  ```vim
  :MasonToolsInstall
  ```
  *(Or Mason will download them automatically on startup due to `automatic_installation = true`).*
