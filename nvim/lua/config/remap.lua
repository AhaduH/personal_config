vim.g.mapleader = " "

vim.keymap.set("n", "<leader>m", vim.cmd.Ex, { desc = "" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "page down centers" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "page up centers" })

vim.keymap.set("n", "n", "nzzzv", { desc = "next search centers and opens folds" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "prev search centers and opens folds" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move line up" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank into global clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "yank entire line into global clipboard" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste without overwriting default register" })

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "next item in local location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "prev item in local location list" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "<Esc> unhighlights searches" })

-- lots of useful default lsp maps, check using :map (moved to LspAttach autocmd)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "go to decleration" })
-- vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "show function signature" })
