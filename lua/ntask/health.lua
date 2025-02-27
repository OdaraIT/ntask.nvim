-- health.lua - Checkhealth para validar Taskwarrior

local health = {}

local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

function health.run_check()
  print('[ntask.nvim] Executando diagnóstico...')
  if command_exists('task') then
    print('[✓] Taskwarrior disponível')
  else
    print('[✗] Taskwarrior NÃO encontrado')
  end
  if command_exists('taskui') then
    print('[✓] Taskwarrior UI disponível')
  else
    print('[✗] Taskwarrior UI NÃO encontrado')
  end
end

return health
