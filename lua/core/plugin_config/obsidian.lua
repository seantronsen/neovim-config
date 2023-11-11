---@diagnostic disable: missing-fields
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
		["<leader>gl"] = {
			action = function()
				vim.cmd("ObsidianFollowLink")
			end,
		},
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
		return suffix .. "-" .. tostring(os.time())
	end,
	finder = "telescope.nvim",
})

-- note taking
vim.keymap.set("n", "<leader>ol", function()
	vim.cmd("ObsidianFollowLink")
end, { desc = "[o]bsidian follow [l]ink" })

vim.keymap.set("n", "<leader>fn", function()
	vim.cmd("ObsidianSearch")
end, { desc = "[f]ind obsidian [n]ote (search vault)" })

vim.keymap.set("n", "<leader>ob", function()
	vim.cmd("ObsidianBacklinks")
end, { desc = "[o]bsidian [b]acklinks" })

vim.keymap.set("n", "<leader>on", function()
	local result = vim.fn.input("Note name: ")
	if vim.fn.empty(result) == 1 then
		print("error: name cannot be empty")
	else
		vim.cmd("ObsidianNew " .. result)
	end
end, { desc = "[o]bsidian create [n]ew note" })
