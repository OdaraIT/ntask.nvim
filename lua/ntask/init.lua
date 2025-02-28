local main = require('ntask.main')
local config = require('ntask.config')

local NTask = {}

-- Setup function for user configurations
function NTask.setup(opts)
  _G.NTaskConfig = config.setup(opts)
end

-- Run health check
function NTask.checkhealth()
  require('ntask.health').run_check()
end

-- Register NTask globally
_G.NTask = NTask

return _G.NTask
