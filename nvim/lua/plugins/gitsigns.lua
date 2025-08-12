return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup()
    end
    -- gitsigns also has on_attach callback, can use to set remaps
}
