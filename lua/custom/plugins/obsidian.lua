vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/obsidian-nvim/obsidian.nvim',
}

require('obsidian').setup {
  legacy_commands = false,
  workspaces = {
    {
      name = 'personal',
      path = '~/second-brain/',
    },
  },
  completion = {
    lsp = true,
    min_chars = 2,
  },
  frontmatter = {
    func = function(note)
      local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = '', project = '' }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  group = vim.api.nvim_create_augroup('custom-obsidian-markdown', { clear = true }),
  callback = function() vim.opt_local.conceallevel = 2 end,
})
vim.keymap.set('n', '<leader>of', '<cmd>Obsidian follow_link<cr>', { desc = 'Obsidian follow' })
vim.keymap.set('n', '<leader>od', function() require('obsidian').util.toggle_checkbox() end, { desc = 'Obsidian toggle checkbox' })
