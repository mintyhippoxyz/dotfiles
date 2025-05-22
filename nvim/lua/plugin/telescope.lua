return {
	'nvim-telescope/telescope.nvim',
	version = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-ui-select.nvim',
		'BurntSushi/ripgrep'
	},
	config = function()
		local telescope = require('telescope')

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Search for files starting in current directory" })
		vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Look for any files tracked in git" })
		vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = "Grep for text in files" })
		vim.keymap.set('n', '<leader>pw', builtin.grep_string, { desc = "Grep a string?? Not sure :)" })
		vim.keymap.set('n', '<leader>ps', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") });
		end, { desc = "Something grep not sure :)" })


		local actions = require('telescope.actions');
		telescope.load_extension("noice");
		telescope.load_extension("ui-select");
		telescope.setup({
			defaults = {
				mappings = {
					i = {
						['<C-j>'] = 'move_selection_next',
						['<C-k>'] = 'move_selection_previous',
						['<C-o>'] = function(prompt_buffer)
							vim.cmd('cexpr []');
							actions.send_to_qflist(prompt_buffer);
							vim.cmd([[
						if !empty(getqflist())
							let s:prev_val = ""
							for d in getqflist()
								let s:curr_val = bufname(d.bufnr)
								if (s:curr_val != s:prev_val)
									exec "edit " . s:curr_val
								endif
								let s:prev_val = s:curr_val
							endfor
						endif
					]])
						end
					}
				}
			}
		})
	end
}
