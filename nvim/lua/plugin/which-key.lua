return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = {
		preset = "modern"
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ loop = true })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
