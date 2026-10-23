return {
    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = { "clangd", "lua_ls" },
            -- ensure_installed = { "clangd", "rust_analyzer", "gopls", "pyright", "ts_ls", "lua_ls", "zls" },
            automatic_enable = true,
        },

        config = function(_, opts)
            local group = vim.api.nvim_create_augroup(
                "PersonalLspAttach",
                { clear = true }
            )

            vim.api.nvim_create_autocmd("LspAttach", {
                group = group,

                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if not client then return end

                    local buf = ev.buf

                    -- Buffer-local mappings for LSP actions
                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, {
                            buffer = buf,
                            desc = desc,
                        })
                    end

                    -- LSP completion
                    if client:supports_method("textDocument/completion") then
                        vim.opt.completeopt = {
                            "menu",
                            "menuone",
                            "noselect",
                        }

                        -- aggressive completion triggering:
                        -- all printable ASCII characters (32-126).
                        local chars = {}
                        for i = 32, 126 do
                            chars[#chars + 1] = string.char(i)
                        end

                        if client.server_capabilities.completionProvider then
                            client.server_capabilities.completionProvider.triggerCharacters = chars
                        end

                        vim.lsp.completion.enable(
                            true,
                            client.id,
                            buf,
                            { autotrigger = true }
                        )

                        map("i", "<C-Space>", function()
                            vim.lsp.completion.get()
                        end, "Trigger LSP completion")
                    end

                    -- LSP formatting
                    if client:supports_method("textDocument/formatting") then
                        -- Optional: format current buffer on save
                        --[[
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = buf,
                            callback = function()
                                vim.lsp.buf.format({
                                    bufnr = buf,
                                    id = client.id,
                                })
                            end,
                        })
                        ]]

                        -- default -> gq (but used as motion, not whole file)
                        map("n", "<leader>lf", function()
                            vim.lsp.buf.format({
                                bufnr = buf,
                                id = client.id,
                            })
                        end, "Format current buffer")
                    end

                    -- LSP navigation and actions
                    map("n", "gd",
                        vim.lsp.buf.definition,
                        "Go to definition")

                    map("n", "gD",
                        vim.lsp.buf.declaration,
                        "Go to declaration")

                    -- default -> <C-s>
                    -- map("i", "<C-k>",
                    --     vim.lsp.buf.signature_help,
                    --     "Show function signature")

                    -- default -> gra
                    -- map("n", "<leader>ca",
                    --     vim.lsp.buf.code_action,
                    --     "LSP code action")
                end,
            })

            -- Diagnostics
            vim.diagnostic.config({
                -- virtual_text = true,
                -- virtual_text = { current_line = true },
                virtual_lines = {
                    current_line = true,
                },
            })

            -- Mason setup runs once, after LspAttach is registered.
            require("mason-lspconfig").setup(opts)
        end,
    },
}
