return {
	cmd = function(dispatchers, config)
		return vim.lsp.rpc.start({ 'pnpm', 'exec', 'oxlint', '--lsp' }, dispatchers, {
			cwd = config.root_dir
		})
	end
}
