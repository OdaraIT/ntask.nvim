# ntask.nvim

ntask.nvim is a Neovim plugin that integrates **Taskwarrior** with Neovim, allowing you to manage tasks efficiently without leaving your editor.

## 🚀 Features

- ✅ Create tasks directly from Neovim.
- ✅ List pending tasks filtered by project.
- ✅ Mark tasks as **done**.
- ✅ Edit and delete tasks easily.
- ✅ Integrated with **Telescope.nvim** for interactive task selection.
- ✅ `:checkhealth ntask.nvim` support for verifying dependencies.

## 📦 Installation

### **Using packer.nvim**

```lua
use {
  'OdaraIT/ntask.nvim',
  requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    require('ntask')
  end
}
```

### **Using vim-plug**

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'OdaraIT/ntask.nvim'
```

### **Using lazy.nvim**

```lua
{
  'OdaraIT/ntask.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    require('ntask')
  end
}
```

## ⚙️ Commands

| Command       | Description                       |
| ------------- | --------------------------------- |
| `:TaskAdd`    | Add a new task                    |
| `:TaskList`   | List tasks of the current project |
| `:TaskDone`   | Mark a task as completed          |
| `:TaskDelete` | Delete a task (with confirmation) |
| `:TaskEdit`   | Edit task details                 |

## 🔧 Project Configuration (`.ntask.yml`)

ntask.nvim allows you to define project-specific defaults using a `.ntask.yml` file in the root of your project. This file can specify default values for:

Example `.ntask.yml`:

```yaml
project: "MyProject"
tags:
  - dev
  - feature
priority: "M"
duedate: "+3d"
```

### Supported Fields:

- **`project`**: Default project name for new tasks.
- **`tags`**: List of tags automatically added to new tasks.
- **`priority`**: Default priority (`H`, `M`, or `L`).
- **`duedate`**: Default due date (e.g., `+3d` for 3 days from today).

If no `.ntask.yml` is found, default values will be used.

## 🛠 Dependencies

Make sure you have the following installed:

- **[Taskwarrior](https://taskwarrior.org/)** - Required for task management.
- **[Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Used for task selection.
- **[Plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - Utility functions used by many Neovim plugins.

## 🏥 Health Check

Run the following command to verify if all dependencies are correctly installed:

```vim
:checkhealth ntask.nvim
```

## 📜 License

This project is licensed under the MIT License.

---

Now you can manage your tasks inside Neovim effortlessly! 🚀
