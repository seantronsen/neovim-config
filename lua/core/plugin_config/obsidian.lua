---@diagnostic disable: missing-fields
local obs = require("obsidian")

obs.setup({
	dir = "~/notes",
	new_notes_location = "current_dir",
	completion = {
		nvim_cmp = true,
		min_chars = 3,
	},
	-- templates = {
	-- 	subdir = "templates",
	-- 	date_format = "%Y-%m-%d",
	-- 	time_format = "%H:%M",
	-- 	-- A map for custom variables, the key should be the variable and the value a function
	-- 	substitutions = {},
	-- },

	open_app_foreground = false,
	preferred_link_style = "wiki",

	mappings = {
		-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
		["gf"] = {
			action = function()
				return require("obsidian").util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
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
		-- return suffix .. "-" .. tostring(os.time())
		-- switch to org by date string for easier chrono sorting. especially for recurring meeting notes.
		return suffix .. "-" .. tostring(os.date("%Y%m%d%H%M%S"))
	end,
	picker = {
		name = "telescope.nvim",
	},

	-- todo: review how to specify default file name
	-- and also how to mandate relative dir to buffer path.
	-- attachments = {
	-- 	-- The default folder to place images in via `:ObsidianPasteImg`.
	-- 	-- If this is a relative path it will be interpreted as relative to the vault root.
	-- 	-- You can always override this per image by passing a full path to the command instead of just a filename.
	-- 	img_folder = "attachments/images",

	-- 	-- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
	-- 	---@return string
	-- 	img_name_func = function()
	-- 		-- Prefix image names with timestamp.
	-- 		return string.format("img-clip%s-", os.time())
	-- 	end,
	-- },

	-- todo: test this out. right now this suppresses the error about conceal levels since I want to be able to see all buffer text. it's not vscode for fuck sake.
	ui = {
		enable = false,
	},
})

vim.keymap.set("n", "<leader>ol", function()
	vim.cmd("ObsidianLinks")
end, { desc = "[o]bsidian [l]inks" })

-- todo: change to ,fo and change original fo to ffo
vim.keymap.set("n", "<leader>of", function()
	vim.cmd("ObsidianSearch")
end, { desc = "[f]ind obsidian [n]ote (search vault)" })

vim.keymap.set("n", "<leader>ob", function()
	vim.cmd("ObsidianBacklinks")
end, { desc = "[o]bsidian [b]acklinks" })

vim.keymap.set("n", "<leader>oo", function()
	vim.cmd("ObsidianOpen")
end, { desc = "[o]bsidian [o]pen" })

vim.keymap.set("n", "<leader>ot", function()
	vim.cmd("ObsidianTags")
end, { desc = "[o]bsidian [t]ags" })

vim.keymap.set("n", "<leader>oc", function()
	vim.cmd("ObsidianTOC")
end, { desc = "[o]bsidian note table of [c]ontents" })

-- todo: create new bindings for

-- - obsidian paste image (replace image paste plugin)
-- vim.keymap.set("n", "<leader>pi", function()
-- 	vim.cmd("ObsidianPasteImg")
-- end, { desc = "[p]aste [i]mage reference" })

-- - obsidian rename (also renames links across the vault)
-- - obsidian template (insert template from templates folder) (need to make templates)
-- - obsidian new from template (need tomake templates)
-- - obsidian toc ( picker for doc table of contents (headings and stuff))
-- - obsidian extract note (visual select text, extract to note, replace with link)

vim.keymap.set("n", "<leader>on", function()
	local result = vim.fn.input("Note name: ")
	if vim.fn.empty(result) == 1 then
		print("warning: base filename is a required argument")
	else
		vim.cmd("ObsidianNew " .. result)
	end
end, { desc = "[o]bsidian create [n]ew note" })
