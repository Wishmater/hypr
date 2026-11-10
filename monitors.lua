hl.monitor({
	output = vars.monitors[1].id,
	mode = "2560x1440@180",
	position = "0x0",
	scale = 1.07, -- logical size becomes 2400x1350
	bitdepth = 10,
	cm = "hdr",
	supports_wide_color = true,
	supports_hdr = true,
	sdrbrightness = 1.00, -- 1.0 makes it match HDR-native apps
	sdrsaturation = 1.00, -- 1.0 makes it match HDR-native apps
	sdr_min_luminance = 0.005, -- 0.005 makes blacks true blacks, good for OLED, according to hyprland config
	sdr_max_luminance = 203, -- 203 makes it match HDR-native apps, lower brightness in-monitor if too bright

	-- these are monitor-specific, advertised by the monitor, but according to the clanker
	-- these values are closer to reality than manufacturer's exaggerated values
	min_luminance = 0.0005,
	max_luminance = 400,
	max_avg_luminance = 200,
})

hl.monitor({
	output = vars.monitors[2].id,
	mode = "1920x1080@60",
	position = "-1080x-190", -- -1080x-420 is centered, but it's a bit different to match physical monitor
	scale = 1,
	transform = 1,
	reserved = { bottom = 165 }, -- phisically center windows on the monitor, which is not aligned vertically with the main monitor
})

hl.monitor({
	output = vars.monitors[3].id,
	mode = "1920x1080@60",
	position = "2400x40",
	scale = 1,
})

vars.setConfig({
	misc = {
		vrr = 2, -- Variable Refresh Rate (Adaptive Sync) -- 2 = only fullscreen
		render_unfocused_fps = 15, -- default 15
	},

	render = {
		keep_unmodified_copy = 2, -- default 2, only hdr

		-- HDR options
		cm_auto_hdr = 0, -- Auto-switch to HDR in fullscreen when needed. Default 1. 0 - off, 1 - switch to cm, hdr, 2 - switch to cm, hdredid.

		-- -- this causes severe visual glitches (parts of the screen going black), especially on fullscreened xwayland apps with popups
		-- direct_scanout = 1, -- apparently can improve latency for fullscreen windows, but sometimes cause glitches, so if it happens, disable it
		-- this also apparently requires fullscreen apps to support hdr when it's on or they look over-saturated
	},

	quirks = {
		prefer_hdr = 1,
	},

	xwayland = {
		force_zero_scaling = true, -- makes xwayland apps (mostly games) ignore scale on monitor and run always at native resolution
	},
})
