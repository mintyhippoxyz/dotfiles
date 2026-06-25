return {
	"folke/noice.nvim",
	event = "VeryLazy",
	config = function()
		local noice = require('noice');
		noice.setup({
			routes = {
				{
					filter = {
						event = "notify",
						find = "Request textDocument/inlayHint failed",
					},
					opts = { skip = true },
				}
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = { silent = true }
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
			views = {
				mini = {
					win_options = {
						winblend = 98,
					},
				},
			},
		})
		vim.keymap.set("n", "<leader>nl", function()
			noice.cmd("last")
		end)

		vim.keymap.set("n", "<leader>nh", function()
			noice.cmd("telescope")
		end)
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = function()
				local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
				local bg = normal and normal.bg
				local background = type(bg) == "number" and string.format("#%06x", bg) or "#000000"
				return {
					background_colour = background,
				}
			end,
		},
	}
}
