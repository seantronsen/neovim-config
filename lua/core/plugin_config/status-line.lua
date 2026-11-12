-- most readable name for a revision: tag > branch > short commit sha
local function ref_label(repo, rev)
	if rev == ":0" then
		return "staged"
	end
	local function git(...)
		local result = vim.system({ "git", "-C", repo, ... }, { text = true }):wait()
		return result.code == 0 and vim.trim(result.stdout) or ""
	end
	local tag = git("describe", "--tags", "--exact-match", rev)
	if tag ~= "" then
		return tag
	end
	local branches =
		vim.split(git("branch", "-a", "--points-at", rev, "--format=%(refname:short)"), "\n", { trimempty = true })
	if #branches > 0 then
		return vim.tbl_contains(branches, rev) and rev or branches[1]
	end
	local sha = git("rev-parse", "--short", rev)
	return sha ~= "" and sha or rev
end

-- gitsigns revision buffers (diff splits) show as `<ref>:<path>` instead of
-- their full gitsigns:// name
local function revision_name()
	local buf = vim.api.nvim_get_current_buf()
	local repo, rev, path = vim.api.nvim_buf_get_name(buf):match("^gitsigns://(.-)/%.git//(:?[^:]*):(.+)$")
	if not repo then
		return nil
	end
	if vim.b[buf].git_ref_label == nil then
		vim.b[buf].git_ref_label = ref_label(repo, rev)
	end
	return vim.b[buf].git_ref_label .. ":" .. path
end

local filename = {
	"filename",
	path = 1,
	fmt = function(name)
		return revision_name() or name
	end,
}

-- diff counts from gitsigns, so they always match the signs in the gutter
local function gitsigns_diff()
	local status = vim.b.gitsigns_status_dict
	if status then
		return { added = status.added, modified = status.changed, removed = status.removed }
	end
end

require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "auto",
		component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
	},
	sections = {
		lualine_b = { "branch", { "diff", source = gitsigns_diff }, "diagnostics" },
		lualine_c = { filename },
		-- lsp progress (replaces fidget.nvim). ascii only, like the rest
		lualine_x = {
			{ "lsp_status", symbols = { spinner = { "-", "\\", "|", "/" }, done = "", separator = " " } },
			"encoding",
			"fileformat",
			"filetype",
		},
	},
	inactive_sections = {
		lualine_c = { filename },
	},
})
