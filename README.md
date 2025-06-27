# mouser.nvim

A Neovim plugin for temporary mouse enabling.

Sometimes using the mouse is a quick way to jump to a spot in the file if you have just come to a window or you can't quickly locate your cursor. However having the mouse enabled once you have your baring in neovim is problematic especially when working on a laptop with a trackpad. This plugin creates a simple mode for the mouse so that you can turn it on and scroll or click and then it will be turned off straight afterwards.

This is my first neovim plugin. Pull requests welcome.

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
	dependencies = { "ryardley/mouser.nvim" },
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
