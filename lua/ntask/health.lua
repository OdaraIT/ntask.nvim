-- health.lua - Checkhealth for ntask.nvim

local health = {}
local vim_health = require('health')

local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

function health.run_check()
  vim_health.start('ntask.nvim Health Check')

  -- Check Taskwarrior
  if command_exists('task') then
    vim_health.ok('Taskwarrior is installed')
  else
    vim_health.error('Taskwarrior is NOT installed. Please install it before using ntask.nvim.')
  end

  -- Check Telescope
  local has_telescope, _ = pcall(require, 'telescope')
  if has_telescope then
    vim_health.ok('Telescope.nvim is installed')
  else
    vim_health.error('Telescope.nvim is NOT installed. Please install it for task listing.')
  end

  -- Check Plenary
  local has_plenary, _ = pcall(require, 'plenary')
  if has_plenary then
    vim_health.ok('Plenary.nvim is installed')
  else
    vim_health.error('Plenary.nvim is NOT installed. Please install it as a dependency.')
  end
end

return health
