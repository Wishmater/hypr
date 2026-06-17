-- Shared config variables. Require this module to access them.

local M = {}

-- App variables
M.terminal = "ghostty"
-- M.terminal = "alacritty"
M.editor = "nvim"
M.fileManager = "dolphin"
M.browser = "firefox-devedition"

-- Monitor names
M.monitor1 = "DP-3"
M.monitor2 = "HDMI-A-1"
M.monitor3 = "DP-1"

-- Resize amount for keyboard resizing
M.resizeAmount = 60

-- Utility numbers and multipliers
--- @param baseGap integer
--- @param aspectRatio number
--- @param horizontal boolean?
--- @return HL.CssGap
M.aspectRatioGaps = function(baseGap, aspectRatio, horizontal)
	horizontal = horizontal or true
	return {
		left = horizontal and math.floor(baseGap * aspectRatio + 0.5) or baseGap,
		right = horizontal and math.floor(baseGap * aspectRatio + 0.5) or baseGap,
		top = horizontal and baseGap or math.floor(baseGap * aspectRatio + 0.5),
		bottom = horizontal and baseGap or math.floor(baseGap * aspectRatio + 0.5),
	}
end

return M
