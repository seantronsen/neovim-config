-- local iron = require("iron.core")
-- local view = require("iron.view")
-- 
-- iron.setup({
-- 	config = {
-- 		-- Whether a repl should be discarded or not
-- 
-- 		scratch_repl = true,
-- 		-- Your repl definitions come here
-- 		repl_definition = {
-- 			sh = {
-- 				-- Can be a table or a function that
-- 				-- returns a table (see below)
-- 				command = { "bash" },
-- 			},
-- 		},
-- 		-- How the repl window will be displayed
-- 		-- See below for more information
-- 		repl_open_cmd = view.bottom(20),
-- 	},
-- 
-- 	-- Iron doesn't set keymaps by default anymore.
-- 	-- You can set them here or manually add keymaps to the functions in iron.core
-- 	keymaps = {
-- 		send_motion = "<leader>rt", -- rt => repl transfer
-- 		visual_send = "<leader>rt", -- rt => repl transfer
-- 		send_file = "<leader>rf", -- rf => repl transfer file
-- 		send_line = "<leader>rl", -- rl => repl transfer line
-- 		-- send_mark = "<leader>sm",
-- 		-- mark_motion = "<leader>mc",
-- 		-- mark_visual = "<leader>mc",
-- 		-- remove_mark = "<leader>md",
-- 		cr = "<leader>re", -- re => repl enter
-- 		interrupt = "<leader>ri", -- ri => repl interrupt
-- 		exit = "<leader>rq", -- rq => repl quit
-- 		clear = "<leader>rc", -- rc => repl clear
-- 	},
-- 	-- If the highlight is on, you can change how it looks
-- 	-- For the available options, check nvim_set_hl
-- 
-- 	highlight = {
-- 		italic = true,
-- 	},
-- 	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
-- })
-- 
-- -- iron also has a list of commands, see :h iron-commands for all available commands
-- vim.keymap.set("n", "<leader>rs", "<cmd>IronRepl<cr>")
-- vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>")
-- vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>")
-- vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>")
