------------------------------------------
-- CONFIGURATION FOR DAP
------------------------------------------
local dap = require("dap")

-- DEFINE DEBUG ADAPTERS FOR DAP
------------------------------------------
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb",
		args = { "--port", "${port}" },
	},
}

dap.adapters.bashdb = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
	name = "bashdb",
}

-- DEFINE DEBUG CONFIGURATIONS FOR DAP
------------------------------------------
dap.configurations.sh = {
	{
		type = "bashdb",
		request = "launch",
		name = "Launch file",
		showDebugOutput = true,
		pathBashdb = vim.fn.stdpath("data")
			.. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
		pathBashdbLib = vim.fn.stdpath("data")
			.. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
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
dap.configurations.rust = {
	{
		name = "Launch default target (project binary: no args)",
		type = "rt_lldb",
		request = "launch",
		program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
		cwd = "${workspaceFolder}",
		stopOnEntry = false,

		-- ... the previous config goes here ...,
		initCommands = function()
			-- Find out where to look for the pretty printer Python module
			local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

			local script_import = 'command script import "'
				.. rustc_sysroot
				.. '/lib/rustlib/etc/lldb_lookup.py"'
			local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

			local commands = {}
			local file = io.open(commands_file, "r")
			if file then
				for line in file:lines() do
					table.insert(commands, line)
				end
				file:close()
			end
			table.insert(commands, 1, script_import)

			return commands
		end,
	},
}

local path_debugpy = vim.fn.expand("$HOME/.virtualenvs/debugenv/bin/python")
local dap_python = require("dap-python")
dap_python.setup(path_debugpy)
dap_python.test_runner = "pytest"

-- SUPPORT LAUNCH.JSON FILES
------------------------------------------
local launch = require("dap.ext.vscode")
local launch_path = vim.loop.cwd() .. "/launch.json"
local launch_filetype_maps = {
	codelldb = { "c", "cpp" },
	rt_lldb = { "rust" },
	python = { "python" },
	pdb = { "python" },
	debugpy = { "python" },
}
launch.load_launchjs(launch_path, launch_filetype_maps)

-- DAPUI SETUP
------------------------------------------
local dapui = require("dapui")
local dapui_config = {
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.6 },
				{ id = "breakpoints", size = 0.2 },
				{ id = "stacks", size = 0.2 },
			},
			position = "left",
			size = 80,
		},
		{
			elements = {
				{ id = "repl", size = 0.5 },
				{ id = "console", size = 0.5 },
			},
			position = "bottom",
			size = 20,
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

local function close_dap_ui()
	dapui.close()
end

dap.listeners.after.event_initialized["dapui_config"] = open_dap_ui
dap.listeners.after.event_breakpoint["dapui_config"] = open_dap_ui
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
local virtual_text = require("nvim-dap-virtual-text")
virtual_text.setup({})
