return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',   -- master deprecated, now requires tree-sitter-cli install
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter').setup({
            -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
            install_dir = vim.fn.stdpath('data') .. '/site'
        })

        require('nvim-treesitter').install({
            "c", "lua", "vimdoc", "markdown", "cpp", "bash",
            "rust", "go", "zig", "python", "java",  "javascript", "typescript",
        })

        vim.api.nvim_create_autocmd('FileType', {
            pattern = {
                "c", "lua", "vimdoc", "markdown", "cpp", "bash",
                "rust", "go", "zig", "python", "java",  "javascript", "typescript",
            },
            callback = function()
                -- treesitter based highlighting
                vim.treesitter.start()

                -- treesitter based folding
                -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()' 
                -- vim.wo[0][0].foldmethod = 'expr'

                -- treesitter based indentation
                -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,

        })
    end,
}

