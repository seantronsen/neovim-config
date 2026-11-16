local dap = require("dap")
-- $MASON is only set once mason loads (lazy, see plugins/init.lua)
local mason_path = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")

-- path to a file inside mason, or nil (with a warning) when its package isn't
-- installed
local function mason(package, path)
	if vim.uv.fs_stat(mason_path .. "/packages/" .. package) then return mason_path .. "/" .. path end
	vim.notify("missing dependency: '" .. package .. "' could not be found.", vim.log.levels.WARN)
end

---@diagnostic disable: missing-fields

------------------------------------------
-- C, C++, RUST (codelldb)
------------------------------------------
local codelldb = mason("codelldb", "bin/codelldb")
if codelldb then
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = { command = codelldb, args = { "--port", "${port}" } },
	}
end

-- prompts for the executable, starting from `dir` (relative to the cwd)
local function launch(dir)
	return {
		name = "Launch executable",
		type = "codelldb",
		request = "launch",
		program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/" .. dir, "file") end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	}
end
local attach = {
	name = "Attach to process",
	type = "codelldb",
	request = "attach",
	pid = function() return require("dap.utils").pick_process() end,
}
-- remote: a gdbserver (or `lldb-server gdbserver`) on another host. lldb reads
-- symbols from a local copy of the binary. "launch", not "custom": nvim-dap
-- sends the request name as is, and codelldb rejects "custom"
local gdbserver = {
	name = "Connect to gdbserver",
	type = "codelldb",
	request = "launch",
	targetCreateCommands = function()
		return { "target create " .. vim.fn.input("Local copy of binary: ", vim.fn.getcwd() .. "/", "file") }
	end,
	processCreateCommands = function() return { "gdb-remote " .. vim.fn.input("host:port: ") } end,
}

dap.configurations.c = { launch(""), attach, gdbserver }
dap.configurations.cpp = dap.configurations.c
-- sourceLanguages: load rustc's pretty-printers (Vec, String, HashMap, ...), found
-- through `rustc --print=sysroot`
dap.configurations.rust = {
	vim.tbl_extend("force", launch("target/debug/"), { sourceLanguages = { "rust" } }),
	vim.tbl_extend("force", attach, { sourceLanguages = { "rust" } }),
	vim.tbl_extend("force", gdbserver, { sourceLanguages = { "rust" } }),
}

------------------------------------------
-- GO (delve)
------------------------------------------
local dlv = mason("delve", "bin/dlv")
if dlv then
	dap.adapters.delve = {
		type = "server",
		port = "${port}",
		executable = { command = dlv, args = { "dap", "-l", "127.0.0.1:${port}" } },
	}
end

dap.configurations.go = {
	{ name = "Debug package", type = "delve", request = "launch", program = "${fileDirname}" },
	{ name = "Debug file", type = "delve", request = "launch", program = "${file}" },
	{ name = "Debug package tests", type = "delve", request = "launch", mode = "test", program = "${fileDirname}" },
}

------------------------------------------
-- PYTHON (debugpy, configs from nvim-dap-python)
------------------------------------------
local debugpy = mason("debugpy", "packages/debugpy/venv/bin/python")
if debugpy then
	local dap_python = require("dap-python")
	dap_python.setup(debugpy)
	dap_python.test_runner = "pytest"
end
