return {
	'akinsho/bufferline.nvim',
	lazy = false,
	priority = 100,
	version = '*',
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	config = function(bufferLine)
		local bufferLine = require('bufferline')

		vim.keymap.set({ "n", "v" }, "gt", ":BufferLinePick<CR>")
		vim.keymap.set({ "n", "v" }, "gx", ":BufferLinePickClose<CR>")
		bufferLine.setup({
			options = {
				diagnostics = 'nvim_lsp',
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						local sym = e == "error" and " "
							or (e == "warning" and " " or "")
						s = s .. n .. " " .. sym .. " "
					end
					return s
				end,
				truncate_names = false
			}
		})
	end
}
