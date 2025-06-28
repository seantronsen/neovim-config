local dap = require("dap")
local registry = require("mason-registry")
local mason_path = vim.fn.expand("$MASON")

local is_package_installed = function(package_name)
	return vim.uv.fs_stat(mason_path .. "/packages/" .. package_name) ~= nil
end

local package_install_path = function(package_name)
	return mason_path .. "/packages/" .. package_name
end

local package_bin_path = function(package_name)
	return mason_path .. "/bin/" .. package_name
end

------------------------------------------
-- ADAPTERS (DEBUGGERS)
------------------------------------------
---@diagnostic disable: missing-fields

local target = "codelldb"
if is_package_installed(target) then
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = package_bin_path(target),
			args = { "--port", "${port}" },
		},
	}
else
	local message = "missing dependency: '" .. target .. "' could not be found."
	vim.notify(message, vim.log.levels.WARN)
end

---@diagnostic disable-next-line: redefined-local
local target = "debugpy"
if is_package_installed(target) then
	local dap_python = require("dap-python")
	dap_python.setup(package_install_path(target) .. "/venv/bin/python")
	dap_python.test_runner = "pytest"
else
	local message = "missing dependency: '" .. target .. "' could not be found."
	vim.notify(message, vim.log.levels.WARN)
end

------------------------------------------
-- FILETYPE CONFIGURATION
------------------------------------------

dap.configurations.c = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

dap.configurations.cpp = dap.configurations.c
