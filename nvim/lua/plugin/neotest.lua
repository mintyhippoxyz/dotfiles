return {
	"nvim-neotest/neotest",
	config = function()
		local neotest = require("neotest");
		neotest.setup({
			adapters = {
				require('rustaceanvim.neotest'),
				require('neotest-playwright').adapter({
					options = {
						persist_project_selection = true,
						enable_dynamic_test_discovery = true,
					},
				}),
				require("neotest-vitest") {
					-- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
					filter_dir = function(name, _rel_path, _root)
						return name ~= "node_modules"
					end,
				}
			},
		})
		vim.keymap.set('n', '<leader>tr', function()
			neotest.run.run()
		end)
		vim.keymap.set('n', '<leader>tv', function()
			neotest.output_panel.open()
		end)
		vim.keymap.set('n', '<leader>ts', function()
			neotest.summary.toggle()
		end)
		vim.keymap.set('n', '<leader>tw', function()
			neotest.watch.toggle(vim.fn.expand("%"))
		end)
	end,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"rustaceanvim",
		"marilari88/neotest-vitest",
		{
			'thenbe/neotest-playwright',
			dependencies = 'nvim-telescope/telescope.nvim',
		}
	}
}
