vim.pack.add { 'https://github.com/iamcco/markdown-preview.nvim' }

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'markdown-preview.nvim' then return end
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end
    vim.fn['mkdp#util#install']()
  end,
})
