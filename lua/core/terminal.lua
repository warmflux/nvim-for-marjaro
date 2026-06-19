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

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		-- 1. 设置超大回滚行数，保存所有输出
		vim.bo[buf].scrollback = 100000
		-- 隐藏行号、侧边栏
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		-- 终端输入模式：映射 <Esc> 切终端normal
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = buf, noremap = true, silent = true })
	end,
})

-- 关键：切到终端normal模式时，解除滚动锁定，允许自由翻历史
vim.api.nvim_create_autocmd("ModeChanged", {
	group = augroup,
	pattern = "t:n", -- 从终端输入t → 终端普通n模式
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		if vim.bo[buf].buftype == "terminal" then
			-- 允许光标自由上下移动全部历史输出
			vim.cmd.setlocal("scrolloff=0")
			-- 启用普通文件滚动快捷键（gg/G/Ctrl-d/Ctrl-u）
			vim.opt_local.modifiable = true
		end
	end,
})

-- 切回终端输入模式，恢复终端输入锁定
vim.api.nvim_create_autocmd("ModeChanged", {
	group = augroup,
	pattern = "n:t",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		if vim.bo[buf].buftype == "terminal" then
			vim.opt_local.modifiable = false
		end
	end,
})

vim.api.nvim_create_autocmd("TermClose", {
	group = augroup,
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.bo.bufhidden = "hide"
		end
	end,
})

-- 右侧终端逻辑
local right_term = {
	buf = nil,
	win = nil,
}

local function toggle_right_term()
	if right_term.win and vim.api.nvim_win_is_valid(right_term.win) then
		vim.api.nvim_set_current_win(right_term.win)
		vim.cmd("startinsert")
		return
	end

	if not (right_term.buf and vim.api.nvim_buf_is_valid(right_term.buf)) then
		right_term.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[right_term.buf].buftype = "terminal"
		vim.bo[right_term.buf].bufhidden = "hide"
		vim.bo[right_term.buf].scrollback = 100000
	end

	vim.cmd("vsplit")
	vim.cmd("vertical resize 45")
	right_term.win = vim.api.nvim_get_current_win()

	if vim.api.nvim_win_is_valid(right_term.win) and vim.api.nvim_buf_is_valid(right_term.buf) then
		vim.api.nvim_win_set_buf(right_term.win, right_term.buf)
	end

	local lines = vim.api.nvim_buf_get_lines(right_term.buf, 0, -1, false)
	local buf_empty = #lines == 0 or (#lines == 1 and lines[1][1] == "")
	if buf_empty then
		vim.fn.termopen("/usr/bin/fish")
	end

	vim.cmd("startinsert")
end

local function close_right_term()
	if right_term.win and vim.api.nvim_win_is_valid(right_term.win) then
		vim.api.nvim_win_close(right_term.win, true)
		right_term.win = nil
	end
end
vim.keymap.set("n", "<C-\\>", toggle_right_term, { noremap = true, silent = true, desc = "Right Terminal" })

vim.keymap.set("t", "<C-\\>", close_right_term, { noremap = true, silent = true, desc = "Close Right Terminal" })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "kj", "<C-\\><C-n>", { noremap = true, silent = true })
-- vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
-- vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
