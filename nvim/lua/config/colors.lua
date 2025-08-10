--[[
-- keep default color scheme for now, but get rid of the god awful bold white and add different color options 
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "default",
  callback = function()
    vim.api.nvim_set_hl(0, "Statement", { fg = "#EC9EFF", bold = false })
    vim.api.nvim_set_hl(0, "Boolean", { fg = "#2B8AFF"})
    vim.api.nvim_set_hl(0, "String", { fg = "#FFB185" })
    vim.api.nvim_set_hl(0, "Character", { fg = "#FFB185" })
    vim.api.nvim_set_hl(0, "Identifier", { fg = "#7DB7FF" })
  end,
})

-- explicitly load default so the autocmd triggers
vim.cmd.colorscheme("default")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
]]
