return {
	{
		'olimorris/onedarkpro.nvim',
		lazy = true,
		priority = 999,
		config = function()
			vim.cmd("colorscheme onedark")
		end
	},
	{
		'ellisonleao/gruvbox.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			local gruvbox = require('gruvbox');
			gruvbox.setup({
				contrast = 'hard',
				inverse = true
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
		'rebelot/kanagawa.nvim',
		lazy = true,
		--priority = 1000,
		name = 'kanagawa',
		config = function()
			vim.cmd('colorscheme kanagawa')
		end
	},
	{
		'kepano/flexoki-neovim',
		lazy = true,
		--priority = 1000,
		name = 'flexoki-dark',
		config = function()
			vim.cmd('colorscheme flexoki-dark')
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
