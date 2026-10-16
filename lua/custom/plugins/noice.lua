vim.pack.add {
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/rcarriga/nvim-notify',
}

require('noice').setup {
  cmdline = {
    enabled = true,
    view = 'cmdline_popup',
  },
  messages = {
    view = 'mini',
    view_error = 'notify',
    view_warn = 'notify',
  },
  lsp = {
    -- Fidget already displays LSP progress in this config.
    progress = { enabled = false },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
    },
  },
  routes = {
    {
      view = 'mini',
      filter = {
        event = 'notify',
        ['not'] = {
          any = {
            { error = true },
            { warning = true },
          },
        },
      },
    },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
}

vim.keymap.set('n', '<leader>nh', function() require('noice').cmd 'history' end, { desc = '[N]oice [H]istory' })
vim.keymap.set('n', '<leader>nl', function() require('noice').cmd 'last' end, { desc = '[N]oice [L]ast message' })
vim.keymap.set('n', '<leader>nd', function() require('noice').cmd 'dismiss' end, { desc = '[N]oice [D]ismiss messages' })
