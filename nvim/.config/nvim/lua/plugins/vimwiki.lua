local function config()
	vimwiki_dir = "~/Documents/notes/vimwiki"

	vim.g.vimwiki_list = {
		{
			path = vimwiki_dir,
			template_path = vimwiki_dir .. "templates/",
			template_default = "default",
			syntax = "markdown",
			ext = ".md",
			path_html = vimwiki_dir .. "site_html/",
			custom_wiki2html = "vimwiki_markdown",
			template_ext = ".tpl",
		},
	}
	vim.g.vimwiki_global_ext = 0
end

return {
	"vimwiki/vimwiki",
	-- we should use init for vimwiki and not config
	init = config,
}
