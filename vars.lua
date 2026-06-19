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
	{
		id = "DP-1",
		layout = "master",
		orientation = "horizontal",
		direction = "left",
		centerSingleWindow = false,
		centerTooManyWindows = false,
	},
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
---@field centerSingleWindow boolean?
---@field centerTooManyWindows boolean?

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

--- Takes a partial config, applies it, and returns a callback that reverts
--- the touched keys to their pre-call values from baseConfig.
--- @param newConfig HL.ConfigOpt
--- @return fun()
M.tempConfig = function(newConfig)
	local revertConfig = {}
	local function snapshot(src, dst, partial, path)
		for key, val in pairs(partial) do
			local fullPath = path and (path .. ":" .. key) or key
			if type(val) == "table" then
				dst[key] = {}
				snapshot(type(src[key]) == "table" and src[key] or {}, dst[key], val, fullPath)
			else
				local current = src[key]
				if current == nil then
					current = hl.get_config(fullPath)
				end
				dst[key] = current
			end
		end
	end
	snapshot(M.baseConfig, revertConfig, newConfig, nil)

	hl.config(newConfig)

	return function()
		hl.config(revertConfig)
	end
end

local uglymodeRevert = nil
function M.toggleUglymode()
	if uglymodeRevert then
		hl.notification.create({
			text = "Uglymode off",
			timeout = 3000,
			color = M.colors.dragonBlue2,
		})
		uglymodeRevert()
		uglymodeRevert = nil
		return
	end

	hl.notification.create({
		text = "Uglymode on",
		timeout = 3000,
		color = M.colors.dragonBlue2,
	})
	uglymodeRevert = M.tempConfig({
		general = {
			gaps_in = 0,
			gaps_out = 0,
			border_size = 0,
		},
		animations = {
			enabled = false,
		},
		decoration = {
			shadow = { enabled = false },
			blur = { enabled = false },
			rounding = 0,
		},
		group = {
			groupbar = { enabled = false },
		},
		render = {
			xp_mode = true,
		},
	})
end

-- Colors from Kanagawa theme
M.colors = {
	-- Bg Shades
	sumiInk0 = "#16161D",
	sumiInk1 = "#181820",
	sumiInk2 = "#1a1a22",
	sumiInk3 = "#1F1F28",
	sumiInk4 = "#2A2A37",
	sumiInk5 = "#363646",
	sumiInk6 = "#54546D", -- fg

	-- Popup and Floats
	waveBlue1 = "#223249",
	waveBlue2 = "#2D4F67",

	-- Diff and Git
	winterGreen = "#2B3328",
	winterYellow = "#49443C",
	winterRed = "#43242B",
	winterBlue = "#252535",
	autumnGreen = "#76946A",
	autumnRed = "#C34043",
	autumnYellow = "#DCA561",

	-- Diag
	samuraiRed = "#E82424",
	roninYellow = "#FF9E3B",
	waveAqua1 = "#6A9589",
	dragonBlue = "#658594",

	-- Fg and Comments
	oldWhite = "#C8C093",
	fujiWhite = "#DCD7BA",
	fujiGray = "#727169",

	oniViolet = "#957FB8",
	oniViolet2 = "#b8b4d0",
	crystalBlue = "#7E9CD8",
	springViolet1 = "#938AA9",
	springViolet2 = "#9CABCA",
	springBlue = "#7FB4CA",
	lightBlue = "#A3D4D5",
	waveAqua2 = "#7AA89F",

	springGreen = "#98BB6C",
	boatYellow1 = "#938056",
	boatYellow2 = "#C0A36E",
	carpYellow = "#E6C384",

	sakuraPink = "#D27E99",
	waveRed = "#E46876",
	peachRed = "#FF5D62",
	surimiOrange = "#FFA066",
	katanaGray = "#717C7C",

	dragonBlack0 = "#0d0c0c",
	dragonBlack1 = "#12120f",
	dragonBlack2 = "#1D1C19",
	dragonBlack3 = "#181616",
	dragonBlack4 = "#282727",
	dragonBlack5 = "#393836",
	dragonBlack6 = "#625e5a",

	dragonWhite = "#c5c9c5",
	dragonGreen = "#87a987",
	dragonGreen2 = "#8a9a7b",
	dragonPink = "#a292a3",
	dragonOrange = "#b6927b",
	dragonOrange2 = "#b98d7b",
	dragonGray = "#a6a69c",
	dragonGray2 = "#9e9b93",
	dragonGray3 = "#7a8382",
	dragonBlue2 = "#8ba4b0",
	dragonViolet = "#8992a7",
	dragonRed = "#c4746e",
	dragonAqua = "#8ea4a2",
	dragonAsh = "#737c73",
	dragonTeal = "#949fb5",
	dragonYellow = "#c4b28a",

	lotusInk1 = "#545464",
	lotusInk2 = "#43436c",
	lotusGray = "#dcd7ba",
	lotusGray2 = "#716e61",
	lotusGray3 = "#8a8980",
	lotusWhite0 = "#d5cea3",
	lotusWhite1 = "#dcd5ac",
	lotusWhite2 = "#e5ddb0",
	lotusWhite3 = "#f2ecbc",
	lotusWhite4 = "#e7dba0",
	lotusWhite5 = "#e4d794",
	lotusViolet1 = "#a09cac",
	lotusViolet2 = "#766b90",
	lotusViolet3 = "#c9cbd1",
	lotusViolet4 = "#624c83",
	lotusBlue1 = "#c7d7e0",
	lotusBlue2 = "#b5cbd2",
	lotusBlue3 = "#9fb5c9",
	lotusBlue4 = "#4d699b",
	lotusBlue5 = "#5d57a3",
	lotusGreen = "#6f894e",
	lotusGreen2 = "#6e915f",
	lotusGreen3 = "#b7d0ae",
	lotusPink = "#b35b79",
	lotusOrange = "#cc6d00",
	lotusOrange2 = "#e98a00",
	lotusYellow = "#77713f",
	lotusYellow2 = "#836f4a",
	lotusYellow3 = "#de9800",
	lotusYellow4 = "#f9d791",
	lotusRed = "#c84053",
	lotusRed2 = "#d7474b",
	lotusRed3 = "#e82424",
	lotusRed4 = "#d9a594",
	lotusAqua = "#597b75",
	lotusAqua2 = "#5e857a",
	lotusTeal1 = "#4e8ca2",
	lotusTeal2 = "#6693bf",
	lotusTeal3 = "#5a7785",
	lotusCyan = "#d7e3d8",
}

return M
