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
    -- Trigger custom event to clean up key handler
    vim.api.nvim_exec_autocmds("User", { pattern = "MouserExit" })
    -- Clear autocmds
    pcall(vim.api.nvim_del_augroup_by_name, "MouserAutoDisable")
  end
end

-- Function to enter mouse mode
local function enter_mouse_mode()
  vim.opt.mouse = "a"
  
  -- Exit on any mode change
  local group = vim.api.nvim_create_augroup("MouserAutoDisable", { clear = true })
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = exit_mouse_mode,
  })
  
  -- Exit on any keypress using vim.on_key, but ignore mouse events
  local key_handler = vim.on_key(function(key)
    -- Ignore mouse events (scroll wheel, clicks, etc.)
    if key ~= "" and not key:match("^<.*Mouse.*>") and not key:match("^<ScrollWheel") then
      exit_mouse_mode()
    end
  end)
  
  -- Store the handler to remove it later
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MouserExit",
    callback = function()
      if key_handler then
        vim.on_key(nil, key_handler)
      end
    end,
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
