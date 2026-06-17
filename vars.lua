-- Shared config variables. Require this module to access them.

local M = {}

-- App variables
M.terminal = "ghostty"
-- M.terminal = "alacritty"
M.editor = "nvim"
M.fileManager = "dolphin"
M.browser = "firefox-devedition"

-- Workspaces
M.workspaceCount = 4

-- Monitors
---@class MonitorConfig
---@field id string
---@field layout 'master'|'dwindle'|'scrolling'|'monocle'
---@field orientation 'horizontal'|'vertical'
---@field direction 'left'|'right'|'up'|'down'

---@type MonitorConfig[]
M.monitors = {
	{ id = "DP-3", layout = "master", orientation = "horizontal", direction = "right" },
	{ id = "HDMI-A-1", layout = "scrolling", orientation = "vertical", direction = "down" },
	{ id = "DP-1", layout = "master", orientation = "horizontal", direction = "left" },
}
-- TODO: 1 remove these, everything should use the new monitors array
M.monitor1 = "DP-3"
M.monitor2 = "HDMI-A-1"
M.monitor3 = "DP-1"

-- Resize amount for keyboard resizing
M.resizeAmount = 60

-- Utility functions
--- @param baseGap integer
--- @param aspectRatio number
--- @param orientation? 'horizontal'|'vertical'
--- @return HL.CssGap
M.aspectRatioGaps = function(baseGap, aspectRatio, orientation)
	orientation = orientation or "horizontal"
	return {
		left = orientation == "horizontal" and math.floor(baseGap * aspectRatio + 0.5) or baseGap,
		right = orientation == "horizontal" and math.floor(baseGap * aspectRatio + 0.5) or baseGap,
		top = orientation == "horizontal" and baseGap or math.floor(baseGap * aspectRatio + 0.5),
		bottom = orientation == "horizontal" and baseGap or math.floor(baseGap * aspectRatio + 0.5),
	}
end

--- @param direction 'left'|'right'|'up'|'down'
--- @return string
M.directionForScrolling = function(direction)
	return direction
end

--- @param direction 'left'|'right'|'up'|'down'
--- @return string
M.directionForMaster = function(direction)
	if direction == "up" then
		return "top"
	end
	if direction == "down" then
		return "bottom"
	end
	return direction
end

return M
