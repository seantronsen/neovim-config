local M = {}

function M.is_running_in_headless_mode()
	return #vim.api.nvim_list_uis() == 0
end

return M
