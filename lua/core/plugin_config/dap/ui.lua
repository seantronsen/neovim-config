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
		expanded = "v",
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

-- ATTACH DAPUI TO EVENT LISTENERS
------------------------------------------
local function open_dap_ui()
	dapui.open({ reset = true })
end
local function close_dap_ui()
	dapui.close()
end

local dap = require("dap")
dap.listeners.after.event_initialized["dapui_config"] = open_dap_ui
dap.listeners.after.event_breakpoint["dapui_config"] = open_dap_ui

dap.listeners.before.event_terminated["dapui_config"] = close_dap_ui
dap.listeners.before.event_exited["dapui_config"] = close_dap_ui
