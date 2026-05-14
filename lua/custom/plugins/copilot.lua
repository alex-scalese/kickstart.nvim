vim.pack.add {
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/fang2hou/blink-copilot',
}

require('copilot').setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}

