-- lua/ntask.lua - Main entry point for ntask.nvim

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
  keymaps = {
    add_task = '<leader>tk',
  },
}

-- Setup function
function M.setup(user_config)
  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend('force', M.defaults, user_config or {})

  -- Load config with new defaults
  config.load()

  -- Register commands in Neovim
  vim.api.nvim_create_user_command('TaskAdd', commands.add_task, {})
  vim.api.nvim_create_user_command('TaskList', commands.list_tasks, {})
  vim.api.nvim_create_user_command('TaskDone', commands.mark_done, {})
  vim.api.nvim_create_user_command('TaskDelete', commands.delete_task, {})
  vim.api.nvim_create_user_command('TaskEdit', commands.edit_task, {})

  -- Configure keymaps if set
  if M.config.keymaps.add_task then
    vim.api.nvim_set_keymap('n', M.config.keymaps.add_task, ':TaskAdd<CR>', { noremap = true, silent = true })
  end
end

-- Health check integration
M.checkhealth = function()
  health.run_check()
end

return M
