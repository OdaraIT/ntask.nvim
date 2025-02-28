.SUFFIXES:

# Default target: runs all main tasks
all: deps lint test

# Install dependencies
deps:
	@echo "Installing dependencies..."
	@sudo apt update
	@sudo apt install -y taskwarrior

# Install Neovim plugins
install_plugins:
	@echo "Installing Neovim plugins..."
	@mkdir -p ~/.config/nvim
	@echo "call plug#begin('~/.vim/plugged')" > ~/.config/nvim/init.vim
	@echo "Plug 'nvim-lua/plenary.nvim'" >> ~/.config/nvim/init.vim
	@echo "Plug 'nvim-telescope/telescope.nvim'" >> ~/.config/nvim/init.vim
	@echo "call plug#end()" >> ~/.config/nvim/init.vim
	@nvim --headless +PlugInstall +qall

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	@nvim --headless -c "PlenaryBustedDirectory lua/ntask/tests { minimal = true }" -c "q"

# Run linting (assuming stylua is used for formatting Lua code)
lint:
	@echo "Running lint checks..."
	@stylua .

# Clean up temporary/generated files
clean:
	@echo "Cleaning up..."
	@rm -rf ~/.vim/plugged

# Continuous Integration task
ci: deps install_plugins lint test

