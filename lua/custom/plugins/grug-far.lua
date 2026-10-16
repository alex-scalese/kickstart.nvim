vim.pack.add { 'https://github.com/MagicDuck/grug-far.nvim' }

require('grug-far').setup {}

vim.keymap.set(
  { 'n', 'x' },
  '<leader>sR',
  function() require('grug-far').open { visualSelectionUsage = 'auto-detect' } end,
  { desc = '[S]earch and [R]eplace' }
)
