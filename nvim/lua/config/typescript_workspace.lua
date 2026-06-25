local M = {}

local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
if vim.fn.has('nvim-0.11.3') == 1 then
	root_markers = { root_markers, { '.git' } }
else
	root_markers = vim.list_extend(root_markers, { '.git' })
end

local vueScopeCache = {}

local function readJson(path)
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return nil
	end

	local content = table.concat(lines, '\n')
	if content == '' then
		return nil
	end

	local decodedOk, decoded = pcall(vim.json.decode, content)
	if not decodedOk then
		return nil
	end

	return decoded
end

local function hasVueDependency(packageJson)
	if type(packageJson) ~= 'table' then
		return false
	end

	for _, field in ipairs({ 'dependencies', 'devDependencies', 'peerDependencies', 'optionalDependencies' }) do
		local deps = packageJson[field]
		if type(deps) == 'table' then
			if deps.vue ~= nil or deps.nuxt ~= nil then
				return true
			end
		end
	end

	return false
end

function M.projectRoot(bufnr)
	local denoRoot = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
	local denoLockRoot = vim.fs.root(bufnr, { 'deno.lock' })
	local projectRoot = vim.fs.root(bufnr, root_markers)

	if denoLockRoot and (not projectRoot or #denoLockRoot > #projectRoot) then
		return nil
	end

	if denoRoot and (not projectRoot or #denoRoot >= #projectRoot) then
		return nil
	end

	return projectRoot or vim.fn.getcwd()
end

function M.scopeRoot(bufnr)
	local projectRoot = M.projectRoot(bufnr)
	if not projectRoot then
		return nil
	end

	return vim.fs.root(bufnr, { 'package.json' }) or projectRoot
end

function M.isVueWorkspace(bufnr)
	local scope = M.scopeRoot(bufnr)
	if not scope then
		return false
	end

	if vueScopeCache[scope] ~= nil then
		return vueScopeCache[scope]
	end

	local packageJsonPath = vim.fs.joinpath(scope, 'package.json')
	local packageJson = readJson(packageJsonPath)
	local hasVue = hasVueDependency(packageJson)
	vueScopeCache[scope] = hasVue
	return hasVue
end

function M.vueRootDir(bufnr, on_dir)
	local root = M.projectRoot(bufnr)
	if root and M.isVueWorkspace(bufnr) then
		on_dir(root)
	end
end

function M.nonVueRootDir(bufnr, on_dir)
	local root = M.projectRoot(bufnr)
	if root and not M.isVueWorkspace(bufnr) then
		on_dir(root)
	end
end

return M
