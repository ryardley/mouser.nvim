# mouser.nvim

A Neovim plugin for temporary mouse enabling.

Plugins like hardtime whilst excellent for forcing you to use efficient mouse movements are a little too much for me. Occasionally I want to surgically use the mouse to land my cursor and orient myself as I enter neovim but then I want the mouse to get out of my way.

This plugin creates a simple mode for the mouse so that you can turn it on and scroll or click and then it will be turned off straight afterwards.

This is my first neovim plugin so all feedback and pull requests welcome.

## Installation

Using lazy.nvim:

```lua
return {
  "ryardley/mouser.nvim",
  config = true,
}
```

Use with lualine add as a dependency and use the mouser_status global var.

```lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "ryardley/mouser.nvim" }, -- Add this line
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin",
      },
      sections = {
        lualine_x = {
          _G.mouser_status,
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    })
  end,
}
```

## Usage

With the plugin installed the mouse will be disabled until you press the `m` key in normal mode. You can then scroll or click to a position. Whatever you do after that should escape mouse ode and disable the mouse.

## Configuration

You can set your own mouse key like this:

```lua
return {
  "ryardley/mouser.nvim",
  config = true,
  keys = {
    { "<leader>m", desc = "Enter mouse mode" },
  },
}
```
