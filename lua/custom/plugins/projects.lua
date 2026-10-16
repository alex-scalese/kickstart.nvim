-- Open another project in its own Neovide instance or tmux window without
-- touching the project in the current window.
local project_roots = {
  vim.fn.expand '~/devel',
}

local function normalize(path) return vim.fs.normalize(vim.fn.fnamemodify(path, ':p')) end

local function add_project(projects, seen, path)
  if not path or path == '' then return end

  path = normalize(path)
  if seen[path] or vim.fn.isdirectory(path) ~= 1 then return end

  seen[path] = true
  projects[#projects + 1] = path
end

local function git_root(path)
  if not path or path == '' then return nil end

  path = normalize(path)
  local start = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
  return start and vim.fs.root(start, '.git') or nil
end

local function recent_projects()
  local projects, seen = {}, {}

  -- Include the current project first, followed by Git roots from ShaDa's
  -- persistent recent-file history.
  add_project(projects, seen, git_root(vim.fn.getcwd()))
  for _, file in ipairs(vim.v.oldfiles) do
    add_project(projects, seen, git_root(file))
  end

  return projects, seen
end

local function launch_neovide(project)
  if vim.fn.executable 'neovide' ~= 1 then
    vim.notify('Could not find neovide in PATH.', vim.log.levels.ERROR, { title = 'Projects' })
    return
  end

  vim.notify(vim.fn.fnamemodify(project, ':~'), vim.log.levels.INFO, { title = 'Opening project in Neovide' })
  vim.system({ 'neovide', '--fork' }, { cwd = project }, function(result)
    if result.code == 0 then return end

    vim.schedule(function()
      local message = result.stderr and result.stderr ~= '' and result.stderr or 'Neovide could not be started.'
      vim.notify(message, vim.log.levels.ERROR, { title = 'Projects' })
    end)
  end)
end

local function launch_terminal(project)
  if vim.fn.executable 'tmux' ~= 1 then
    vim.notify('Could not find tmux in PATH.', vim.log.levels.ERROR, { title = 'Projects' })
    return
  end
  if not vim.env.TMUX or vim.env.TMUX == '' then
    vim.notify('This Neovim instance was not started from tmux.', vim.log.levels.ERROR, { title = 'Projects' })
    return
  end

  local name = vim.fs.basename(project)
  vim.system({ 'tmux', 'new-window', '-n', name, '-c', project, 'nvim' }, { text = true }, function(result)
    if result.code == 0 then return end

    vim.schedule(function()
      local message = result.stderr and result.stderr ~= '' and result.stderr or 'Could not open a new tmux window.'
      vim.notify(message, vim.log.levels.ERROR, { title = 'Projects' })
    end)
  end)
end

local function select_project(projects, prompt, launch)
  if #projects == 0 then
    vim.notify('No projects found.', vim.log.levels.WARN, { title = 'Projects' })
    return
  end

  vim.ui.select(projects, {
    prompt = prompt,
    format_item = function(project) return vim.fn.fnamemodify(project, ':~') end,
  }, function(project)
    if project then launch(project) end
  end)
end

local function open_project_picker(prompt, launch)
  local projects, seen = recent_projects()
  local roots = vim.tbl_filter(function(path) return vim.fn.isdirectory(path) == 1 end, project_roots)

  if #roots == 0 then
    select_project(projects, prompt, launch)
    return
  end

  local command = { 'find' }
  vim.list_extend(command, roots)
  vim.list_extend(command, { '-maxdepth', '4', '-name', '.git', '-prune' })

  -- Scan asynchronously so a large project directory never blocks the editor.
  vim.system(command, { text = true }, function(result)
    vim.schedule(function()
      local discovered = {}
      for marker in (result.stdout or ''):gmatch '[^\r\n]+' do
        local project = vim.fs.dirname(marker)
        if project and not seen[normalize(project)] then discovered[#discovered + 1] = project end
      end
      table.sort(discovered)

      for _, project in ipairs(discovered) do
        add_project(projects, seen, project)
      end

      select_project(projects, prompt, launch)
    end)
  end)
end

local function open_in_neovide() open_project_picker('Open project in a new Neovide window', launch_neovide) end
local function open_in_terminal() open_project_picker('Open project in a new tmux window', launch_terminal) end

vim.api.nvim_create_user_command('ProjectOpen', open_in_neovide, {
  desc = 'Open a project in a new Neovide window',
})
vim.api.nvim_create_user_command('ProjectOpenTerminal', open_in_terminal, {
  desc = 'Open a project in a new tmux window',
})

vim.keymap.set('n', '<leader>pp', open_in_neovide, {
  desc = '[P]ick [P]roject in new Neovide window',
})
vim.keymap.set('n', '<leader>pt', open_in_terminal, {
  desc = 'Open [P]roject in new [T]erminal window',
})

require('which-key').add {
  { '<leader>p', group = '[P]roject' },
}
