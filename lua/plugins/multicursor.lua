local ok, mc = pcall(require, "multicursor-nvim")
if not ok then
	return
end

mc.setup()
local set = vim.keymap.set

-- 在主光标上方/下方添加或跳过光标
-- set({ "n", "v" }, "<c-up>", function()
-- 	mc.lineAddCursor(-1)
-- end, { noremap = true, silent = true })
--
-- set({ "n", "v" }, "<c-down>", function()
-- 	mc.lineAddCursor(1)
-- end, { noremap = true, silent = true })
--
-- set({ "n", "v" }, "<leader><up>", function()
-- 	mc.lineSkipCursor(-1)
-- end, { noremap = true, silent = true })
--
-- set({ "n", "v" }, "<leader><down>", function()
-- 	mc.lineSkipCursor(1)
-- end, { noremap = true, silent = true })

-- 主光标在多光标之间移动
-- set({ "n", "v" }, "<c-left>", mc.nextCursor, { noremap = true, silent = true })
-- set({ "n", "v" }, "<c-right>", mc.prevCursor, { noremap = true, silent = true })

-- 通过匹配单词/选择来添加或跳过新光标
set({ "n", "v" }, "<c-m>", function()
	mc.matchAddCursor(1)
end, { noremap = true, silent = true })

-- set({ "n", "v" }, "<leader>k>", function()
-- 	mc.matchSkipCursor(1)
-- end, { noremap = true, silent = true })
--
set({ "n", "v" }, "<c-s-m>", function()
	mc.matchAddCursor(-1)
end, { noremap = true, silent = true })
--
-- set({ "n", "v" }, "<leader>K", function()
-- 	mc.matchSkipCursor(-1)
-- end, { noremap = true, silent = true })

-- 鼠标 Control + 左键添加/删除光标
set("n", "<c-leftmouse>", mc.handleMouse, { noremap = true, silent = true })

-- 切换光标
set({ "n", "v" }, "<leader>m", mc.toggleCursor, { noremap = true, silent = true })

-- 视觉模式匹配
set("v", "<leader>m", mc.matchCursors, { noremap = true, silent = true })

-- ESC 清空多光标（你最核心的功能）
set("n", "<esc>", function()
	if not mc.cursorsEnabled() then
		mc.enableCursors()
	elseif mc.hasCursors() then
		mc.clearCursors()
	else
		vim.cmd("normal! <esc>")
	end
end, { noremap = true, silent = true })
