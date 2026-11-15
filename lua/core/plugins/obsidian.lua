---@diagnostic disable: missing-fields

-- lazy loaded on markdown files or the first `:Obsidian` command (config). the
-- keymaps (init) only call `:Obsidian ...`, which loads it. see plugins/init.lua
local M = {}

function M.init()
	-- v3.16 adds buffer keymaps for <CR>, <C-a>, <C-x>, [o, and ]o in notes.
	vim.g.obsidian_default_keymap = false

	-- `gf` follows [[links]] natively (via 'includeexpr') since v3.16. mapped only so
	-- it shows up in the keymaps picker.
	vim.keymap.set("n", "gf", "gf", { desc = "[g]o to [f]ile (follows note links)" })
	vim.keymap.set("n", "<leader>ol", function() vim.cmd("Obsidian links") end, { desc = "[o]bsidian [l]inks" })
	vim.keymap.set(
		"n",
		"<leader>fo",
		function() vim.cmd("Obsidian search") end,
		{ desc = "[f]ind note (search [o]bsidian)" }
	)
	vim.keymap.set("n", "<leader>ob", function() vim.cmd("Obsidian backlinks") end, { desc = "[o]bsidian [b]acklinks" })
	vim.keymap.set("n", "<leader>oo", function() vim.cmd("Obsidian open") end, { desc = "[o]bsidian [o]pen" })
	vim.keymap.set("n", "<leader>ot", function() vim.cmd("Obsidian tags") end, { desc = "[o]bsidian [t]ags" })
	vim.keymap.set(
		"n",
		"<leader>oc",
		function() vim.cmd("Obsidian toc") end,
		{ desc = "[o]bsidian note table of [c]ontents" }
	)

	-- todo: create new bindings for
	-- - obsidian rename (also renames links across the vault)
	-- - obsidian toc (picker for doc table of contents (headings and stuff))
	-- - obsidian extract note (visual select text, extract to note, replace with link)
	vim.keymap.set("n", "<leader>on", function()
		if vim.bo.filetype == "oil" then
			local message = "illegal action: cannot create notes while inside an oil.nvim buffer"
			vim.notify(message, vim.log.levels.WARN)
			return
		end

		-- process user input for the name of the new note.
		local result = vim.trim(vim.fn.input("note name: "))
		if vim.fn.empty(result) == 1 then
			local message = "illegal action: base filename is a required argument"
			vim.notify(message, vim.log.levels.WARN)
			return
		end

		-- leverage existing obsidian nvim command to create the notefile
		vim.cmd("Obsidian new " .. result)
	end, { desc = "[o]bsidian create [n]ew note" })
end

function M.config()
	local path_notes = vim.env.HOME .. "/notes"
	if not vim.uv.fs_stat(path_notes) then
		local mode = tonumber("0755", 8) -- convert permissions to octal
		vim.uv.fs_mkdir(path_notes, mode)
		vim.notify("configured notes directory did not exist, so it was created", vim.log.levels.INFO)
	end

	local obs = require("obsidian")
	obs.setup({
		-- `ObsidianXxx` commands are deprecated as of v3.16 in favor of `Obsidian xxx`.
		-- leaving them enabled triggers a deprecation warning on every startup.
		legacy_commands = false,
		dir = path_notes,
		new_notes_location = "current_dir",
		-- completion is now provided by the plugin's built-in lsp server (obsidian-ls),
		-- which feeds the builtin completion popup like any other server.
		completion = {
			min_chars = 3,
		},

		link = {
			style = "wiki",
		},
		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return suffix .. "-" .. tostring(os.date("%Y%m%d%H%M%S"))
		end,
		picker = {
			name = "telescope.nvim",
		},

		ui = {
			enable = false,
		},
		-- the default note template no longer inserts a `# title` heading
		note = {
			template = vim.fn.stdpath("config") .. "/templates/obsidian-note.md",
		},
	})
end

return M
