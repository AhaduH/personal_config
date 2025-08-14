return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "rust_analyzer", "gopls", "pyright", "ts_ls", "lua_ls", "zls" },
                automatic_installation = true,
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if not client then return end

                    if client:supports_method('textDocument/completion') then
                        vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy" }
                        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
                        -- trigger lsp completion (ex: after backspace, turn back on)
                        vim.keymap.set('i', '<C-Space>', function()
                            vim.lsp.completion.get()
                        end)
                    end

                    if client:supports_method('textDocument/formatting') then
                        --[[
                        -- format current buffer on save
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = ev.buf,
                            callback = function()
                                vim.lsp.buf.format({ buffnr = ev.buf, id = client.id })
                            end,
                        })
                        ]]
                        vim.keymap.set('n', '<leader>lf', function()
                            vim.lsp.buf.format({ buffnr = ev.buf, id = client.id })
                        end)
                    end

                    -- location for any lsp-specific remaps
                end,
            })

            vim.diagnostic.config({
                -- just pick any of them base on clutter? also popup hover option
                -- virtual_text = true,
                --virtual_text = {
                --    current_line = true
                --},
                virtual_lines = {
                    current_line = true
                }
            })
        end,
    }
}
