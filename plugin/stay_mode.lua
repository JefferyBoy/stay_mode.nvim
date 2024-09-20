-- 切换buffer后保存恢复上次的状态
-- 当terminal模式时，切换回来默认会进入terminal模式，此插件可以恢复到原来的normal模式
local M = {}
local buffer_stay_mode = {}

M.setup = function()
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function()
			local buf = vim.api.nvim_get_current_buf()
			local mode = buffer_stay_mode[buf]
			local buf_name = vim.api.nvim_buf_get_name(buf)
			local is_term = string.match(buf_name, "^term://")
			if is_term or mode == "nt" then
				vim.api.nvim_command("stopinsert")
			end
			buffer_stay_mode[buf] = nil
		end,
	})
	vim.api.nvim_create_autocmd("BufLeave", {
		pattern = "*",
		callback = function()
			local mode = vim.api.nvim_get_mode().mode
			local buf = vim.api.nvim_get_current_buf()
			buffer_stay_mode[buf] = mode
		end,
	})
end

M.setup()

return M
