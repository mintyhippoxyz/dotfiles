if vim.env.TERM:match('screen') or vim.env.TERM:match('tmux') then
	vim.opt.guicursor = 'a:Cursor/lCursor'
else
	vim.opt.guicursor = ''
end
vim.opt.nu = true
vim.opt.backupcopy = 'yes'

-- What does the line number shifting
vim.opt.relativenumber = false

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.wrap = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.nvim/undo'
vim.opt.directory = os.getenv('HOME') .. '/.nvim/swaps'
vim.opt.backupdir = os.getenv('HOME') .. '/.nvim/backups'

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true


vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50

vim.g.mapleader = ' '

-- Folds
vim.opt.foldmethod = 'marker'
vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:-,nbsp:_'

-- reload files changed outside vim
vim.opt.autoread = true
-- show the filename in the window titelbar
vim.opt.title = true

-- vertical split below
vim.opt.splitbelow = true
-- horizontal split to the right
vim.opt.splitright = true

-- enable mouse in all modes
vim.opt.mouse = 'a'

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd.normal({ args = { "g'\"" }, bang = true })
		end
	end
})

vim.g.netrw_keepdir = 0

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "yaml", "yml" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})
