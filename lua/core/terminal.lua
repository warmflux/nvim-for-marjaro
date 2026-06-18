--[[
  vim.api.nvim_create_autocmd("TermClose", {
	group = augroup,
	callback = function()
		if vim.v.event.status == 0 then
			vim.api.nvim_buf_delete(0, {})
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

local terminal_state = { buf = nil, win = nil, is_open = false }

local function FloatingTerminal()
	if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
		return
	end

	if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
		terminal_state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[terminal_state.buf].bufhidden = "hide"
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.wo[terminal_state.win].winblend = 0
	vim.wo[terminal_state.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
	vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

	local has_terminal = false
	local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
	for _, line in ipairs(lines) do
		if line ~= "" then
			has_terminal = true
			break
		end
	end
	if not has_terminal then
		vim.fn.termopen("/usr/bin/fish")
	end

	terminal_state.is_open = true
	vim.cmd("startinsert")

	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = terminal_state.buf,
		callback = function()
			if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
				vim.api.nvim_win_close(terminal_state.win, false)
				terminal_state.is_open = false
			end
		end,
		once = true,
	})
end

vim.keymap.set("n", "<C-\\>", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<C-\\>", function()
	if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
	end
end, { noremap = true, silent = true, desc = "Close floating terminal" })
-- ]]

vim.api.nvim_create_autocmd("TermClose", {
	group = augroup,
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.bo.bufhidden = "hide"
		end
	end,
})

local right_terminal = {
	win = nil,
	buf = nil,
}

local function open_right_terminal()
	if right_terminal.win and vim.api.nvim_win_is_valid(right_terminal.win) then
		vim.api.nvim_set_current_win(right_terminal.win)
		return
	end

	if not (right_terminal.buf and vim.api.nvim_buf_is_valid(right_terminal.buf)) then
		right_terminal.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[right_terminal.buf].bufhidden = "hide"
	end

	vim.cmd("vsplit")
	right_terminal.win = vim.api.nvim_get_current_win()

	vim.api.nvim_win_set_buf(right_terminal.win, right_terminal.buf)

	local lines = vim.api.nvim_buf_get_lines(right_terminal.buf, 0, -1, false)
	local is_empty = #lines == 0 or (#lines == 1 and lines[1] == "")
	if is_empty then
		vim.fn.termopen("/usr/bin/fish")
	end

	vim.cmd("startinsert")
end

vim.keymap.set("n", "<C-\\>", open_right_terminal, { noremap = true, silent = true, desc = "Right Terminal" })

vim.keymap.set("t", "<C-\\>", function()
	if right_terminal.win and vim.api.nvim_win_is_valid(right_terminal.win) then
		vim.api.nvim_win_close(right_terminal.win, false)
	end
end, { noremap = true, silent = true, desc = "Close Right Terminal" })

-- vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
-- vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
