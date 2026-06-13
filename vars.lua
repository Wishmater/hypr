-- Shared config variables. Require this module to access them.

local M = {}

-- App variables
M.terminal    = "ghostty"
-- M.terminal = "alacritty"
M.editor      = "nvim"
M.fileManager = "dolphin"
M.browser     = "firefox-devedition"

-- Monitor names
M.monitor1 = "DP-3"
M.monitor2 = "HDMI-A-1"
M.monitor3 = "DP-1"

-- Resize amount for keyboard resizing
M.resizeAmount = 60

return M
