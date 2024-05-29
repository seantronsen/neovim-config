-- enable users to persist an image on the clipboard to the filesystem and
-- simultaneously paste in a reference to that image, formatted appropriately for the markup language type.

-- important: remember to install pngpaste when editting on macOS
-- https://github.com/jcsalterego/pngpaste
local image_clipper = require("img-clip")
image_clipper.setup({
	default = {
		dir_path = "attachments",
		file_name = "img-clip-%Y%m%d%H%M%S",
		-- extension = "jpg",
		relative_to_current_file = true,
		show_dir_path_in_prompt = true,
	},
})

---@diagnostic disable-next-line: undefined-field, need-check-nil
vim.keymap.set("n", "<leader>pi", image_clipper.paste_image, { desc = "[p]aste [i]mage reference" })
