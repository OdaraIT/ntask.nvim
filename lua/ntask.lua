-- ntask.nvim - Plugin para integração do Taskwarrior com Neovim

local M = {}
local yaml = require("lyaml") -- Biblioteca para parse de YAML
local config = {}

-- Função para carregar configurações do projeto
local function load_config()
	local config_path = vim.fn.getcwd() .. "/.ntask.yml"
	local file = io.open(config_path, "r")
	if file then
		local content = file:read("*a")
		file:close()
		local success, parsed = pcall(yaml.load, content)
		if success and type(parsed) == "table" then
			config = parsed
		end
	end
end

-- Função para adicionar uma nova tarefa
function M.add_task()
	load_config() -- Carrega os defaults antes de adicionar a tarefa
	vim.ui.input({ prompt = "Nova Tarefa: " }, function(input)
		if input and input ~= "" then
			local cmd = "task add " .. vim.fn.shellescape(input)
			if config.project then
				cmd = cmd .. " project:" .. vim.fn.shellescape(config.project)
			end
			if config.tags and #config.tags > 0 then
				cmd = cmd .. " +" .. table.concat(config.tags, " +")
			end
			if config.priority then
				cmd = cmd .. " priority:" .. config.priority
			end
			vim.fn.system(cmd)
			print("Tarefa adicionada: " .. input)
		else
			print("Operação cancelada")
		end
	end)
end

-- Registrar atalho
vim.api.nvim_set_keymap("n", "<leader>tk", ":lua require'ntask'.add_task()<CR>", { noremap = true, silent = true })

return M
