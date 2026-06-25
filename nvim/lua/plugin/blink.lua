vim.g.blink_debug_auto_import = 1

local function completion_data(item)
	if type(item) ~= "table" then
		return nil
	end
	if type(item.data) ~= "table" then
		return nil
	end
	if type(item.data.original) == "table" and type(item.data.original.data) == "table" then
		return item.data.original.data
	end
	return item.data
end

local function is_auto_import_item(item)
	local data = completion_data(item)
	if type(data) ~= "table" then
		return false
	end
	return data.__vue__autoImportSuggestions ~= nil
		or data.__vue__tsgoAutoImportHint ~= nil
		or data.__vue__tsgoAutoImportVirtual ~= nil
		or data.__vue__autoImport ~= nil
		or data.__vue__componentAutoImport ~= nil
end

local function item_source_description(item)
	if type(item.labelDetails) == "table" and type(item.labelDetails.description) == "string" then
		local desc = vim.trim(item.labelDetails.description)
		if desc ~= "" then
			return desc
		end
	end
	local data = completion_data(item)
	if type(data) ~= "table" then
		return ""
	end
	return data.__vue__autoImportSuggestions and data.__vue__autoImportSuggestions.source
		or data.__vue__tsgoAutoImportHint and data.__vue__tsgoAutoImportHint.source
		or data.__vue__tsgoAutoImportVirtual and data.__vue__tsgoAutoImportVirtual.source
		or ""
end

local function dedupe_lsp_items(items)
	local deduped = {}
	local by_key = {}
	for _, item in ipairs(items) do
		local label = string.lower(vim.trim(tostring(item.label or "")))
		local source = string.lower(vim.trim(item_source_description(item)))
		local key = source ~= "" and (label .. "|" .. source) or (label .. "|<no-source>")
		local existing_index = by_key[key]
		if existing_index == nil then
			table.insert(deduped, item)
			by_key[key] = #deduped
		else
			local existing = deduped[existing_index]
			if (not is_auto_import_item(existing)) and is_auto_import_item(item) then
				deduped[existing_index] = item
			end
		end
	end
	return deduped
end

return {
	'saghen/blink.cmp',
	dependencies = {
		'rafamadriz/friendly-snippets',
		'fang2hou/blink-copilot',
		'saghen/blink.lib',
	},
	build = function()
		require('blink.cmp').build():wait(60000)
	end,
	init = function()
		vim.keymap.set('i', '<Tab>', function()
			local cmp = require('blink.cmp')
			if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
				return '<Tab>'
			end
			if cmp.is_visible() then
				cmp.select_next()
				return '<Ignore>'
			end
			if vim.snippet.active({ direction = 1 }) then
				return '<Cmd>lua vim.snippet.jump(1)<CR>'
			end
			local ok, sidekick = pcall(require, 'sidekick')
			if ok and type(sidekick.nes_jump_or_apply) == 'function' and sidekick.nes_jump_or_apply() then
				return '<Ignore>'
			end
			return '<Tab>'
		end, {
			desc = 'Blink next completion, snippet jump, or tab',
			expr = true,
			silent = true,
		})

		vim.keymap.set('i', '<S-Tab>', function()
			local cmp = require('blink.cmp')
			if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
				return '<S-Tab>'
			end
			if cmp.is_visible() then
				cmp.select_prev()
				return '<Ignore>'
			end
			if vim.snippet.active({ direction = -1 }) then
				return '<Cmd>lua vim.snippet.jump(-1)<CR>'
			end
			return '<S-Tab>'
		end, {
			desc = 'Blink previous completion, snippet jump, or shift-tab',
			expr = true,
			silent = true,
		})
	end,

	version = '2.*',
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = 'enter',
			["<Tab>"] = { 'select_next', 'snippet_forward', 'fallback' },
			['<S-Tab>'] = {
				'select_prev',
				'snippet_backward',
				'fallback'
			},
			["<C-s>"] = {
				"snippet_forward",
				"fallback",
			},
			["<S-C-s>"] = {
				"snippet_backward",
				"fallback",
			},
		},

		signature = { enabled = true },

		appearance = {
			nerd_font_variant = 'mono'
		},

		completion = {
			accept = {
				resolve_timeout_ms = 5000
			},
			documentation = { auto_show = true, auto_show_delay_ms = 500 },
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				}
			},
			menu = {
				draw = {
					columns = { { "kind_icon" }, { "label", gap = 1 }, { "label_description" } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				}
			},
			ghost_text = { enabled = true },
		},
		cmdline = { enabled = false },
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
			providers = {
				lsp = {
					name = "LSP",
					score_offset = 20,
					transform_items = function(_, items)
						return dedupe_lsp_items(items)
					end,
				},
				buffer = {
					name = "Buffer",
					score_offset = -10,
				},
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
					opts = {
						max_completions = 3,
					}
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" }
	},
	opts_extend = { "sources.default" }
}
