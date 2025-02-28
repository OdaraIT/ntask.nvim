local config = {}
local plenary_path = require('plenary.path')

local schema = {
  project = { type = 'string', default = 'General' },
  tags = { type = 'table', default = {} },
  priority = { type = 'string', enum = { 'H', 'M', 'L' }, default = 'M' },
  duedate = { type = 'string', default = '+3d' },
}

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
  local config_path = vim.fn.getcwd() .. '/.ntask.json'
  local file = plenary_path.new(config_path)

  if file:exists() then
    local content = file:read()
    local success, parsed = pcall(vim.json.decode, content)
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
