-- Debugggers
return {
	{
		'mfussenegger/nvim-dap',
		config = function()
			local dap = require('dap');
			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
				},
			}
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
			local codelldb_path = vim.fn.stdpath("data") ..
				'/mason/packages/codelldb/codelldb'
			print(codelldbpath);
			dap.adapters.codelldb = {
				type = 'server',
				port = "${port}",
				executable = {
					command = codelldb_path,
					args = { "--port", "${port}" },
				}
			}

			vim.keymap.set('n', '<leader>b', function()
				dap.toggle_breakpoint()
			end);
			vim.keymap.set('n', '<F5>', function() dap.continue() end)
			vim.keymap.set('n', '<F10>', function() dap.step_over() end)
			vim.keymap.set('n', '<F11>', function() dap.step_into() end)
			vim.keymap.set('n', '<F12>', function() dap.step_out() end)
			vim.keymap.set('n', '<leader>dl', function() dap.run_last() end)
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", { "folke/neodev.nvim", opts = {} } },
		config = function()
			local neodev = require('neodev');
			neodev.setup({
				library = { plugins = { "nvim-dap-ui" }, types = true }
			})
			local dapui = require('dapui');
			dapui.setup({});

			local dap = require('dap');
			dap.listeners.before.attach.dapui_config = function()
				dapui.open();
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open();
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close();
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close();
			end
		end
	}
}
