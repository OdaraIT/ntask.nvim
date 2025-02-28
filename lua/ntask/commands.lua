-- commands.lua - Functions to manage tasks in Taskwarrior

local commands = {}
local config = require('ntask.config')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

local function validate_dependencies()
  if not command_exists('task') then
    print('[ntask.nvim] ERROR: Taskwarrior not found. Please install Taskwarrior before using this plugin.')
    return false
  end
  return true
end

function commands.add_task()
  if not validate_dependencies() then
    return
  end
  config.load()
  local cfg = config.get()

  vim.ui.input({ prompt = 'New Task: ' }, function(input)
    if input and input ~= '' then
      local cmd = 'task add ' .. vim.fn.shellescape(input)
      if cfg.project then
        cmd = cmd .. ' project:' .. vim.fn.shellescape(cfg.project)
      end
      if cfg.tags and #cfg.tags > 0 then
        cmd = cmd .. ' +' .. table.concat(cfg.tags, ' +')
      end
      if cfg.priority then
        cmd = cmd .. ' priority:' .. cfg.priority
      end
      if cfg.duedate then
        cmd = cmd .. ' due:' .. cfg.duedate
      end
      vim.fn.system(cmd)
      print('Task added: ' .. input)
    else
      print('Operation canceled')
    end
  end)
end

function commands.mark_done()
  if not validate_dependencies() then
    return
  end
  vim.ui.input({ prompt = 'Task ID to mark as done: ' }, function(input)
    if input and input ~= '' then
      local cmd = 'task ' .. vim.fn.shellescape(input) .. ' done'
      vim.fn.system(cmd)
      print('Task marked as done: ' .. input)
    else
      print('Operation canceled')
    end
  end)
end

function commands.list_tasks()
  if not validate_dependencies() then
    return
  end
  config.load()
  local cfg = config.get()
  local cmd = 'task project:' .. vim.fn.shellescape(cfg.project) .. ' status:pending'
  local output = vim.fn.systemlist(cmd)

  pickers
    .new({}, {
      prompt_title = 'Tasks for project ' .. cfg.project,
      finder = finders.new_table({ results = output }),
      sorter = sorters.get_generic_fuzzy_sorter(),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            print('Selected Task: ' .. selection[1])
          end
        end)
        return true
      end,
    })
    :find()
end

function commands.delete_task()
  if not validate_dependencies() then
    return
  end
  vim.ui.input({ prompt = 'Task ID to delete: ' }, function(input)
    if input and input ~= '' then
      vim.ui.select({ 'Yes', 'No' }, { prompt = 'Are you sure?' }, function(choice)
        if choice == 'Yes' then
          local cmd = 'task ' .. vim.fn.shellescape(input) .. ' delete'
          vim.fn.system(cmd)
          print('Task deleted: ' .. input)
        else
          print('Operation canceled')
        end
      end)
    else
      print('Operation canceled')
    end
  end)
end

function commands.edit_task()
  if not validate_dependencies() then
    return
  end
  vim.ui.input({ prompt = 'Task ID to edit: ' }, function(input)
    if input and input ~= '' then
      vim.ui.input({ prompt = 'New details: ' }, function(details)
        if details and details ~= '' then
          local cmd = 'task ' .. vim.fn.shellescape(input) .. ' modify ' .. vim.fn.shellescape(details)
          vim.fn.system(cmd)
          print('Task modified: ' .. input)
        else
          print('Operation canceled')
        end
      end)
    else
      print('Operation canceled')
    end
  end)
end

-- Register commands in Neovim
vim.api.nvim_create_user_command('TaskAdd', commands.add_task, {})
vim.api.nvim_create_user_command('TaskDone', commands.mark_done, {})
vim.api.nvim_create_user_command('TaskList', commands.list_tasks, {})
vim.api.nvim_create_user_command('TaskDelete', commands.delete_task, {})
vim.api.nvim_create_user_command('TaskEdit', commands.edit_task, {})

return commands
