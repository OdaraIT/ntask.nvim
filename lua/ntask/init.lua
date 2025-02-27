local M = {}

M.config = require('ntask.config')
M.commands = require('ntask.commands')
M.health = require('ntask.health')

-- Atalho para adicionar tarefa
vim.api.nvim_set_keymap(
  'n',
  '<leader>tk',
  ':lua require\'ntask.commands\'.add_task()<CR>',
  { noremap = true, silent = true }
)

-- Função de checkhealth
M.checkhealth = M.health.run_check

return M
