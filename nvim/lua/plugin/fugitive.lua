return {
	'tpope/vim-fugitive',
	config = function()
		vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'See git status' });
		vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'See git blame', silent = true });
	end
}
