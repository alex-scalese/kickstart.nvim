vim.pack.add {
  'https://github.com/ray-x/guihua.lua',
  'https://github.com/ray-x/go.nvim',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod' },
  group = vim.api.nvim_create_augroup('custom-go-setup', { clear = true }),
  once = true,
  callback = function() require('go').setup() end,
})

vim.lsp.config('gopls', {
  cmd = { vim.fn.exepath 'gopls' },
  settings = {
    gopls = {
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
            unusedvariable = true,
            useany = true,
            nilness = true,
            httpresponse = true,
          },
          codelenses = {
            gc_details = true,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          staticcheck = true,
          semanticTokens = true,
          gofumpt = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
  },
})
vim.lsp.enable 'gopls'
