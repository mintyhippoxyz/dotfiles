local workspace = require('config.typescript_workspace')
local typescriptPreferences = require('config.typescript_preferences')

return {
	init_options = {
		typescript = {
		},
	},
	settings = {
		typescript = typescriptPreferences.languageSettings(),
		javascript = typescriptPreferences.languageSettings(),
		vue = {
			suggest = {
				autoImports = true,
				componentNameCasing = 'alwaysKebabCase',
				propsNameCasing = 'alwaysKebabCase'
			},
			inlayHints = {
				destructuredProps = true,
				inlineHandlerLeading = true,
				missingProps = true,
				optionsWrapper = true,
				vBindShorthand = true
			},
		}
	},
	root_dir = workspace.vueRootDir,
	on_init = function(client)
		client.handlers['tsserver/request'] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
			if #clients == 0 then
				vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels
					.ERROR)
				return
			end
			local ts_client = clients[1]

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = 'vue_request_forward',
				command = 'typescript.tsserverRequest',
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, r)
				local response_data = { { id, r.body } }
				---@diagnostic disable-next-line: param-type-mismatch
				client:notify('tsserver/response', response_data)
			end)
		end
	end
}
