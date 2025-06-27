local M = {}

-- Default configuration
local config = {
  enter_key = "m",
  exit_key = "<Esc>",
}

-- Function to check if mouse mode is active
local function is_mouse_mode()
  return vim.o.mouse ~= ""
end

-- Function to exit mouse mode
local function exit_mouse_mode()
  if is_mouse_mode() then
    vim.opt.mouse = ""
    vim.notify("Normal Mode", vim.log.levels.INFO, { title = "Mouser" })
    -- Clear autocmds
    pcall(vim.api.nvim_del_augroup_by_name, "MouserAutoDisable")
  end
end

-- Function to enter mouse mode
local function enter_mouse_mode()
  vim.opt.mouse = "a"
  vim.notify("MOUSE MODE", vim.log.levels.INFO, { title = "Mouser" })

  -- Exit on any mode change or common movement keys
  local group = vim.api.nvim_create_augroup("MouserAutoDisable", { clear = true })
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = exit_mouse_mode,
  })

  -- Map common movement keys to exit
  local keys = { "h", "j", "k", "l", "w", "b", "e", "0", "$", "gg", "G" }
  for _, key in ipairs(keys) do
    vim.keymap.set("n", key, function()
      exit_mouse_mode()
      vim.api.nvim_feedkeys(key, "n", false)
    end, { buffer = true })
  end
end

-- Global escape handler
local function handle_escape()
  if is_mouse_mode() then
    exit_mouse_mode()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end

-- Setup function
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  vim.opt.mouse = ""

  vim.keymap.set("n", config.enter_key, enter_mouse_mode, { desc = "Enter mouse mode" })
  vim.keymap.set("n", config.exit_key, handle_escape, { desc = "Exit mouse mode or normal Esc" })

  _G.mouser_status = function()
    return is_mouse_mode() and "MOUSE" or ""
  end
end

M.enter = enter_mouse_mode
M.exit = exit_mouse_mode
M.is_active = is_mouse_mode

return M
