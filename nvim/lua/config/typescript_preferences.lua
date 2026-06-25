local M = {}

M.preferences = {
	importModuleSpecifier = 'non-relative',
	importModuleSpecifierEnding = 'js',
}

M.suggest = {
	autoImports = true,
}

M.inlayHints = {
	parameterNames = {
		enabled = 'all',
	},
	parameterTypes = {
		enabled = true,
	},
	variableTypes = {
		enabled = true,
	},
	propertyDeclarationTypes = {
		enabled = true,
	},
	functionLikeReturnTypes = {
		enabled = true,
	},
}

M.format = {
	insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
}

function M.languageSettings(extra)
	return vim.tbl_deep_extend('force', {
		preferences = M.preferences,
		suggest = M.suggest,
	}, extra or {})
end

return M
