vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

require('catppuccin').setup {
  styles = {
    comments = { 'italic' },
  },
}

-- vim.cmd.colorscheme 'catppuccin-mocha'

