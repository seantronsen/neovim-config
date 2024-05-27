-- enable users to persist an image on the clipboard to the filesystem and
-- simultaneously paste in a reference to that image, formatted appropriately for the markup language type.

local image_clipper = require("img-clip")
image_clipper.setup({
	default = {
		dir_path = "attachments",
		file_name = "%Y%m%d%H%M%S",
		relative_to_current_file = true,
		show_dir_path_in_prompt = true,
	},
})

---@diagnostic disable-next-line: undefined-field, need-check-nil
vim.keymap.set("n", "<leader>pi", image_clipper.paste_image, { desc = "[p]aste [i]mage reference" })
