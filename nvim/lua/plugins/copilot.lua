return {
    {
        "github/copilot.vim",
        config = function()
            vim.cmd("Copilot disable")
            local copilot_enabled = false
            vim.keymap.set({'n', 'i'}, "<leader>ct", function()
                if copilot_enabled then
                    vim.cmd("Copilot disable")
                    copilot_enabled = false
                else 
                    vim.cmd("Copilot enable")
                    copilot_enabled = true
                end
            end)
        end,
    },
}
