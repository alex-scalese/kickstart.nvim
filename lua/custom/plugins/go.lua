vim.pack.add {
  'https://github.com/ray-x/guihua.lua',
  'https://github.com/ray-x/go.nvim',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod' },
  group = vim.api.nvim_create_augroup('custom-go-setup', { clear = true }),
  once = true,
  callback = function()
    require('go').setup()
  end,
})
