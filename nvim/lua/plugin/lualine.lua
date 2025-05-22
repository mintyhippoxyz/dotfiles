return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons', 'AndreM222/copilot-lualine' },
	config = function()
		local lualine = require('lualine')
		lualine.setup({
			options = {
				theme = 'gruvbox',
			},
			sections = {
				lualine_b = { 'branch', 'diff' },
				lualine_c = { { 'filename', path = 1 } },
				lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
			}
		})
	end
}
