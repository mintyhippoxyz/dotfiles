return {
	{
		'ellisonleao/gruvbox.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			local gruvbox = require('gruvbox');
			gruvbox.setup({
				contrast = 'hard',
				inverse = true,
				overrides = {
					DiffText = { bg = gruvbox.palette.dark_aqua_hard },
				}
			});

			vim.opt.background = 'dark'
			vim.cmd.colorscheme('gruvbox')
		end,
	},
	{
		'rose-pine/neovim',
		lazy = true,
		name = 'rose-pine',
		config = function()
			vim.cmd.colorscheme('rose-pine')
		end
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		config = function()
			vim.cmd.colorscheme('tokyonight-night')
			-- vim.cmd.colorscheme('tokyonight-moon')
			-- vim.cmd.colorscheme('tokyonight')
			-- vim.cmd.colorscheme('tokyonight-storm')
			-- vim.cmd.colorscheme('tokyonight-day')
		end
	}
}
