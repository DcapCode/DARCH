return
{
	{
		'nvim-treesitter/nvim-treesitter',
		build = function()
			pcall(require('nvim-treesitter.install').update({ with_sync = true }))
		end,
		config = function()
			-- require('nvim-treesitter.configs').setup({
			--	ensure_installed = {'lua', 'json', 'yaml'},
			--	highlight = { enable = true },
			--	sync_install = false,
			--	auto_install = true,
			--	additional_vim_regex_highlighting = false,
			--})
		end

	}

}
