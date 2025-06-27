local M = {}

-- Default configuration
local config = {
  enter_key = "m",
}

-- Function to check if mouse mode is active
local function is_mouse_mode()
  return vim.o.mouse ~= ""
end

-- Function to exit mouse mode
local function exit_mouse_mode()
  if is_mouse_mode() then
    vim.opt.mouse = ""
    pcall(vim.api.nvim_del_augroup_by_name, "MouserAutoDisable")
  end
end

-- Function to enter mouse mode
local function enter_mouse_mode()
  vim.opt.mouse = "a"
  
  -- Exit on mode changes or cursor movement (but allow mouse events)
  local group = vim.api.nvim_create_augroup("MouserAutoDisable", { clear = true })
  
  -- Exit on mode change
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = exit_mouse_mode,
  })
  
  -- Exit on cursor movement (which happens after commands like 10j complete)
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = exit_mouse_mode,
  })
  
  -- Exit on text changes
  vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
    group = group,
    callback = exit_mouse_mode,
  })
end

-- Setup function
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  
  vim.opt.mouse = ""
  
  vim.keymap.set("n", config.enter_key, enter_mouse_mode, { desc = "Enter mouse mode" })
  
  _G.mouser_status = function()
    return is_mouse_mode() and "MOUSE" or ""
  end
end

M.enter = enter_mouse_mode
M.exit = exit_mouse_mode
M.is_active = is_mouse_mode

return M
