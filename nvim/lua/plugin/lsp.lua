return {
	-- {{{ LSP Configurations
	{
		'neovim/nvim-lspconfig',
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
		config = function()
			-- setup lsp manager/installer
			require('mason').setup({})
			require('mason-lspconfig').setup({
				ensure_installed = {
					'jsonls',
					'lua_ls',
					'bashls',
					'phpactor',
					'eslint',
				},
				automatic_enable = {
					exclude = { 'vtsls' },
				},
			})

			local oxlintBusyBuffers = {}
			local oxlintBusyTimers = {}
			local oxlintBusySince = {}
			local oxlintSawOxcDiagnostics = {}
			local oxlintMinVisibleMs = 180
			local oxlintSettleDelayMs = 500
			local oxlintBusyTimeoutMs = 3000
			local oxlintSpinnerTimer = nil
			_G.oxlint_busy_buffers = oxlintBusyBuffers

			local refreshStatusline = function()
				local ok, lualine = pcall(require, 'lualine')
				if ok then
					lualine.refresh({ place = { 'statusline' } })
				end
			end

			local hasAnyBusyBuffer = function()
				for _, isBusy in pairs(oxlintBusyBuffers) do
					if isBusy then
						return true
					end
				end
				return false
			end

			local ensureSpinnerTimer = function()
				if oxlintSpinnerTimer then
					return
				end
				oxlintSpinnerTimer = vim.uv.new_timer()
				oxlintSpinnerTimer:start(100, 100, function()
					vim.schedule(refreshStatusline)
				end)
			end

			local stopSpinnerTimerIfIdle = function()
				if not oxlintSpinnerTimer then
					return
				end
				if hasAnyBusyBuffer() then
					return
				end
				oxlintSpinnerTimer:stop()
				oxlintSpinnerTimer:close()
				oxlintSpinnerTimer = nil
			end

			local setOxlintBusy = function(bufnr, isBusy)
				if oxlintBusyBuffers[bufnr] == isBusy then
					return
				end
				oxlintBusyBuffers[bufnr] = isBusy
				if isBusy then
					oxlintBusySince[bufnr] = vim.uv.now()
				else
					oxlintBusySince[bufnr] = nil
				end
				if isBusy then
					ensureSpinnerTimer()
				else
					stopSpinnerTimerIfIdle()
				end
				refreshStatusline()
			end

			local hasOxlintClient = function(bufnr)
				return vim.lsp.get_clients({ bufnr = bufnr, name = 'oxlint' })[1] ~= nil
			end

			local clearOxlintBusy

			local markOxlintBusy = function(bufnr)
				if not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end
				if not hasOxlintClient(bufnr) then
					return
				end
				oxlintSawOxcDiagnostics[bufnr] = false
				setOxlintBusy(bufnr, true)

				local timer = oxlintBusyTimers[bufnr]
				if timer then
					timer:stop()
					timer:close()
				end

				timer = vim.uv.new_timer()
				oxlintBusyTimers[bufnr] = timer
				timer:start(oxlintBusyTimeoutMs, 0, function()
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(bufnr) then
							setOxlintBusy(bufnr, false)
						end
					end)
				end)
			end

			local scheduleOxlintClear = function(bufnr, delayMs)
				local timer = oxlintBusyTimers[bufnr]
				if timer then
					timer:stop()
					timer:close()
				end
				timer = vim.uv.new_timer()
				oxlintBusyTimers[bufnr] = timer
				timer:start(delayMs, 0, function()
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(bufnr) then
							clearOxlintBusy(bufnr)
						end
					end)
				end)
			end

			clearOxlintBusy = function(bufnr)
				local busySince = oxlintBusySince[bufnr]
				if busySince then
					local elapsed = vim.uv.now() - busySince
					if elapsed < oxlintMinVisibleMs then
						local timer = oxlintBusyTimers[bufnr]
						if timer then
							timer:stop()
							timer:close()
						end
						timer = vim.uv.new_timer()
						oxlintBusyTimers[bufnr] = timer
						timer:start(oxlintMinVisibleMs - elapsed, 0, function()
							vim.schedule(function()
								if vim.api.nvim_buf_is_valid(bufnr) then
									setOxlintBusy(bufnr, false)
								end
							end)
						end)
						return
					end
				end
				setOxlintBusy(bufnr, false)
				local timer = oxlintBusyTimers[bufnr]
				if timer then
					timer:stop()
					timer:close()
					oxlintBusyTimers[bufnr] = nil
				end
			end

			local indicatorGroup = vim.api.nvim_create_augroup('oxlint_loading_indicator', { clear = true })
			vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
				group = indicatorGroup,
				callback = function(args)
					markOxlintBusy(args.buf)
				end,
			})
			vim.api.nvim_create_autocmd('DiagnosticChanged', {
				group = indicatorGroup,
				callback = function(args)
					if not hasOxlintClient(args.buf) then
						return
					end
					local diagnostics = (args.data and args.data.diagnostics) or {}
					local hasOxc = false
					for _, diagnostic in ipairs(diagnostics) do
						if diagnostic.source == 'oxc' then
							hasOxc = true
							break
						end
					end
					if hasOxc or #diagnostics == 0 then
						if hasOxc then
							oxlintSawOxcDiagnostics[args.buf] = true
							-- Keep spinner alive until diagnostics have been stable briefly.
							scheduleOxlintClear(args.buf, oxlintSettleDelayMs)
						elseif oxlintSawOxcDiagnostics[args.buf] then
							-- Empty update after oxc diagnostics means lint settled.
							scheduleOxlintClear(args.buf, oxlintSettleDelayMs)
						end
					end
				end,
			})
			vim.api.nvim_create_autocmd({ 'BufWipeout', 'BufDelete' }, {
				group = indicatorGroup,
				callback = function(args)
					clearOxlintBusy(args.buf)
					oxlintBusyBuffers[args.buf] = nil
					oxlintSawOxcDiagnostics[args.buf] = nil
				end,
			})

			-- LspAttach is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = function(event)
					local attachedClientId = vim.tbl_get(event, 'data', 'client_id')
					local attachedClient = attachedClientId and vim.lsp.get_client_by_id(attachedClientId)
					if attachedClient and attachedClient.name == 'oxlint' then
						markOxlintBusy(event.buf)
					end

					local opts = { buffer = event.buf }
					local runOxcFixAll = function(bufnr)
						local lintClient = vim.lsp.get_clients({ bufnr = bufnr, name = 'oxlint' })[1]
						if not lintClient then
							return
						end
						if #vim.diagnostic.get(bufnr) == 0 then
							return
						end

						lintClient:request_sync('workspace/executeCommand', {
							command = 'oxc.fixAll',
							arguments = {
								{
									uri = vim.uri_from_bufnr(bufnr),
								},
							},
						}, 1000, bufnr)
					end

					vim.keymap.set('n', 'K', vim.lsp.buf.hover,
						{ buffer = event.buf, desc = 'Show type information on currently hovered text' })
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
						{ buffer = event.buf, desc = 'Go to definition on currently hovered text' })
					vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition,
						{ buffer = event.buf, desc = 'Go to type definition on currently hovered text' })
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references,
						{ buffer = event.buf, desc = 'Show what is using the currently hovered text' })
					vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'x' }, '<F3>', function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action,
						{ buffer = event.buf, desc = 'Show code actions for the currently hovered text' })
					vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
					vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float,
						{ buffer = event.buf, desc = 'Show diagnostics for the currently hovered text' })
					vim.keymap.set('n', '[d', function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, { buffer = event.buf, desc = 'Go to next diagnostic' })
					vim.keymap.set('n', ']d', function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, { buffer = event.buf, desc = 'Go to previous diagnostic' })
					vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action,
						{ buffer = event.buf, desc = 'Show code actions for the currently hovered text' })
					vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>lf', function()
						local hasEslint = vim.lsp.get_clients({ bufnr = event.buf, name = 'eslint' })[1] ~= nil
						if hasEslint and vim.fn.exists(':LspEslintFixAll') == 2 then
							vim.cmd('LspEslintFixAll')
							return
						end
						runOxcFixAll(event.buf)
					end, { buffer = event.buf, desc = 'Run fix all on current file' })
					vim.keymap.set("n", '<leader>i', function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
							{ bufnr = event.buf })
					end, { buffer = event.buf, desc = 'Toggle inlay hints' })
					vim.diagnostic.config({
						virtual_lines = {
							current_line = true,
						},
					})

					-- setup formatting cmds
					local allowedFormatters = {
						lua_ls = true,
						['null-ls'] = true,
						['rust-analyzer'] = true,
						oxfmt = true
					}
					local oxfmtFileType = {
						javascript = true,
						javascriptreact = true,
						['javascript.jsx'] = true,
						typescript = true,
						typescriptreact = true,
						['typescript.tsx'] = true,
						json = true,
						jsonc = true,
						vue = true,
					}
					local lspFormatting = function(bufnr)
						local currentFiletype = vim.bo[bufnr].filetype
						if oxfmtFileType[currentFiletype] then
							local oxfmtClient = vim.lsp.get_clients({ bufnr = bufnr, name = 'oxfmt' })[1]
							if oxfmtClient and oxfmtClient:supports_method('textDocument/formatting') then
								vim.lsp.buf.format({
									bufnr = bufnr,
									filter = function(currentClient)
										return currentClient.name == 'oxfmt'
									end,
									async = false,
									timeout_ms = 2000
								})
								return
							end

							return
						end

						vim.lsp.buf.format({
							bufnr = bufnr,
							filter = function(currentClient)
								return allowedFormatters[currentClient.name]
							end,
							async = false,
							timeout_ms = 2000
						})
					end

					local buffer_autoformat = function(bufnr)
						local group = 'lsp_autoformat'
						vim.api.nvim_create_augroup(group, { clear = false })
						vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

						vim.api.nvim_create_autocmd('BufWritePre', {
							buffer = bufnr,
							group = group,
							desc = 'LSP format on save',
							callback = function()
								if oxfmtFileType[vim.bo[bufnr].filetype] then
									runOxcFixAll(bufnr)
								end
								lspFormatting(bufnr)
							end
						})
					end

					vim.keymap.set('n', '<leader>f', function()
							lspFormatting(event.buf)
						end,
						{ buffer = event.buf, desc = 'Format current buffer' })
					buffer_autoformat(event.buf)
				end,
			})

			vim.lsp.enable({
				'vue_ls',
				'vtsls',
				'tsgo',
				'lua_ls',
				'bashls',
				'jsonls',
				'phpactor',
				'copilot',
				'oxlint',
				'oxfmt',
				'eslint',
			});
		end
	},
	-- }}}
	-- {{{ Formatters and Linters
	{
		'nvimtools/none-ls.nvim',
		dependencies = {
			{
				'davidmh/cspell.nvim',
				dependencies = {
					'nvim-lua/plenary.nvim'
				}
			}
		},
		config = function()
			local cSpell = require('cspell')
			local cSpellConfig = {
				find_json = function(cwd)
					return os.getenv("HOME") .. '/.spellings.json'
				end,
			}

			local nullLs = require('null-ls')
			nullLs.setup({
				debounce = 1000,
				sources = {
					nullLs.builtins.formatting.terraform_fmt,
					nullLs.builtins.formatting.shfmt.with({
						filetypes = { 'sh', 'bash' }
					}),
					cSpell.diagnostics.with({
						config = cSpellConfig,
						diagnostics_postprocess = function(diagnostic)
							diagnostic.severity = diagnostic.message:find("really") and
								vim.diagnostic.severity["ERROR"]
								or vim.diagnostic.severity["WARN"]
						end,
					}),
					cSpell.code_actions.with({ config = cSpellConfig }),
				}
			})
		end
	},
	-- }}}
	-- {{{ Rust specific LSP setup
	-- this rust plugin is more than just LSP so add it separately than the normal lsp setup
	{
		'mrcjkb/rustaceanvim',
		version = '^5', -- Recommended
		ft = { 'rust' },
		lazy = false,
		config = function()
			local target = nil;
			if string.find(vim.uv.cwd(), 'windows') then
				target = 'x86_64-pc-windows-gnu';
			end
			vim.g.rustaceanvim = {
				server = {
					settings = {
						['rust-analyzer'] = {
							cargo = {
								target = target,
							}
						}
					},
					on_attach = function(client, bufnr)
						vim.fn.setenv('RUSTFLAGS', "-C target-feature=-crt-static");

						vim.keymap.set('n', '<leader>r', function()
							vim.cmd.RustLsp('runnables');
						end)
						vim.keymap.set('n', '<leader>rr', function()
							vim.cmd.RustLsp({ 'runnables', bang = true });
						end)
						vim.keymap.set('n', '<leader>rd', function()
							vim.cmd.RustLsp({ 'debuggables', bang = true });
						end)
						vim.keymap.set('n', '<leader>rt', function()
							vim.cmd.RustLsp('testables');
						end)
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				},
			}
		end,
	}
	-- }}}
}
