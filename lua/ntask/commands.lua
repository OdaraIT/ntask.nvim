-- commands.lua - Funções para manipular tarefas no Taskwarrior

local commands = {}
local config = require('ntask.config')

local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

local function validate_dependencies()
  if not command_exists('task') then
    print('[ntask.nvim] ERRO: Taskwarrior não encontrado. Instale o Taskwarrior antes de usar este plugin.')
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

  vim.ui.input({ prompt = 'Nova Tarefa: ' }, function(input)
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
      print('Tarefa adicionada: ' .. input)
    else
      print('Operação cancelada')
    end
  end)
end

return commands
