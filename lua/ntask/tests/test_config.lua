-- test_config.lua - Unit tests for ntask.nvim configuration

local test = require('plenary.busted')
local config = require('ntask.config')

describe('ntask.config', function()
  it('should load the config module', function()
    assert.is_not_nil(config)
  end)

  it('should load default config when no .ntask.yml is found', function()
    config.load() -- Ensure no `.ntask.yml` exists
    local cfg = config.get()
    assert.are_equal(cfg.project, 'General')
    assert.are_equal(cfg.priority, 'M')
  end)
end)
