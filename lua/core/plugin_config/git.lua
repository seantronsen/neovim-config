-----------------------------
-- CONFIGURATION FOR GIT (gitsigns.nvim, see plugins.lua)
-----------------------------
-- toggle a delta-like inline view of the buffer's changes: deleted lines shown
-- in place, added lines and changed words highlighted. compares against the
-- index by default, or any revision, e.g. `:GitInline main` or `:GitInline ~3`.
vim.api.nvim_create_user_command("GitInline", function(opts)
	require("gitsigns").diffthis(opts.args ~= "" and opts.args or nil, { unified = true })
end, { nargs = "?", desc = "toggle inline diff view against the index or a revision" })

-- diff two revisions of a file side by side: `:GitDiffRefs <left> <right> [path]`
-- left is the older side, right the newer. path defaults to the current file.
-- takes over the current pane. GitDiffClose puts its original buffer back.
vim.api.nvim_create_user_command("GitDiffRefs", function(opts)
	local left, right, path = opts.fargs[1], opts.fargs[2], opts.fargs[3] or "%"
	local gitsigns = require("gitsigns")
	vim.w.git_diff_refs_buf = vim.api.nvim_get_current_buf()
	gitsigns.show(right .. ":" .. path, {}, function()
		gitsigns.diffthis(left)
	end)
end, {
	nargs = "+",
	desc = "diff two revisions of a file: <left> <right> [path]",
	complete = function(lead, line)
		if #vim.split(line, "%s+", { trimempty = true }) - (lead == "" and 0 or 1) >= 3 then
			return vim.fn.getcompletion(lead, "file")
		end
		local refs = vim.fn.systemlist({
			"git",
			"for-each-ref",
			"--format=%(refname:short)",
			"refs/heads",
			"refs/tags",
			"refs/remotes",
		})
		table.insert(refs, 1, "HEAD")
		return vim.tbl_filter(function(ref)
			return vim.startswith(ref, lead)
		end, refs)
	end,
})

-- toggle character level highlights inside changed lines of diff splits
vim.api.nvim_create_user_command("GitDiffChars", function()
	if vim.tbl_contains(vim.opt.diffopt:get(), "inline:char") then
		vim.opt.diffopt:remove("inline:char")
		vim.opt.diffopt:append("inline:none")
	else
		vim.opt.diffopt:remove("inline:none")
		vim.opt.diffopt:append("inline:char")
	end
end, { desc = "toggle character level highlights in diff splits" })

-- jump between changes: vim's native jump in diff splits, gitsigns hunks
-- everywhere else (including the inline view)
for key, direction in pairs({ ["]c"] = "next", ["[c"] = "prev" }) do
	vim.keymap.set("n", key, function()
		if vim.wo.diff then
			vim.cmd.normal({ key, bang = true })
		else
			require("gitsigns").nav_hunk(direction)
		end
	end, { desc = "go to " .. direction .. " [c]hange" })
end

-- close a gitsigns diff view, keeping the real file no matter which side is
-- focused: closes the revision (gitsigns://) windows, and for GitDiffRefs puts
-- the pane's original buffer back. otherwise closes the focused revision.
vim.api.nvim_create_user_command("GitDiffClose", function()
	local diffs = vim.tbl_filter(function(win)
		return vim.wo[win].diff
	end, vim.api.nvim_tabpage_list_wins(0))
	if #diffs == 0 then
		return
	end
	local revisions, keep = {}, nil
	for _, win in ipairs(diffs) do
		local original = vim.w[win].git_diff_refs_buf
		if original and vim.api.nvim_buf_is_valid(original) then
			vim.api.nvim_win_set_buf(win, original)
			vim.w[win].git_diff_refs_buf = nil
			keep = win
		elseif vim.startswith(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)), "gitsigns://") then
			table.insert(revisions, win)
		else
			keep = keep or win
		end
	end
	for _, win in ipairs(keep and revisions or { vim.api.nvim_get_current_win() }) do
		vim.api.nvim_win_close(win, false)
	end
	vim.cmd("diffoff!")
	if keep and vim.api.nvim_win_is_valid(keep) then
		vim.api.nvim_set_current_win(keep)
	end
end, { desc = "close the git diff view, keeping the working file" })

-- toggle the blame panel: closes an open one (from either window), otherwise
-- opens it for the current file
vim.api.nvim_create_user_command("GitBlame", function()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "gitsigns-blame" then
			return vim.api.nvim_win_close(win, true)
		end
	end
	require("gitsigns").blame()
end, { desc = "toggle the git blame panel" })

-- git-style colors for side-by-side diffs. vim colors text that only exists on
-- one side green on both sides, so in the window gitsigns opens for the
-- revision being compared against, those lines were removed: show them red
-- instead. dim the ------ filler lines on both sides.
local old_side = "DiffAdd:DiffDelete,DiffTextAdd:DiffTextDelete,DiffDelete:NonText"
local new_side = "DiffDelete:NonText"
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "gitsigns://*",
	callback = function(args)
		vim.schedule(function()
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				if vim.wo[win].diff then
					vim.wo[win].winhighlight = vim.api.nvim_win_get_buf(win) == args.buf and old_side or new_side
				end
			end
		end)
	end,
})

-- KEYMAPS
--------------------------------
vim.keymap.set("n", "<leader>vd", "<Cmd>Gitsigns diffthis<CR>", { desc = "[v]cs [d]iff split (vs staged)" })
vim.keymap.set("n", "<leader>vi", "<Cmd>GitInline<CR>", { desc = "[v]cs [i]nline diff (vs staged)" })
vim.keymap.set("n", "<leader>vI", ":GitInline ", { desc = "[v]cs [I]nline diff vs ref" })
vim.keymap.set("n", "<leader>vr", ":GitDiffRefs ", { desc = "[v]cs diff [r]efs" })
vim.keymap.set("n", "<leader>vc", "<Cmd>GitDiffChars<CR>", { desc = "[v]cs toggle [c]har highlights" })
vim.keymap.set("n", "<leader>vx", "<Cmd>GitDiffClose<CR>", { desc = "[v]cs close diff" })
vim.keymap.set("n", "<leader>vb", "<Cmd>GitBlame<CR>", { desc = "[v]cs toggle [b]lame" })
