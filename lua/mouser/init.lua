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

-- Function to enter mouse mode
local function enter_mouse_mode()
	vim.opt.mouse = "a"
	vim.notify("MOUSE MODE", vim.log.levels.INFO, { title = "Mouser" })
end

-- Function to exit mouse mode
local function exit_mouse_mode()
	if is_mouse_mode() then
		vim.opt.mouse = ""
		vim.notify("Normal Mode", vim.log.levels.INFO, { title = "Mouser" })
	end
end

-- Global escape handler
local function handle_escape()
	if is_mouse_mode() then
		exit_mouse_mode()
	else
		-- Pass through normal Esc behavior
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	end
end

-- Setup function
function M.setup(opts)
	-- Merge user config with defaults
	config = vim.tbl_deep_extend("force", config, opts or {})

	-- Disable mouse by default
	vim.opt.mouse = ""

	-- Set up the key mappings globally
	vim.keymap.set("n", config.enter_key, enter_mouse_mode, {
		desc = "Enter mouse mode",
	})

	vim.keymap.set("n", config.exit_key, handle_escape, {
		desc = "Exit mouse mode or normal Esc",
	})

	-- Optional: Add to statusline
	_G.mouser_status = function()
		return is_mouse_mode() and "MOUSE" or ""
	end
end

-- Export functions
M.enter = enter_mouse_mode
M.exit = exit_mouse_mode
M.is_active = is_mouse_mode

return M
