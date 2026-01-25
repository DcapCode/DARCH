return 
{
	
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{
		'VonHeikemen/lsp-zero.nvim', 
		branch = 'v3.x',
		config = function() 
			local lsp = require('lsp-zero')
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'html', -- HTML
                    'jsonls', -- JSON
                    'lua_ls', -- LUA
                    'marksman', -- MD
                    'sqlls', -- SQL
                    'yamlls', -- YAML
                    'bashls', -- BASH
                    'dockerls', -- DOCKER
                    'docker_compose_language_service', -- DOCKER COMPOSE
                },
                handlers = {
                    lsp.default_setup,
                    lua_ls = function()
                        local lua_opts = lsp.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end
                }
            })
			lsp.preset('recommended')

			local cmp = require('cmp')
			local cmp_select = {behavior = cmp.SelectBehavior.Select}

            cmp.setup({
                sources = {
                    {name = 'path'},
                    {name = 'nvim_lsp'},
                    {name = 'nvim_lua'}
                },
                formatting = lsp.cmp_format(),
                mapping = cmp.mapping.preset.insert({
				    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({select = true}),
				    ['<C-space>'] = cmp.mapping.complete()
                })
                
            })

			lsp.set_preferences({
				sign_icons = { }
			})

	--		lsp.on_attach(function(client, bufnr)
                -- local opts = {buffer = bufnr, remap = false}
                -- local map = require('helpers.keys').map

				-- map('n', 'gd', function() vim.lsp.buf.definition() end, opts)
				-- map('n', 'K', function() vim.lsp.buf.hover() end, opts)
				-- map('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
				-- map('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
				-- map('n', '[d', function() vim.diagnostics.goto_next() end, opts)
				-- map('n', ']d', function() vim.diagnostics.goto_prev() end, opts)
				-- map('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
				-- map('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
				-- map('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
				-- map('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)	
			-- end)
			lsp.setup()
		end
	},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
	{'L3MON4D3/LuaSnip'},
}

