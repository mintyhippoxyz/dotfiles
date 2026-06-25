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
			});

			vim.opt.background = 'dark'
			vim.cmd.colorscheme('gruvbox')
		end,
	},
	{
		'savq/melange',
		lazy = true,
		config = function()
			vim.opt.background = 'dark'
			vim.cmd.colorscheme('melange')
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
		"olimorris/onedarkpro.nvim",
		lazy = true,
		config = function()
			vim.cmd.colorscheme('onedark_dark')
		end
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		config = function()
		end
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		config = function()
			vim.opt.background = 'dark'
			vim.cmd.colorscheme('nightfox')
		end
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		config = function()
			require('kanagawa').setup({
				compile = true
			})
			vim.cmd.colorscheme('kanagawa-wave')
		end
	},
	{
		"catppuccin/nvim",
		lazy = true,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = {
					dark = "mocha",
				},
			})
			vim.cmd.colorscheme('catppuccin')
		end
	}
}
