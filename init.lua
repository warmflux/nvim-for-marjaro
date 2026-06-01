vim.pack.add({
	"https://github.com/catppuccin/nvim",
	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},

	-- Language Server Protocols
	"https://www.github.com/hrsh7th/nvim-cmp",
	"https://www.github.com/hrsh7th/cmp-nvim-lsp",
	"https://www.github.com/hrsh7th/cmp-buffer",
	"https://www.github.com/hrsh7th/cmp-path",
	"https://www.github.com/hrsh7th/cmp-cmdline",
	"https://github.com/saadparwaiz1/cmp_luasnip",
	"https://www.github.com/rafamadriz/friendly-snippets",

	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/obsidian-nvim/obsidian.nvim",

	"https://github.com/mfussenegger/nvim-jdtls",
	"https://github.com/linux-cultist/venv-selector.nvim",
	"https://github.com/jake-stewart/multicursor.nvim",
})

require("core.keymaps")
require("core.options")
require("core.autocmd")
require("core.terminal")
require("core.neovide")

require("lsp.lspconfig")
require("lsp.jdtls")

require("plugins.nvim-tree")
require("plugins.nvim-treesitter")
require("plugins.fzf")
require("plugins.mini")
require("plugins.gitsigns")
require("plugins.mason")
require("plugins.venv-selector")
require("plugins.multicursor")

require("ui.colorscheme")
require("ui.statuline")
