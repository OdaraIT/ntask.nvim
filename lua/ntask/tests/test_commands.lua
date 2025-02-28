-- test_commands.lua - Unit tests for ntask.nvim commands

local test = require('plenary.busted')
local commands = require('ntask.commands')

describe('ntask.commands', function()
  it('should load the commands module', function()
    assert.is_not_nil(commands)
  end)

  it('should add a task', function()
    vim.fn.system = function(cmd)
      return cmd
    end -- Mock system call
    local result = commands.add_task('Test Task')
    assert.is_not_nil(result)
  end)
end)
