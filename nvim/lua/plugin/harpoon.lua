return {
	'ThePrimeagen/harpoon',
	config = function()
		local mark = require('harpoon.mark');
		local ui = require('harpoon.ui');

		vim.keymap.set('n', '<leader>a', mark.add_file, { desc = 'Add file to harpoon' });
		vim.keymap.set('n', '<leader>e', ui.toggle_quick_menu, { desc = 'Toggle harpoon menu' });

		vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end, { desc = 'Navigate to first harpooned file' });
		vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end, { desc = 'Navigate to second harpooned file' });
		vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end, { desc = 'Navigate to third harpooned file' });
		vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end, { desc = 'Navigate to fourth harpooned file' });
		vim.keymap.set('n', '<leader>5', function() ui.nav_file(5) end, { desc = 'Navigate to fifth harpooned file' });
		vim.keymap.set('n', '<leader>6', function() ui.nav_file(6) end, { desc = 'Navigate to sixth harpooned file' });
	end
}
