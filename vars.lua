local M = {}

-- App variables
M.terminal = "ghostty" -- alacritty
M.editor = "nvim"
M.fileManager = "dolphin"
M.browser = "firefox-devedition"

-- Workspaces
M.workspaceCount = 4

-- Monitors

---@type MonitorConfig[]
M.monitors = {
	{ id = "DP-3", layout = "master", orientation = "horizontal", direction = "right" },
	{ id = "HDMI-A-1", layout = "scrolling", orientation = "vertical", direction = "down" },
	{ id = "DP-1", layout = "master", orientation = "horizontal", direction = "left" },
}

-- Resize amount for keyboard resizing
M.resizeAmount = 60

-------------------------------------------------------------------------------
-- Utility functions / definitions
-------------------------------------------------------------------------------

---@class MonitorConfig
---@field id string
---@field layout 'master'|'dwindle'|'scrolling'|'monocle'
---@field orientation 'horizontal'|'vertical'
---@field direction 'left'|'right'|'up'|'down'

--- @param baseGap integer|HL.CssGap
--- @param aspectRatio number
--- @param orientation? 'horizontal'|'vertical'
--- @param scale? number
--- @return HL.CssGap
M.aspectRatioGaps = function(baseGap, aspectRatio, orientation, scale)
	orientation = orientation or "horizontal"
	scale = scale or 1
	local function wideVal(v)
		return v and math.floor(v * aspectRatio * scale + 0.5) or nil
	end
	local function narrowVal(v)
		return v and math.floor(v * scale + 0.5) or nil
	end
	if type(baseGap) == "number" then
		return {
			left = orientation == "horizontal" and wideVal(baseGap) or narrowVal(baseGap),
			right = orientation == "horizontal" and wideVal(baseGap) or narrowVal(baseGap),
			top = orientation == "horizontal" and narrowVal(baseGap) or wideVal(baseGap),
			bottom = orientation == "horizontal" and narrowVal(baseGap) or wideVal(baseGap),
		}
	end
	return {
		left = orientation == "horizontal" and wideVal(baseGap.left) or narrowVal(baseGap.left),
		right = orientation == "horizontal" and wideVal(baseGap.right) or narrowVal(baseGap.right),
		top = orientation == "horizontal" and narrowVal(baseGap.top) or wideVal(baseGap.top),
		bottom = orientation == "horizontal" and narrowVal(baseGap.bottom) or wideVal(baseGap.bottom),
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
local function deepMerge(target, source)
	for key, value in pairs(source) do
		if type(value) == "table" and type(target[key]) == "table" then
			deepMerge(target[key], value)
		else
			target[key] = value
		end
	end
end

--- @type HL.ConfigOpt
M.baseConfig = {}

function M.setConfig(tbl)
	deepMerge(M.baseConfig, tbl)
end

return M
