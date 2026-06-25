return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	opts = function(_, opts)
		local to_hex = function(value)
			if type(value) ~= 'number' then
				return nil
			end
			return string.format('#%06x', value)
		end
		local get_hl = function(name)
			local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
			return ok and hl or {}
		end
		local lualine_x_colors = function()
			local x = get_hl('lualine_x_normal')
			return {
				fg = to_hex(x.fg),
				bg = to_hex(x.bg),
			}
		end
		local current_buf = function()
			return vim.api.nvim_get_current_buf()
		end
		local oxlint_attached = function()
			return vim.lsp.get_clients({
				bufnr = current_buf(),
				name = 'oxlint',
			})[1] ~= nil
		end
		local oxlint_busy = function()
			local busy = _G.oxlint_busy_buffers
			return busy and busy[current_buf()] == true
		end

		opts.theme = 'kanagawa-wave'
		opts.sections = opts.sections or {}
		opts.sections.lualine_c = { { 'filename', path = 1 } }
		opts.sections.lualine_b = { 'branch', 'diff' }
		opts.sections.lualine_x = {
			{
				function()
					local frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
					local frameIndex = (math.floor(vim.uv.now() / 100) % #frames) + 1
					return 'oxlint ' .. frames[frameIndex]
				end,
				cond = function()
					return oxlint_attached() and oxlint_busy()
				end,
			},
			{
				'lsp_status',
				icon = '',
				symbols = {
					spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
					done = '✓',
					separator = ' ',
				},
				ignore_lsp = {
					'null-ls',
					'copilot',
					'oxlint',
				},
				show_name = true,
				cond = function()
					return oxlint_attached() and oxlint_busy()
				end,
				color = function()
					return lualine_x_colors()
				end,
			},
			{
				'lsp_status',
				icon = '',
				symbols = {
					spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
					done = '✓',
					separator = ' ',
				},
				ignore_lsp = {
					'null-ls',
					'copilot',
				},
				show_name = true,
				cond = function()
					return (not oxlint_attached()) or (not oxlint_busy())
				end,
				color = function()
					return lualine_x_colors()
				end,
			},
			{
				function()
					return " "
				end,
				color = function()
					local x = get_hl('lualine_x_normal')
					local err = get_hl('DiagnosticError')
					local warn = get_hl('DiagnosticWarn')
					local special = get_hl('Special')
					local status = require("sidekick.status").get()
					if status then
						local fg = status.kind == "Error" and (err.fg or special.fg)
							or status.busy and (warn.fg or special.fg)
							or special.fg
						return {
							fg = to_hex(fg),
							bg = to_hex(x.bg),
						}
					end
				end,
				cond = function()
					local status = require("sidekick.status")
					return status.get() ~= nil
				end,
			},
			{
				function()
					local status = require("sidekick.status").cli()
					return " " .. (#status > 1 and #status or "")
				end,
				cond = function()
					return #require("sidekick.status").cli() > 0
				end,
				color = function()
					local x = get_hl('lualine_x_normal')
					local special = get_hl('Special')
					return {
						fg = to_hex(special.fg),
						bg = to_hex(x.bg),
					}
				end,
			},
			'encoding',
			'fileformat',
			'filetype'
		}
	end,
}
