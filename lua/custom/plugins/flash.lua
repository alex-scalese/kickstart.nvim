vim.pack.add { 'https://github.com/folke/flash.nvim' }

require('flash').setup {}


vim.keymap.set({ 'n', 'x', 'o' }, '<leader>z', function() require('flash').jump() end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>Z', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
