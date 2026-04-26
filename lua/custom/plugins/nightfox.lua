return {
  'EdenEast/nightfox.nvim',
  priority = 1000,
  config = function()
    require('nightfox').setup {
      options = {
        -- Compiled file's destination location
        colorblind = {
          enable = true,
        },
        styles = {},
      },
    }
    vim.cmd.colorscheme 'dayfox'
  end,
}
