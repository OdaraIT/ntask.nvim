local M = {}
local yaml = require('lyaml')

local schema = {
  project = { type = 'string', default = 'General' },
  tags = { type = 'table', default = {} },
  priority = { type = 'string', enum = { 'H', 'M', 'L' }, default = 'M' },
  duedate = { type = 'string', default = '+3d' },
}

local config = {}

-- Função para validar e aplicar o schema
local function validate_config(parsed)
  local validated = {}

  for key, rules in pairs(schema) do
    local value = parsed[key]

    -- Se o valor não existir, usa o default
    if value == nil then
      validated[key] = rules.default
    else
      -- Valida o tipo
      if type(value) == rules.type then
        if rules.enum then
          for _, valid_value in ipairs(rules.enum) do
            if value == valid_value then
              validated[key] = value
              break
            end
          end
          validated[key] = validated[key] or rules.default
        else
          validated[key] = value
        end
      else
        validated[key] = rules.default
      end
    end
  end

  return validated
end

-- Função para carregar configurações do projeto
local function load_config()
  local config_path = vim.fn.getcwd() .. '/.ntask.yml'
  local file = io.open(config_path, 'r')
  if file then
    local content = file:read('*a')
    file:close()
    local success, parsed = pcall(yaml.load, content)
    if success and type(parsed) == 'table' then
      config = validate_config(parsed)
    else
      config = validate_config({})
    end
  else
    config = validate_config({})
  end
end

-- Função para adicionar uma nova tarefa
function M.add_task()
  load_config()
  vim.ui.input({ prompt = 'Nova Tarefa: ' }, function(input)
    if input and input ~= '' then
      local cmd = 'task add ' .. vim.fn.shellescape(input)
      if config.project then
        cmd = cmd .. ' project:' .. vim.fn.shellescape(config.project)
      end
      if config.tags and #config.tags > 0 then
        cmd = cmd .. ' +' .. table.concat(config.tags, ' +')
      end
      if config.priority then
        cmd = cmd .. ' priority:' .. config.priority
      end
      if config.duedate then
        cmd = cmd .. ' due:' .. config.duedate
      end
      vim.fn.system(cmd)
      print('Tarefa adicionada: ' .. input)
    else
      print('Operação cancelada')
    end
  end)
end

-- Registrar atalho
vim.api.nvim_set_keymap('n', '<leader>tk', ':lua require\'ntask\'.add_task()<CR>', { noremap = true, silent = true })

return M
