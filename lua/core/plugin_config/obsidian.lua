local obs = require("obsidian")

obs.setup({
	dir = "~/notes",
	completion = {
		nvim_cmp = true,
		min_chars = 3,
		new_notes_location = "notes_subdir",
		prepend_note_id = true,
	},
	-- templates = {
	-- 	subdir = "templates",
	-- 	date_format = "%Y-%m-%d",
	-- 	time_format = "%H:%M",
	-- 	-- A map for custom variables, the key should be the variable and the value a function
	-- 	substitutions = {},
	-- },

	mappings = {
		["<leader>gl"] = function()
			vim.cmd("ObsidianFollowLink")
		end,
	},
	note_id_func = function(title)
		-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
		-- In this case a note with the title 'My new note' will given an ID that looks
		-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
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
		return tostring(os.time()) .. "-" .. suffix
	end,
	finder = "telescope.nvim",
})
