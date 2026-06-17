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
--- @param baseGap integer|HL.CssGap
--- @param aspectRatio number
--- @param orientation? 'horizontal'|'vertical'
--- @return HL.CssGap
M.aspectRatioGaps = function(baseGap, aspectRatio, orientation)
	orientation = orientation or "horizontal"
	local function scale(v)
		return v and math.floor(v * aspectRatio + 0.5) or nil
	end
	if type(baseGap) == "number" then
		local wide = scale(baseGap)
		local narrow = baseGap
		return {
			left = orientation == "horizontal" and wide or narrow,
			right = orientation == "horizontal" and wide or narrow,
			top = orientation == "horizontal" and narrow or wide,
			bottom = orientation == "horizontal" and narrow or wide,
		}
	end
	return {
		left = orientation == "horizontal" and scale(baseGap.left) or baseGap.left,
		right = orientation == "horizontal" and scale(baseGap.right) or baseGap.right,
		top = orientation == "horizontal" and baseGap.top or scale(baseGap.top),
		bottom = orientation == "horizontal" and baseGap.bottom or scale(baseGap.bottom),
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

-- Config accumulation
local function deep_merge(target, source)
	for key, value in pairs(source) do
		if type(value) == "table" and type(target[key]) == "table" then
			deep_merge(target[key], value)
		else
			target[key] = value
		end
	end
end

--- @type HL.ConfigOpt
M.baseConfig = {}

function M.set_config(tbl)
	deep_merge(M.baseConfig, tbl)
end

return M
