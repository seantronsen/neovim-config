-- DAP-VIEW SETUP
------------------------------------------
-- one window left of the editor that switches between sections (winbar), with
-- the program's console under it. opens when a debug session starts and closes
-- when the last one ends (auto_toggle). ascii only: every glyph it draws comes
-- from `icons` below.
require("dap-view").setup({
	winbar = {
		sections = { "scopes", "watches", "breakpoints", "threads", "exceptions", "repl" },
		default_section = "scopes",
		-- section keys (S, W, B, ...) still work, `g?` lists them. hiding the hints
		-- keeps the winbar (and so the pane) narrow
		show_keymap_hints = false,
		-- no control buttons: the ,d keymaps cover them
		controls = { enabled = false },
	},
	-- the button glyphs are set too (pause also marks the stopped thread), so
	-- nothing falls back to nerd fonts
	icons = {
		collapsed = "> ",
		expanded = "v ",
		enabled = "[x]",
		disabled = "[ ]",
		filter = "filter:",
		negate = "!",
		pause = "pause",
		play = "play",
		step_into = "into",
		step_over = "over",
		step_out = "out",
		terminate = "stop",
		run_last = "last",
		step_back = "back",
		disconnect = "disc",
	},
	windows = {
		position = "left",
		-- the winbar (section labels plus padding) needs 57
		size = 64,
		terminal = { position = "below" },
	},
	auto_toggle = true,
})
