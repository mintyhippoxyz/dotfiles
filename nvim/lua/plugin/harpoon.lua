return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Add file to harpoon' });
		vim.keymap.set('n', '<leader>e', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
			{ desc = 'Toggle harpoon menu' });

		vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end,
			{ desc = 'Navigate to first harpooned file' });
		vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end,
			{ desc = 'Navigate to second harpooned file' });
		vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end,
			{ desc = 'Navigate to third harpooned file' });
		vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end,
			{ desc = 'Navigate to fourth harpooned file' });
		vim.keymap.set('n', '<leader>5', function() harpoon:list():select(5) end,
			{ desc = 'Navigate to fifth harpooned file' });
		vim.keymap.set('n', '<leader>6', function() harpoon:list():select(6) end,
			{ desc = 'Navigate to sixth harpooned file' });

		vim.keymap.set("n", "<leader>hn", function() harpoon:list():prev() end)
		vim.keymap.set("n", "<leader>hl", function() harpoon:list():next() end)
	end
}
