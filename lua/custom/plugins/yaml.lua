vim.pack.add {
  'https://github.com/b0o/SchemaStore.nvim',
  'https://github.com/qvalentin/helm-ls.nvim',
}

local schemas = require('schemastore').yaml.schemas {
  extra = {
    {
      name = 'Kubernetes',
      description = 'Kubernetes resources without cluster-specific CRDs',
      fileMatch = { '*.k8s.yaml', '*.k8s.yml' },
      -- `kubernetes` activates yamlls' special handling for manifests whose
      -- resources intentionally match more than one schema definition.
      url = 'kubernetes',
    },
  },
}

vim.lsp.config('yamlls', {
  -- Helm files are handled by helm_ls to avoid duplicate diagnostics.
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      completion = true,
      hover = true,
      validate = true,
      format = { enable = true },
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = schemas,
    },
  },
})
vim.lsp.enable 'yamlls'

require('helm-ls').setup {
  -- Keep templates visible as written; the experimental conceal feature can
  -- be enabled later if desired.
  conceal_templates = { enabled = false },
}

vim.lsp.config('helm_ls', {
  settings = {
    ['helm-ls'] = {
      yamlls = {
        enabled = true,
        path = 'yaml-language-server',
      },
    },
  },
})
vim.lsp.enable 'helm_ls'

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-yaml-hover', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or (client.name ~= 'yamlls' and client.name ~= 'helm_ls') then return end

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
      buffer = event.buf,
      desc = 'Show documentation for YAML field',
    })
  end,
})
