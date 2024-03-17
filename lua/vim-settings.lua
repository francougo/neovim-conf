vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Keymaps
vim.g.mapleader = ","

-- Tab navigation
vim.keymap.set('n', '<C-m>', ':tabn<cr>')
vim.keymap.set('n', '<C-n>', ':tabp<cr>')

-- Clipboard
vim.keymap.set('n', '<leader>P', '"+p')
vim.keymap.set('n', '<leader>p', '"*p')
vim.keymap.set('v', '<leader>Y', '"+y')
vim.keymap.set('v', '<leader>y', '"*y')

-- Paste in the line below
vim.keymap.set('n', 'P', 'o<esc>p')

-- Open terminal
vim.keymap.set('n', '<leader>t', ':term<cr>A')

