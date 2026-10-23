return {
    "stevearc/oil.nvim",

    dependencies = {
        { "nvim-mini/mini.icons", opts = {} },
    },

    -- eager loading for directory-buffer handling
    lazy = false,

    opts = {
        default_file_explorer = true,
        columns = { "icon" },
        view_options = {
            show_hidden = true,
        },
    },

    config = function(_, opts)
        require("oil").setup(opts)

        -- replace ex netrw shortuts with oil
        vim.api.nvim_create_user_command("Ex", function()
            require("oil").open()
        end, {})

        vim.api.nvim_create_user_command("Sex", function(cmd_opts)
            vim.cmd("split")
            if cmd_opts.bang then
                vim.cmd("wincmd p")
            end
            require("oil").open()
        end, { bang = true })

        vim.api.nvim_create_user_command("Vex", function(cmd_opts)
            vim.cmd("vsplit")
            if cmd_opts.bang then
                vim.cmd("wincmd p")
            end
            require("oil").open()
        end, { bang = true })

        vim.api.nvim_create_user_command("Tex", function()
            vim.cmd("tabnew")
            require("oil").open()
        end, {})
    end,
}
