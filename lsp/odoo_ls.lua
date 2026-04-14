local odoo_root = vim.fs.normalize(vim.fn.expand("~/Desktop/Cuballama/Odoo/Odoocker"))
local community_path = odoo_root .. "/odoo-enterprise"
local addons_paths = {
	odoo_root .. "/extra-addons",
	odoo_root .. "/odoo-enterprise/odoo/addons",
}
local stdlib_path = vim.fs.normalize(vim.fn.expand("$HOME/.local/share/nvim/odoo/typeshed/stdlib"))
local stubs_path = vim.fs.normalize(vim.fn.expand("$HOME/.local/share/nvim/odoo/typeshed/stubs"))
local python_path = vim.fn.exepath("python3")

if python_path == "" then
	python_path = "python3"
end

local function resolve_path(path_or_bufnr)
	if type(path_or_bufnr) == "number" then
		local name = vim.api.nvim_buf_get_name(path_or_bufnr)
		if name == "" then
			return nil
		end
		return name
	end

	if type(path_or_bufnr) == "string" and path_or_bufnr ~= "" then
		return path_or_bufnr
	end
end

local function in_odoo_workspace(path_or_bufnr)
	local path = resolve_path(path_or_bufnr)
	if not path then
		return false
	end

	local normalized = vim.fs.normalize(path)
	return normalized == odoo_root or normalized:sub(1, #odoo_root + 1) == odoo_root .. "/"
end

return {
	cmd = {
		vim.fn.expand("$HOME/.local/share/nvim/odoo/odoo_ls_server"),
		"--community-path",
		community_path,
		"--addons",
		addons_paths[1],
		"--addons",
		addons_paths[2],
		"--tracked-folders",
		odoo_root,
		"--stdlib",
		stdlib_path,
		"--stubs",
		stubs_path,
	},
	filetypes = { "python", "xml" },
	root_dir = function(path_or_bufnr, on_dir)
		if in_odoo_workspace(path_or_bufnr) then
			on_dir(odoo_root)
		end
	end,
	settings = {
		Odoo = {
			selectedConfiguration = "odoo-nyto",
		},
	},
	workspace_folders = {
		{
			uri = vim.uri_from_fname(odoo_root),
			name = "odoo_root",
		},
	},
}
