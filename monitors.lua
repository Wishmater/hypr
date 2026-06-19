hl.monitor({
	output = vars.monitors[1].id,
	mode = "1920x1080@180",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	cm = "hdr",
	supports_wide_color = true,
	supports_hdr = true,
	sdrbrightness = 1.50,
	sdrsaturation = 1.05,
	sdr_min_luminance = 0.005,
	sdr_max_luminance = 75,
})

hl.monitor({
	output = vars.monitors[2].id,
	mode = "1920x1080@60",
	position = "-1080x-330", -- -1080x-420 is centered, but it's a bit different to match physical monitor
	scale = 1,
	transform = 1,
})

hl.monitor({
	output = vars.monitors[3].id,
	mode = "1920x1080@60",
	position = "1920x0",
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
		-- cm_fs_passthrough = 1 -- Passthrough color settings for fullscreen apps when possible. 0 - off, 1 - always, 2 - hdr only

		-- this causes severe visual glitches (parts of the screen going black), especially on fullscreened xwayland apps with popups
		-- direct_scanout = 1, -- apparently can improve latency for fullscreen windows, but sometimes cause glitches, so if it happens, disable it
		-- this also apparently requires fullscreen apps to support hdr when it's on or they look over-saturated
	},

	quirks = {
		prefer_hdr = 1,
	},
})
