local function source_compile()
	local packer = require("packer")
	local current_file = vim.api.nvim_buf_get_name(0)
	vim.cmd("write")
	vim.cmd("source " .. current_file)
	packer.compile(nil, nil)
end
vim.api.nvim_create_user_command("PackerCS", source_compile, {})
