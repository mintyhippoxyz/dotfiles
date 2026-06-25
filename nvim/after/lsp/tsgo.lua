local workspace = require('config.typescript_workspace')
local typescriptPreferences = require('config.typescript_preferences')

return {
	root_dir = workspace.nonVueRootDir,
	settings = {
		typescript = typescriptPreferences.languageSettings({
			inlayHints = vim.tbl_deep_extend('force', {}, typescriptPreferences.inlayHints, {
				enumMemberValues = {
					enabled = true,
				},
			}),
		}),
		javascript = typescriptPreferences.languageSettings(),
	},
}
