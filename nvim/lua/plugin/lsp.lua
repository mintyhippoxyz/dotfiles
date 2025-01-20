return {
	-- {{{ Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'onsails/lspkind.nvim',
			'L3MON4D3/LuaSnip',
			{
				"zbirenbaum/copilot-cmp",
				autostart = false,
				dependencies = {
					"zbirenbaum/copilot.lua",
					config = function()
						require("copilot").setup()
					end
				},
				config = function()
					require("copilot_cmp").setup()
				end,
			}
		},
		config = function()
			local cmp = require('cmp')

			local lspkind = require('lspkind')
			lspkind.init({
				symbol_map = {
					Copilot = "",
				},
			})
			vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

			vim.g.copilot_no_tab_map = true;
			vim.g.copilot_assume_mapped = true;


			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<CR>'] = cmp.mapping.confirm({ select = false }),
					['<C-Space>'] = cmp.mapping.complete(),
					['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				}),
				sources = {
					{ name = "copilot",  group_index = 2 },
					{ name = "nvim_lsp", group_index = 2 },
					{ name = "path",     group_index = 2 },
					{ name = "luasnip",  group_index = 2 },
				},
				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 100, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					})
				},
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
			})
		end
	},
	--- }}}
	-- {{{ LSP Configurations
	{
		'neovim/nvim-lspconfig',
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'cmp-nvim-lsp'
		},
		config = function()
			-- setup lsp manager/installer
			require('mason').setup({})
			require('mason-lspconfig').setup({
				ensure_installed = {
					'volar',
					'ts_ls',
					'eslint',
					'jsonls',
					'lua_ls',
					'bashls'
				}
			})

			local lspConfig = require('lspconfig')
			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			lspConfig.util.default_config.capabilities = vim.tbl_deep_extend(
				'force',
				lspConfig.util.default_config.capabilities,
				require('cmp_nvim_lsp').default_capabilities()
			)

			-- LspAttach is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'x' }, '<F3>', function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
					vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
					vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
					vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
					vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>lf', '<cmd>EslintFixAll<CR>')
					-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

					-- setup formatting cmds
					local id = vim.tbl_get(event, 'data', 'client_id')
					local client = id and vim.lsp.get_client_by_id(id)
					if client == nil then
						return
					end
					local allowedFormatters = {
						lua_ls = true,
						['null-ls'] = true,
						['rust-analyzer'] = true
					}
					local lspFormatting = function()
						vim.lsp.buf.format({
							filter = function(currentClient)
								return allowedFormatters[currentClient.name]
							end,
							async = false,
							timeout_ms = 10000
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
							callback = lspFormatting
						})
					end

					vim.keymap.set('n', '<leader>f', lspFormatting, opts)
					if client.supports_method("textDocument/formatting") then
						buffer_autoformat(event.buf);
					end
				end,
			})

			-- now lets setup each specific LSP with their configs
			lspConfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { 'vim' }
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true)
						}
					}
				}
			})

			local typescriptConfig = {
				format = {
					insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true
				}
			}
			local masonRegistry = require('mason-registry')
			local vueLanguageServerPath = masonRegistry.get_package('vue-language-server'):get_install_path() ..
				'/node_modules/@vue/language-server'

			local util = require('lspconfig.util');
			local rootDir = util.root_pattern('.git');

			lspConfig.ts_ls.setup({
				filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
				root_dir = rootDir,
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vueLanguageServerPath,
							languages = { "typescript", "vue" },
						}
					},
					preferences = {
						importModuleSpecifier = 'non-relative',
						importModuleSpecifierEnding = 'js'
						-- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						-- includeInlayFunctionParameterTypeHints = true,
						-- includeInlayVariableTypeHints = true,
						-- includeInlayPropertyDeclarationTypeHints = true,
						-- includeInlayFunctionLikeReturnTypeHints = true,
						-- includeInlayEnumMemberValueHints = true,
					}
				},
				settings = {
					typescript = typescriptConfig,
					javascript = typescriptConfig,
				}
			})

			lspConfig.volar.setup({
				root_dir = rootDir,
				settings = {
					vue = {
						complete = {
							casing = {
								tags = 'autoKebab'
							}
						}
					}
				}
			})
			vim.keymap.set('n', '<leader>R', function()
				vim.cmd('LspRestart tsserver');
			end, {})
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
				sources = {
					nullLs.builtins.formatting.prettierd,
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
		config = function()
			local target = nil;
			if string.find(vim.loop.cwd(), 'windows') then
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
						vim.keymap.set('n', '<leader>r', function()
							vim.cmd.RustLsp('runnables');
						end)
						vim.keymap.set('n', '<leader>rr', function()
							vim.cmd.RustLsp({ 'runnables', bang = true });
						end)
						vim.keymap.set('n', '<leader>rd', function()
							vim.cmd.RustLsp({ 'debuggables', bang = true });
						end)
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				},
			}
		end
	}
	-- }}}
}
