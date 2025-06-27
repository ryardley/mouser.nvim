local M = {}

-- Function to enter mouse mode
local function enter_mouse_mode()
  vim.opt.mouse = "a"
end

-- Function to exit mouse mode  
local function exit_mouse_mode()
  vim.opt.mouse = ""
end

-- Setup function
function M.setup(opts)
  opts = opts or {}
  local enter_key = opts.enter_key or "m"
  local exit_key = opts.exit_key or "<Esc>"
  
  vim.opt.mouse = ""
  
  vim.keymap.set("n", enter_key, enter_mouse_mode, { desc = "Enter mouse mode" })
  vim.keymap.set("n", exit_key, exit_mouse_mode, { desc = "Exit mouse mode" })
  
  -- Create highlight group for mouse status
  vim.api.nvim_set_hl(0, "MouserStatus", { bg = "white", fg = "black", bold = true })
  
  _G.mouser_status = function()
    if vim.o.mouse ~= "" then
      return "%#MouserStatus# MOUSE %*"
    else
      return ""
    end
  end
end

return M
