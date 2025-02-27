-- config.lua - Carregamento e validação do .ntask.yml

local yaml = require('lyaml')

local schema = {
  project = { type = 'string', default = 'General' },
  tags = { type = 'table', default = {} },
  priority = { type = 'string', enum = { 'H', 'M', 'L' }, default = 'M' },
  duedate = { type = 'string', default = '+3d' },
}

local config = {}

local function validate_config(parsed)
  local validated = {}
  for key, rules in pairs(schema) do
    local value = parsed[key]
    if value == nil then
      validated[key] = rules.default
    else
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

function config.load()
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

function config.get()
  return config
end

return config
