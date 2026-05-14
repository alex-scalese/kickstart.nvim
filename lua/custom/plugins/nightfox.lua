vim.pack.add { 'https://github.com/EdenEast/nightfox.nvim' }

require('nightfox').setup {
  options = {
    colorblind = {
      enable = true,
    },
    styles = {},
  },
}

vim.cmd.colorscheme 'dayfox'

