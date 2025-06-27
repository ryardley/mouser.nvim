# mouser.nvim

A Neovim plugin for temporary mouse enabling.

## Installation

Using lazy.nvim:

```lua
{
  "ryardley/mouser.nvim",
  config = function()
    require("mouser").setup()
  end,
  keys = {
    { "m", desc = "Temporarily enable mouse" },
  },
}
```
