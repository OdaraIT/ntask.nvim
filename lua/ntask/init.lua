local config = require('ntask.config')

local NTask = {}

function NTask.setup(opts)
  _G.NTaskConfig = config.setup(opts)
end

function NTask.checkhealth()
  require('ntask.health').run_check()
end

_G.NTask = NTask

return _G.NTask
