local function get_if_available(name, opts)
	local lua_ok, colorscheme = pcall(require, name)
	if lua_ok then
		colorscheme.setup(opts)
		return name
	end
	local vim_ok, _ = pcall(vim.cmd.colorscheme, name)
	if vim_ok then
		return name
	end
	return 'default'
end


-- comment out and add a new colorscheme variable for a new theme
local colorscheme = get_if_available('cappuccin-mocha')

return colorscheme
