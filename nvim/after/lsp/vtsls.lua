local workspace = require('config.typescript_workspace')
local typescriptPreferences = require('config.typescript_preferences')

local typescriptConfig = {
	inlayHints = typescriptPreferences.inlayHints,
	format = typescriptPreferences.format,
	preferences = typescriptPreferences.preferences,
	suggest = typescriptPreferences.suggest,
	experimental = {
		-- useTsgo = true,
	},
}
local vueLanguageServerPath = vim.fn.expand('$MASON/packages')
	.. '/vue-language-server'
	.. '/node_modules/@vue/language-server';
return {
	on_init = function(_client, bufnr)
		vim.keymap.set('n', '<leader>R', function()
		end, {})
	end,
	settings = {
		typescript = typescriptConfig,
		javascript = typescriptPreferences.languageSettings({
			inlayHints = typescriptPreferences.inlayHints,
			format = typescriptPreferences.format,
		}),
		vtsls = {
			autoUseWorkspaceTsdk = true,
			tsserver = {
				globalPlugins = {
					{
						name = '@vue/typescript-plugin',
						location = vueLanguageServerPath,
						languages = { 'vue' },
						configNamespace = 'typescript',
						enableForWorkspaceTypeScriptVersions = true
					}
				},
			},
		},
	},
	root_dir = workspace.vueRootDir,
	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
}
