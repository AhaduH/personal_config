vim.g.mapleader = " "

-- vim.keymap.set("n", "<leader>m", vim.cmd.Ex, { desc = "open netrw" })
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "open parent dir using oil" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "page down centers" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "page up centers" })

vim.keymap.set("n", "n", "nzzzv", { desc = "next search centers and opens folds" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "prev search centers and opens folds" })

vim.keymap.set("x", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "move line down" })
vim.keymap.set("x", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "move line up" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank into global clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "yank entire line into global clipboard" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste without overwriting default register" })

-- already default [q and ]q
-- vim.keymap.set("n", "<leader>k", "<cmd>cnext<CR>zz", { desc = "next item in local quickfix list" })
-- vim.keymap.set("n", "<leader>j", "<cmd>cprev<CR>zz", { desc = "prev item in local quickfix list" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "<Esc> unhighlights searches" })

-- lots of useful default lsp maps, check using :map (moved to LspAttach autocmd)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "go to decleration" })
-- vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "show function signature" })

-- -vim.keymap.set("n", "<leader>u", function()
--     vim.cmd("packadd nvim.undotree")
--     vim.cmd("Undotree")
-- end, { desc = "Native undo tree" })-
