-- enable users to persist an image on the clipboard to the filesystem and
-- simultaneously paste in a reference to that image, formatted appropriately for the markup language type.

-- important: remember to install pngpaste when editting on macOS
-- https://github.com/jcsalterego/pngpaste

-- lazy loaded: keymap at startup (init), img-clip loads on first paste
-- (config). see plugins.lua
local M = {}

function M.init()
	vim.keymap.set("n", "<leader>pi", function()
		require("img-clip").paste_image()
	end, { desc = "[p]aste [i]mage reference" })
end

function M.config()
	require("img-clip").setup({
		default = {
			dir_path = "attachments",
			file_name = "img-clip-%Y%m%d%H%M%S",
			extension = "jpg",
			relative_to_current_file = true,
			show_dir_path_in_prompt = true,

			insert_mode_after_paste = false,
			prompt_for_file_name = false,
		},
	})
end

return M
