return {
	"juacker/git-link.nvim",
	opts = {
		url_rules = {
			{
				pattern = "^https?://(gitea[^/]+)/(.+)$",
				replace = "https://%1/%2",
				format_url = function(base_url, params)
					local single_line_url =
						string.format("%s/src/branch/%s/%s#L%d", base_url, params.branch, params.file_path, params
							.start_line)

					if params.start_line == params.end_line then
						return single_line_url
					end

					return string.format("%s-L%d", single_line_url, params.end_line)
				end,
			},
			{
				pattern = "^git@(gitea[^:]+):",
				replace = "https://%1/",
				format_url = function(base_url, params)
					local single_line_url =
						string.format("%s/src/branch/%s/%s#L%d", base_url, params.branch, params.file_path, params
							.start_line)

					if params.start_line == params.end_line then
						return single_line_url
					end

					return string.format("%s-L%d", single_line_url, params.end_line)
				end,
			},
			{
				pattern = "^ssh://git@(gitea[^:/]+)/",
				replace = "https://%1/",
				format_url = function(base_url, params)
					local single_line_url =
						string.format("%s/src/branch/%s/%s#L%d", base_url, params.branch, params.file_path, params
							.start_line)

					if params.start_line == params.end_line then
						return single_line_url
					end

					return string.format("%s-L%d", single_line_url, params.end_line)
				end,
			},
		}
	},
	keys = {
		{
			"<leader>gu",
			function() require("git-link.main").copy_line_url() end,
			desc = "Copy code link to clipboard",
			mode = { "n", "x" }
		},
	},
}
