---@diagnostic disable: missing-fields

------------------------------------------
-- CONFIGURATION FOR DAP
------------------------------------------
local registry = require("mason-registry")
local dap = require("dap")
-- dap.set_exception_breakpoints({ "raised", "uncaught" })
-- dap.defaults.fallback.exception_breakpoints = { "raised", "uncaught" }

------------------------------------------
-- CONFIGURATION FOR DAP ADAPTERS (DEBUGGERS)
------------------------------------------

local target = "codelldb"
if registry.has_package(target) then
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.exepath(target),
			args = { "--port", "${port}" },
		},
	}
else
	local message = "missing dependency: '" .. target .. "' could not be found."
	vim.notify(message, vim.log.levels.WARN)
end

---@diagnostic disable-next-line: redefined-local
local target = "bash-debug-adapter"
if registry.has_package(target) then
	local target_path = vim.fn.exepath(target)
	dap.adapters.bashdb = {
		type = "executable",
		command = target_path,
		name = "bashdb",
	}
else
	local message = "missing dependency: '" .. target .. "' could not be found."
	vim.notify(message, vim.log.levels.WARN)
end

-- DEBUGGING CONFIGURATION SPECIFIC TO FILETYPE
------------------------------------------
---@diagnostic disable-next-line: redefined-local
local target = "bash-debug-adapter"
if registry.has_package(target) then
	local path_executable = vim.fn.exepath(target)
	local package = registry.get_package(target)
	local path_library = package:get_install_path()
	dap.configurations.sh = {
		{
			type = "bashdb",
			request = "launch",
			name = "Launch file",
			showDebugOutput = true,
			pathBashdb = path_executable,
			pathBashdbLib = path_library,
			trace = true,
			file = "${file}",
			program = "${file}",
			cwd = "${workspaceFolder}",
			pathCat = "cat",
			pathBash = "/bin/bash",
			pathMkfifo = "mkfifo",
			pathPkill = "pkill",
			args = {},
			env = {},
			terminalKind = "integrated",
		},
	}
else
	local message = "missing debug adapter: '" .. target .. "' could not be found."
	vim.notify(message, vim.log.levels.WARN)
end

dap.configurations.c = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			-- todo: fix function call to use proper signature
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

dap.configurations.cpp = dap.configurations.c

-- the dap configuration for rust is defined within the lsp configuration
-- for better alignment with the features of `rust-tools.nvim`
dap.configurations.rust = {}

---@diagnostic disable-next-line: redefined-local
local target = "debugpy"
if registry.has_package(target) then
	local package = registry.get_package(target)
	local path_install = package:get_install_path()
	local path_python = path_install .. "/venv/bin/python"
	local dap_python = require("dap-python")
	dap_python.setup(path_python)
	dap_python.test_runner = "pytest"
else
	local message = "missing debug adapter: '" .. target .. "' could not be found."
	vim.notify(message, vim.log.levels.WARN)
end

-- SUPPORT LAUNCH.JSON FILES
------------------------------------------
local launch_path = vim.loop.cwd() .. "/.launch.json" -- hidden on *nix
local launch_filetype_maps = {
	codelldb = { "c", "cpp" },
	rt_lldb = { "rust" },
	debugpy = { "python" },
	-- todo: this seems incorrect. there isn't an adapter named `python`
	python = { "python" },
}
require("dap.ext.vscode").load_launchjs(launch_path, launch_filetype_maps)

-- DAPUI SETUP
------------------------------------------
local dapui = require("dapui")
local dapui_config = {
	controls = {
		element = "repl",
		enabled = true,
		icons = {
			disconnect = "disconnect",
			pause = "pause",
			play = "play",
			run_last = "run-last",
			step_back = "step-back",
			step_into = "step-into",
			step_out = "step-out",
			step_over = "step-over",
			terminate = "terminate",
		},
	},
	icons = {
      collapsed = ">",
      current_frame = "*",
      expanded = "v"

	},
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.5 },
				{ id = "watches", size = 0.2 },
				{ id = "breakpoints", size = 0.15 },
				{ id = "stacks", size = 0.15 },
			},
			position = "left",
			size = 90,
		},
		{
			elements = {
				{ id = "console", size = 1 },
			},
			position = "bottom",
			size = 15,
		},
		{
			elements = {
				{ id = "repl", size = 1 },
			},
			position = "bottom",
			size = 15,
		},
	},
}
dapui.setup(dapui_config)

-- ATTACH DAPUI TO THE EVENT LISTENERS
------------------------------------------
local dapui_open_args = { reset = true }
local function open_dap_ui()
	dapui.open(dapui_open_args)
end

dap.listeners.after.event_initialized["dapui_config"] = open_dap_ui
dap.listeners.after.event_breakpoint["dapui_config"] = open_dap_ui

-- re-enabling
-- -- note: disabling this due to previous annoyances. for instance, if debugging
-- -- qt and it crashes (which occurs more frequently than I care for), this exits
-- -- the UI like it's supposed to and I have to re-open it to try and determine
-- -- what happened.
--
local function close_dap_ui()
	dapui.close()
end
dap.listeners.before.event_terminated["dapui_config"] = close_dap_ui
dap.listeners.before.event_exited["dapui_config"] = close_dap_ui

-- KEYBINDINGS DAP
------------------------------------------
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[d]ap toggle [b]reakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[d]ap [c]ontinue (or start)" })
vim.keymap.set("n", "<leader>ds", dap.terminate, { desc = "[d]ap [s]top (terminate)" })
vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "[d]ap step [n]ext (step over)" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "[d]ap step [o]ut" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[d]ap step [i]nto" })
vim.keymap.set("n", "<leader>dt", dap.run_to_cursor, { desc = "[d]ap run [t]o cursor" })
vim.keymap.set("n", "<leader>dd", dap.down, { desc = "[d]ap travel [d]own the stack" })
vim.keymap.set("n", "<leader>du", dap.up, { desc = "[d]ap travel [u]p the stack" })

-- KEYBINDINGS DAPUI
------------------------------------------
vim.keymap.set("n", "<leader>dx", dapui.toggle, { desc = "[d]ap toggle UI" })
vim.keymap.set("n", "<leader>dr", open_dap_ui, { desc = "[d]ap [r]eset ui" })

-- SETUP VIRTUAL TEXT
------------------------------------------
require("nvim-dap-virtual-text").setup({})
