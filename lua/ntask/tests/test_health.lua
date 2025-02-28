-- test_health.lua - Unit tests for ntask.nvim health check

local test = require('plenary.busted')
local health = require('ntask.health')

describe('ntask.health', function()
  it('should load the health module', function()
    assert.is_not_nil(health)
  end)

  it('should run the health check without errors', function()
    assert.has_no.errors(function()
      health.run_check()
    end)
  end)
end)
