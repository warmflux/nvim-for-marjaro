local function setup_obsidian()
	if vim.fn.isdirectory(vim.fn.expand("~/Notes/")) == 0 then
		return
	end
	require("obsidian").setup({
		legacy_commands = false,
		workspaces = { { name = "Notes", path = vim.fn.expand("~/code/Notes/") } },
		picker = { name = "fzf-lua" },
	})

	vim.keymap.set("n", "<leader>nn", function()
		vim.cmd("Obsidian workspace")
		vim.defer_fn(function()
			vim.cmd("Obsidian new")
		end, 500)
	end, { desc = "New note" })
	vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
	vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
	vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<cr>", { desc = "Today's daily note" })
	vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<cr>", { desc = "Switch workspace" })
end

setup_obsidian()
