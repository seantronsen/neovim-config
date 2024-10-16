-- temp file to store some learning stuff for issue 28 on github.

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local attach_mappings = function(prompt_bufnr, map)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		vim.notify("selection: " .. vim.inspect(selection))
		-- vim.api.nvim_put({ selection[1] }, "", false, false)
	end)
	return true
end

-- our picker function: colors
local colors = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "colors",
			finder = finders.new_table({
				results = { { "red", "#ff0000" }, { "green", "#00ff00" }, { "blue", "#0000ff" } },
				entry_maker = function(entry)
					return { value = entry, display = entry[1], ordinal = entry[1] }
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = attach_mappings,
		})
		:find()
end

-- to execute the function
local result = colors(require("telescope.themes").get_dropdown())
vim.notify("result: " .. tostring(result))
