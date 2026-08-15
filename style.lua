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
		rounding = 20,
		rounding_power = 10,

		active_opacity = 1.0,
		fullscreen_opacity = 1.0,
		inactive_opacity = 0.996,

		dim_inactive = true,
		dim_strength = 0.33,
		dim_special = 0.5,
		dim_around = 0.5,

		shadow = {
			enabled = true,
			range = 8,
			render_power = 3, -- default 3
			offset = { 2, 2 },
			color = vars.colors.dragonBlack0 .. "aa",
			color_inactive = vars.colors.dragonBlack2 .. "aa",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,

			special = true, -- note: expensive
			-- popups = true, -- this is cool but only makes sense if active_opacity<1
		},
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

-- hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
-- hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
-- hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
-- hl.curve("easeOut", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("quick", { type = "spring", mass = 1, stiffness = 2000, dampening = 80 }) -- no bounce, complete fast
hl.curve("normal", { type = "spring", mass = 1, stiffness = 1500, dampening = 70 }) -- a tiny bit bouncy (could be 67 dampening to make it bouncier)
hl.curve("flashy", { type = "spring", mass = 1, stiffness = 1500, dampening = 80 }) -- no bounce, long ease-out

hl.animation({ leaf = "global", enabled = true, speed = 3, spring = "normal" })
do
	hl.animation({ leaf = "windows", enabled = true, speed = 3, spring = "normal" })
	do
		hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, spring = "flashy", style = "popin 87%" })
		hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, spring = "quick", style = "popin 87%" })
		hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, spring = "normal" })
	end
	hl.animation({ leaf = "layers", enabled = true, speed = 3, spring = "normal" })
	do
		hl.animation({ leaf = "layersIn", enabled = true, speed = 3, spring = "flashy", style = "fade" })
		hl.animation({ leaf = "layersOut", enabled = true, speed = 1, spring = "quick", style = "fade" })
	end
	hl.animation({ leaf = "fade", enabled = true, speed = 2, spring = "quick" })
	do
		hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, spring = "quick" })
		hl.animation({ leaf = "fadeOut", enabled = true, speed = 1, spring = "quick" })
		hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 5, spring = "flashy" })
		hl.animation({ leaf = "fadeShadow", enabled = true, speed = 5, spring = "flashy" })
		hl.animation({ leaf = "fadeDim", enabled = true, speed = 5, spring = "flashy" })
		hl.animation({ leaf = "fadeLayers", enabled = true, speed = 2, spring = "normal" })
		do
			hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, spring = "flashy" })
			hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, spring = "quick" })
		end
		hl.animation({ leaf = "fadePopups", enabled = true, speed = 2, spring = "quick" })
		do
			hl.animation({ leaf = "fadePopupsIn", enabled = true, speed = 2, spring = "quick" })
			hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = 1, spring = "quick" })
		end
		hl.animation({ leaf = "fadeDpms", enabled = true, speed = 5, spring = "flashy" })
	end
	hl.animation({ leaf = "border", enabled = true, speed = 5, spring = "flashy" })
	hl.animation({ leaf = "borderangle", enabled = false })
	-- hl.animation({ leaf = "shadowangle", enabled = false })
	hl.animation({ leaf = "workspaces", enabled = true, speed = 3, spring = "normal", style = "fade" })
	do
		hl.animation({
			leaf = "workspacesIn",
			enabled = true,
			speed = 1.5,
			spring = "quick",
			style = "slidefadevert 16%",
		})
		hl.animation({
			leaf = "workspacesOut",
			enabled = true,
			speed = 1.5,
			spring = "quick",
			style = "fade",
		})
		hl.animation({
			leaf = "specialWorkspace",
			enabled = true,
			speed = 1.5,
			spring = "normal",
			style = "fade",
		})
		do
			hl.animation({
				leaf = "specialWorkspaceIn",
				enabled = true,
				speed = 1.5,
				spring = "normal",
				style = "slidefadevert 33%",
			})
			hl.animation({
				leaf = "specialWorkspaceOut",
				enabled = true,
				speed = 1.2,
				spring = "quick",
				style = "slidefadevert 66%",
			})
		end
	end
	hl.animation({ leaf = "zoomFactor", enabled = true, speed = 0.8, spring = "quick" })
	hl.animation({ leaf = "monitorAdded", enabled = true, speed = 5, spring = "flashy" })
end
