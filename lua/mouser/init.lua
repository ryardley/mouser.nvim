local M = {}

-- Default configuration
local config = {
  trigger_key = "m",
  mouse_events = { "CursorMoved", "CursorMovedI", "InsertEnter", "CmdlineEnter" },
}

-- Function to temporarily enable mouse until next keypress
local function temp_mouse_enable()
  vim.opt.mouse = "a"

  -- Set up one-time autocmd to disable mouse on next keypress
  local group = vim.api.nvim_create_augroup("TempMouse", { clear = true })
  vim.api.nvim_create_autocmd(config.mouse_events, {
    group = group,
    callback = function()
      vim.opt.mouse = ""
      vim.api.nvim_del_augroup_by_id(group)
    end,
    once = true,
  })
end

-- Setup function
function M.setup(opts)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", config, opts or {})

  -- Disable mouse by default
  vim.opt.mouse = ""

  -- Set up the key mapping
  vim.keymap.set("n", config.trigger_key, temp_mouse_enable, {
    desc = "Temporarily enable mouse until next keypress",
  })
end

-- Export the temp enable function for manual use
M.enable = temp_mouse_enable

return M
