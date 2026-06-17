vars.setConfig({
	general = {
		gaps_in = 3, -- used to be 4, this will be increased for larges side on each monitor, so it should be a bit lower than expected average
		gaps_out = 12, -- used to be 12, this will be increased for larges side on each monitor, so it should be a bit lower than expected average

		border_size = 2,

		col = {
			inactive_border = vars.colors.dragonBlack5,
			active_border = {
				angle = 120,
				colors = {
					vars.colors.dragonTeal,
					vars.colors.dragonBlue2,
					vars.colors.dragonAqua,
					vars.colors.dragonGreen,
				},
			},
		},
	},

	decoration = {
		rounding = 12,
		rounding_power = 4,

		active_opacity = 1.0,
		fullscreen_opacity = 1.0,
		inactive_opacity = 1.0,

		dim_inactive = true,
		dim_strength = 0.1,
		dim_special = 0.4,
		-- dim_special = 0 -- SET FOR TRANSPARENT SPECIAL WORKSPACE

		shadow = {
			enabled = true,
			range = 8,
			render_power = 0,
			offset = { 2, 2 }, -- CHANGE: vec2 values use table { x, y } instead of space-separated
			color = "rgba(0d0c0caa)", -- dragonBlack0
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,

			vibrancy = 0.1696,

			special = true, -- note: expensive
			-- special = false -- SET FOR TRANSPARENT SPECIAL WORKSPACE
		},
	},

	animations = {
		enabled = true,
	},

	misc = {
		disable_splash_rendering = false,
		col = {
			splash = vars.colors.dragonWhite, -- splash text color
		},
	},

	ecosystem = {
		no_donation_nag = true,
	},
})

-- CHANGE: bezier curves are now defined with hl.curve() instead of a single bezier keyword
-- The format changed from "bezier = name,x1,y1,x2,y2" to hl.curve("name", { type = "bezier", points = { {x1,y1}, {x2,y2} } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })

-- CHANGE: animation definitions changed from "animation = leaf, enabled, speed, curve, [style]"
-- to hl.animation({ leaf = "...", enabled = true, speed = N, bezier|spring = "...", style = "..." })
-- The speed values may need recalibration for 0.55 — these are the originals.
hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "almostLinear", style = "popin 87%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1, bezier = "almostLinear" })
-- fadeSwitch
-- fadeShadows
-- fadeDim
-- fadeLayers
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, bezier = "almostLinear" })
-- fadePopups
-- fadePopupsIn
-- fadePopupsOut
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle", enabled = false, speed = 0 }) -- speed = 0 disables
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "almostLinear", style = "fade" })
hl.animation({
	leaf = "workspacesIn",
	enabled = true,
	speed = 1.5,
	bezier = "easeOutQuint",
	style = "slidefadevert 33%",
})
hl.animation({
	leaf = "workspacesOut",
	enabled = true,
	speed = 1.5,
	bezier = "easeOutQuint",
	style = "slidefadevert 33%",
})
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1.5, bezier = "quick", style = "slidefadevert" })
hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 1.5,
	bezier = "quick",
	style = "slidefadevert 33%",
})
hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 1.2,
	bezier = "almostLinear",
	style = "slidefadevert 66%",
})
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 0.8, bezier = "almostLinear" })
