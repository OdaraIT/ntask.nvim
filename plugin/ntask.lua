if vim.g.loaded_ntask then
  return
end

vim.g.loaded_ntask = true

local ntask = require('ntask')

ntask.setup({})
