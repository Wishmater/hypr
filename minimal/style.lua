vars.setConfig({
	general = {
		gaps_in = 3, -- used to be 4, this will be increased for larges side on each monitor, so it should be a bit lower than expected average
		gaps_out = 12, -- used to be 12, this will be increased for larges side on each monitor, so it should be a bit lower than expected average
		border_size = 0,
	},

	misc = {
		font_family = "JetBrainsMono Nerd Font",
		background_color = "rgb(0d0c0c)",

		-- Disable wallpaper / bullshit
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},

	ecosystem = {
		no_donation_nag = true,
	},

	decoration = {
		rounding = 0,

		active_opacity = 1.0,
		fullscreen_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = false,
	},

	render = {
		xp_mode = true,
	},
})

hl.window_rule({
	name = "force-rgbx",
	force_rgbx = true,
	match = { class = ".*" },
})
