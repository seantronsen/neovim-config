---@diagnostic disable: missing-fields

local path_notes = vim.env.HOME .. "/notes"
if not vim.uv.fs_stat(path_notes) then
	local mode = tonumber("0755", 8) -- convert permissions to octal
	vim.uv.fs_mkdir(path_notes, mode)
	vim.notify("configured notes directory did not exist, so it was created", vim.log.levels.INFO)
end

-- v3.16 adds buffer keymaps for <CR>, <C-a>, <C-x>, [o, and ]o in notes.
vim.g.obsidian_default_keymap = false

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
	-- the default note template no longer inserts a `# title` heading
	note = {
		template = vim.fn.stdpath("config") .. "/templates/obsidian-note.md",
	},
})

-- `gf` follows [[links]] natively (via 'includeexpr') since v3.16. mapped only so
-- it shows up in the keymaps picker.
vim.keymap.set("n", "gf", "gf", { desc = "[g]o to [f]ile (follows note links)" })
vim.keymap.set("n", "<leader>ol", function() vim.cmd("Obsidian links") end, { desc = "[o]bsidian [l]inks" })
vim.keymap.set("n", "<leader>fo", function() vim.cmd("Obsidian search") end, { desc = "[f]ind note (search [o]bsidian)" })
vim.keymap.set("n", "<leader>ob", function() vim.cmd("Obsidian backlinks") end, { desc = "[o]bsidian [b]acklinks" })
vim.keymap.set("n", "<leader>oo", function() vim.cmd("Obsidian open") end, { desc = "[o]bsidian [o]pen" })
vim.keymap.set("n", "<leader>ot", function() vim.cmd("Obsidian tags") end, { desc = "[o]bsidian [t]ags" })
vim.keymap.set("n", "<leader>oc", function() vim.cmd("Obsidian toc") end, { desc = "[o]bsidian note table of [c]ontents" })

-- todo: create new bindings for

-- - obsidian paste image (replace image paste plugin)
-- vim.keymap.set("n", "<leader>pi", function()
-- 	vim.cmd("Obsidian paste_img")
-- end, { desc = "[p]aste [i]mage reference" })

-- - obsidian rename (also renames links across the vault)
-- - obsidian template (insert template from templates folder) (need to make templates)
-- - obsidian new from template (need tomake templates)
-- - obsidian toc ( picker for doc table of contents (headings and stuff))
-- - obsidian extract note (visual select text, extract to note, replace with link)

vim.keymap.set("n", "<leader>on", function()
	-- todo: the conditional clause below is a spot fix for https://github.com/epwalsh/obsidian.nvim/issues/546
	-- periodically review that issue until a patch is released, fixing the problem.
	if vim.bo.filetype == "oil" then
		local message = "illegal action: cannot create notes while inside an oil.nvim buffer"
		vim.notify(message, vim.log.levels.WARN)
		return
	end

	-- process user input for the name of the new note.
	-- todo: need to add a check for my occasional dumbass moment where I enter only whitespace
	local result = vim.fn.input("note name: ")
	if vim.fn.empty(result) == 1 then
		local message = "illegal action: base filename is a required argument"
		vim.notify(message, vim.log.levels.WARN)
		return
	end

	-- leverage existing obsidian nvim command to create the notefile
	vim.cmd("Obsidian new " .. result)
end, { desc = "[o]bsidian create [n]ew note" })
