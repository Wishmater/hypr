local M = {}

-- Helpers -------------------------------------------------------------------

local function monitorCount()
	return #vars.monitors
end

--- @param window HL.Window
--- @param tag    string
--- @return boolean
local function hasTag(window, tag)
	local tags = window.tags
	if type(tags) == "string" then
		for t in tags:gmatch("%S+") do
			if t == tag then
				return true
			end
		end
	elseif type(tags) == "table" then
		for _, t in ipairs(tags) do
			if t == tag then
				return true
			end
		end
	end
	return false
end

--- @param workspace HL.Workspace
--- @return string
local function specialName(workspace)
	return (workspace.name:gsub("^special:", ""))
end

-- Cross-monitor workspaces --------------------------------------------------

--- Returns the 1-based monitor index (in vars.monitors order) for a window's
--- workspace, or the focused monitor when no window is given.
--- @param window? HL.Window
--- @return integer|nil
M.crsmntrActiveMonitor = function(window)
	local activeWorkspace
	if window then
		activeWorkspace = window.workspace and window.workspace.id
	else
		local ws = hl.get_active_workspace()
		activeWorkspace = ws and ws.id
	end
	if not activeWorkspace then
		return nil
	end
	return ((activeWorkspace - 1) % monitorCount()) + 1
end

--- Switch all monitors to the target in-monitor workspace, moving pinned
--- windows along. The active monitor is focused last so it keeps focus.
--- @param target        integer
--- @param activeMonitor? integer
M.crsmntrWorkspace = function(target, activeMonitor)
	activeMonitor = activeMonitor or M.crsmntrActiveMonitor()

	for _, w in ipairs(hl.get_windows()) do
		if hasTag(w, "crsmntr_pinned") then
			M.crsmntrMoveToWorkspace(target, { silent = true, window = w })
		end
	end

	local offset = (target - 1) * monitorCount()
	for i = monitorCount(), 1, -1 do
		if i ~= activeMonitor then
			hl.dispatch(hl.dsp.focus({ workspace = offset + i }))
		end
	end
	hl.dispatch(hl.dsp.focus({ workspace = offset + activeMonitor }))
end

--- Move the active window (or the given window) to the target in-monitor
--- workspace on its monitor, optionally switching all monitors after.
--- @param target integer
--- @param opts?  { silent?: boolean, window?: HL.Window }
M.crsmntrMoveToWorkspace = function(target, opts)
	opts = opts or {}
	local silent = opts.silent or false
	local window = opts.window

	local activeMonitor
	if not silent or window then
		activeMonitor = M.crsmntrActiveMonitor(window)
	end

	if not window then
		hl.dispatch(hl.dsp.window.move({ workspace = "r~" .. target, follow = false }))
	else
		local workspace = (target - 1) * monitorCount() + activeMonitor
		hl.dispatch(hl.dsp.window.move({ workspace = workspace, window = window, follow = false }))
	end

	if not silent then
		M.crsmntrWorkspace(target, activeMonitor)
	end
end

-- Smart fullscreen ----------------------------------------------------------

--- Toggle/adjust fullscreen on the focused window, using maximize on special
--- workspaces and inverting the client state for reverse_client_fullscreen.
--- @param action? 'toggle'|'update'|'fullscreen'|'unfullscreen'
--- @param opts?   { internal?: boolean }
M.crsmntrFullscreen = function(action, opts)
	action = action or "toggle"
	opts = opts or {}

	local win = hl.get_active_window()
	if not win then
		return
	end

	local isFullscreen = win.fullscreen ~= 0
	local isSpecial = win.workspace and win.workspace.special or false
	local reverseClientFullscreen = hasTag(win, "reverse_client_fullscreen")

	local fullscreenState
	if action == "toggle" then
		if isFullscreen then
			fullscreenState = 0
		elseif isSpecial then
			fullscreenState = 1
		else
			fullscreenState = 2
		end
	elseif action == "update" then
		fullscreenState = win.fullscreen
	elseif action == "fullscreen" then
		fullscreenState = isSpecial and 1 or 2
	elseif action == "unfullscreen" then
		fullscreenState = 0
	else
		return
	end

	local fullscreenStateClient = 0
	if fullscreenState ~= 0 then
		fullscreenStateClient = opts.internal and 2 or 0
	end
	if reverseClientFullscreen then
		fullscreenStateClient = fullscreenStateClient == 0 and 2 or 0
	end

	if fullscreenState ~= win.fullscreen or fullscreenStateClient ~= win.fullscreen_client then
		hl.dispatch(hl.dsp.window.fullscreen_state({ internal = fullscreenState, client = fullscreenStateClient }))
	end
end

-- Special workspace ---------------------------------------------------------

--- Close the active special workspace if one is open, optionally only when it
--- has at most maxCount windows.
--- @param maxCount? integer
M.closeSpecialWorkspace = function(maxCount)
	local ws = hl.get_active_special_workspace()
	if not ws then
		return
	end

	if maxCount ~= nil and #hl.get_workspace_windows(ws) > maxCount then
		return
	end

	hl.dispatch(hl.dsp.workspace.toggle_special(specialName(ws)))
end

-- Cursor zoom ---------------------------------------------------------------

local MIN_ZOOM = 1.0
local MAX_ZOOM = 5.0
local STEP = 0.1

--- @param action 'in'|'out'|'reset'|'set'
--- @param value? number
M.hyprzoom = function(action, value)
	local current = tonumber(hl.get_config("cursor:zoom_factor")) or MIN_ZOOM
	local new

	if action == "in" then
		new = current * (1 + STEP)
		if new > MAX_ZOOM then
			new = MAX_ZOOM
		end
	elseif action == "out" then
		new = current / (1 + STEP)
		if new < MIN_ZOOM then
			new = MIN_ZOOM
		end
	elseif action == "reset" then
		new = 1.0
	elseif action == "set" then
		new = tonumber(value)
		if not new then
			return
		end
		if new < MIN_ZOOM then
			new = MIN_ZOOM
		elseif new > MAX_ZOOM then
			new = MAX_ZOOM
		end
	else
		return
	end

	hl.config({ cursor = { zoom_factor = new } })
end

return M
