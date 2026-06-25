local ensureInstalled = {
	"bash",
	"c",
	"css",
	"javascript",
	"json",
	"lua",
	"make",
	"query",
	"rust",
	"php",
	"scss",
	"go",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"yaml",
	"dockerfile",
	"markdown",
	"markdown_inline"
}

return {
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		priority = 1000,
		branch = 'main',
		config = function()
			local treesitter = require('nvim-treesitter');

			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('TreesitterStart', {}),
				callback = function(event)
					local language = vim.treesitter.language.get_lang(event.match)
					if not language then
						return
					end

					if vim.tbl_contains(treesitter.get_installed(), language) then
						vim.treesitter.start(event.buf, language)
					end
				end,
			})
		end
	},
}
