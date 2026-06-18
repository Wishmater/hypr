-- https://wiki.hyprland.org/Configuring/Variables/#input

vars.setConfig({
	input = {
		-- Keyboard
		kb_layout = "us,es",
		kb_options = "grp:win_space_toggle,caps:swapescape",
		numlock_by_default = true,

		-- Mouse
		force_no_accel = true,
		follow_mouse = 1, -- auto-focus window under mouse

		-- Disable this if we find a way to warp the mouse instead of changing the focus in these cases,
		-- the thing that should be avoided at all costs is the focus ever being where mouse isn't.
		focus_on_close = 1, -- focus window under mouse when current one closes
		float_switch_override_focus = 2, -- focus window under mouse when switching float/tile (doesn't seem to work)
	},

	cursor = {
		default_monitor = vars.monitors[1].id,
		inactive_timeout = 1,
		hide_on_key_press = true,
		zoom_detached_camera = false,

		-- -- This would be coll, but it's annoying in fullscreen apps, especially games
		-- hotspot_padding = vars.baseConfig.general.gaps_out,
	},

	misc = {
		middle_click_paste = false,
		key_press_enables_dpms = true,
	},
})
