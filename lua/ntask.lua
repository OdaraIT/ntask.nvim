local M = {}
local config = require('ntask.config')
local commands = require('ntask.commands')
local health = require('ntask.health')

-- Default settings
M.defaults = {
  project = 'General',
  tags = {},
  priority = 'M',
  duedate = '+3d',
}

-- Setup function
function M.setup(user_config)
  user_config = user_config or {}
  for key, value in pairs(M.defaults) do
    if user_config[key] ~= nil then
      M.defaults[key] = user_config[key]
    end
  end

  -- Load config with new defaults
  config.load()

  -- Register commands in Neovim
  vim.api.nvim_create_user_command('TaskAdd', commands.add_task, {})
  vim.api.nvim_create_user_command('TaskDone', commands.mark_done, {})
  vim.api.nvim_create_user_command('TaskList', commands.list_tasks, {})
  vim.api.nvim_create_user_command('TaskDelete', commands.delete_task, {})
  vim.api.nvim_create_user_command('TaskEdit', commands.edit_task, {})
end

return M
