return {
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		priority = 1000,
		build = ':TSUpdate',
		version = 'v0.9.2',
		config = function()
			local treesitterConfigs = require('nvim-treesitter.configs');
			treesitterConfigs.setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = {
					"bash",
					"c",
					"css",
					"javascript",
					"json",
					"lua",
					"query",
					"rust",
					"php",
					"scss",
					"typescript",
					"vim",
					"vimdoc",
					"vue",
					"yaml",
					"dockerfile",
					"markdown",
					"markdown_inline"
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				highlight = {
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			});
		end
	},
	'nvim-treesitter/playground'
}
