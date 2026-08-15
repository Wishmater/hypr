vars.setConfig({
	general = {
		layout = "master",

		no_focus_fallback = true, -- avoid inconsistent focus jumps when no clear target is in the direction
	},

	misc = {
		close_special_on_empty = true,
		-- TODO: 2 this is annoying specifically with telegram calls while gaming, maybe we can just fix telegram call popup window to open somewhere else, or set this option to ignore new window (0) while gaming
		on_focus_under_fullscreen = 2, -- unmaximize

		-- TODO: 3 it would be nice to enable this, if there was a way to exclude ghostty and firefox, or even better, make it re-track
		-- this is good, but the issue is that with single-process that spawn multiple windows, like firefox or ghostty,
		-- it causes new windows opened way after the first one to track initial workspace which is very weird
		initial_workspace_tracking = 0,

		-- this is really good with neovide, but super annoying everywhere else,
		-- prefer using swallow script that uses groups for a similar effect
		enable_swallow = false,
		swallow_regex = "^(Alacritty|com\\.mitchellh\\.ghostty)$",
	},

	binds = {
		hide_special_on_workspace_change = true,
		-- infer by length, instead of history, to avoid unpredictability
		focus_preferred_method = 1,
		-- focus on last active window when switching to workspace; this is better because it ensures
		-- the mouse is inside the focus window, otherwise there are weird cases where the last focused
		-- window will be re-focused, and the cursor will be outside of it
		workspace_center_on = 1,
		movefocus_cycles_groupfirst = false,
	},

	master = {
		-- -- orientation is set with workspace rules on a per-monitor basis
		-- orientation = "top", -- placement of master window

		-- mfact = 0.71875 -- size of the master window, trying to get a 1x2 slave panel (1920-540)/1920
		mfact = 0.68359375, -- size of the master window, trying to get a 9x16 slave panel

		-- this could be good if we could set it to only some workspaces, but it hard breaks secondary monitors
		always_keep_position = true, -- master doesn't take whole screen when it's alone

		new_status = "inherit", -- slave
		new_on_active = "before",

		slave_count_for_center_master = 0,
		-- -- this is overall pretty buggy, better to implement with workspace rules
		-- -- it has a breaking bug where window dragging will be borked, try on new release
		-- orientation = "center",
		-- center_master_fallback = "right",
		-- slave_count_for_center_master = 6,
	},

	dwindle = {
		preserve_split = true, -- You probably want this
	},

	scrolling = {
		fullscreen_on_one_column = false,
		-- column_width = 0.68359375,
		-- TODO: 3 we should use this for vertical monitors and the other for horizontal. Not possible to make the distinction right now.
		column_width = 0.3140625,
		explicit_column_widths = "0.3140625, 0.5, 0.68359375, 1.0",
		focus_fit_method = 0, -- center
		-- follow_min_visible = 0,
	},

	group = {
		auto_group = false,
		insert_after_current = false,
		drag_into_group = 2, -- only on groupbar
		merge_groups_on_drag = false,
		merge_groups_on_groupbar = true,

		-- TODO: 3 maybe change colors for groups ??
		col = {
			border_active = vars.baseConfig.general.col.active_border,
			border_inactive = vars.baseConfig.general.col.inactive_border,
			border_locked_active = vars.baseConfig.general.col.active_border,
			border_locked_inactive = vars.baseConfig.general.col.inactive_border,
		},

		groupbar = {
			-- enabled = false,
			font_size = 14,
			font_weight_active = 500,
			font_weight_inactive = 500,
			text_color = vars.colors.dragonGray,
			text_color_inactive = vars.colors.dragonGray3,

			height = 22,
			gradients = true, -- indicator is set as background of the full height of groupbar
			gradient_rounding = 20,
			gradient_rounding_power = 4,
			gradient_round_only_edges = false,
			gaps_in = 4,
			gaps_out = 2,
			indicator_height = 0,
			rounding = 0,
			scrolling = false,
			blur = true,
			keep_upper_gap = false,

			col = {
				active = vars.colors.winterBlue .. "dd",
				inactive = vars.colors.dragonBlack0 .. "aa",
				-- locked_active
				-- locked_inactive
			},
		},
	},
})
