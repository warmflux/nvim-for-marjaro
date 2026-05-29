# nvim

Modern Neovim configuration with built-in `vim.pack.add`, Catppuccin Mocha, and full LSP/formatting support.

## Structure

```
init.lua          # Entry point, plugin declarations
lua/
├── core/         # Options, keymaps, autocmds, terminal, neovide
├── lsp/          # lspconfig (LSP + cmp + efm), jdtls
├── plugins/      # nvim-tree, treesitter, fzf-lua, gitsigns, mini.nvim, mason, obsidian, venv-selector
└── ui/           # colorscheme (transparent), statusline
```

## Plugins

- **Colorscheme**: [catppuccin/nvim](https://github.com/catppuccin/nvim)
- **File explorer**: [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
- **Fuzzy finder**: [ibhagwan/fzf-lua](https://github.com/ibhagwan/fzf-lua)
- **Statusline**: Custom (focus-aware, Nerd Font icons)
- **Terminal**: Floating toggle (`<C-\>`)
- **Git**: [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- **Editor suite**: [echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim) (ai, comment, surround, move, pairs, etc.)
- **Syntax**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- **Completion**: [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + LuaSnip + friendly-snippets
- **LSP**: 7 servers (lua_ls, pyright, bashls, ts_ls, gopls, clangd, jdtls) + efm for formatting/linting
- **Formatter/Linter**: [efmls-configs-nvim](https://github.com/creativenull/efmls-configs-nvim) via Mason
- **Notes**: [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) (optional)
- **Python venv**: [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) (optional)

## Keymaps

| Leader    | Action                        |
| --------- | ----------------------------- |
| `<Space>` | Leader key                    |
| `<leader>e` | Toggle file tree            |
| `<leader>ff` | Find files (fzf-lua)       |
| `<leader>fg` | Live grep (fzf-lua)        |
| `<leader>fb` | Buffers (fzf-lua)           |
| `<leader>gd` | Go to definition            |
| `<leader>ca` | Code action                 |
| `<leader>rn` | Rename                      |
| `<leader>hs` | Stage hunk                  |
| `<leader>hr` | Reset hunk                  |
| `<leader>nn` | New Obsidian note           |
| `<C-\>`   | Toggle floating terminal      |

## Format on save

Enabled for: lua, python, go, js/ts/jsx/tsx, json, css/scss, html, sh, c/cpp via efm.

## Requirements

- Neovim >= 0.10 (for `vim.pack.add`)
- Nerd Font (for icons)
- [Mason](https://github.com/mason-org/mason.nvim) for installing LSP/formatter/linter binaries
