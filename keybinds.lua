-- https://wiki.hyprland.org/Configuring/Basics/Binds/ for more
-- https://wiki.hyprland.org/Configuring/Keywords/

-- CHANGE: binds:scroll_event_delay moved to hl.config({ binds = { ... } })
hl.config({
	binds = {
		scroll_event_delay = 0,
	},
})

-- WINDOW
hl.bind("SUPER + S", hl.dsp.window.close(), { description = "Close active window" })
hl.bind("SUPER + SHIFT + CTRL + S", hl.dsp.window.kill(), { description = "Kill active window" })
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("waywingctl dismiss_notifications"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("hyprctl dispatch tagwindow +crsmntr_pinned")) -- CHANGE: tagwindow with +/- needs hyprctl workaround
hl.bind("SUPER + SHIFT + A", hl.dsp.window.float({ action = "on" })) -- setfloating
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("hyprctl dispatch pin activewindow")) -- pin (CHANGE: pin is not a dedicated dispatcher; using hyprctl)
hl.bind("SUPER + F", hl.dsp.exec_cmd("hyprcrsmntr_fullscreen.nu"))
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("hyprcrsmntr_fullscreen.nu --internal"))
hl.bind("SUPER + SHIFT + CTRL + F", hl.dsp.exec_cmd("hyprctl dispatch tagwindow +reverse_client_fullscreen"))
hl.bind("SUPER + SHIFT + CTRL + F", hl.dsp.exec_cmd("hyprcrsmntr_fullscreen.nu update"))
hl.bind("SUPER + G", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })

-- TILING
hl.bind("SUPER + code:49", hl.dsp.group.toggle(), { description = "Toggle group" }) -- tilde (`)
-- CHANGE: toggleswallow dispatcher was removed in 0.55; keeping as exec fallback
hl.bind("SUPER + SHIFT + code:49", hl.dsp.window.toggle_swallow(), { description = "Toggle swallow" }) -- tilde (`)
hl.bind("SUPER + SHIFT + Tab", hl.dsp.group.next(), { description = "Change group active" })
hl.bind("SUPER + F1", hl.dsp.exec_cmd("uglymode_toggle"))
-- bind = SUPER SHIFT, F, pseudo, # dwindle
-- bind = SUPER SHIFT, A, togglesplit, # dwindle

-- MOVE FOCUS
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("ALT + code:49", hl.dsp.focus({ urgent_or_last = true }), { description = "Focus urgent or last" }) -- tilde (`)
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
-- CHANGE: cyclenext with "prev" arg doesn't have a direct hl.dsp equivalent; using focus({ workspace = "previous" }) or the window variant
-- Using hl.dsp.focus({ last = true }) as closest alternative for moving backwards in cycle
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next()) -- NOTE: for cycle prev, might need a different dispatch

-- MOVE WINDOWS
-- CHANGE: movewindow dispatcher → hl.dsp.window.move({ direction = "..." })
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- RESIZE WINDOWS
-- the big hack with hyprctl is to enable animations for manual resizing with keyboard but not with mouse
-- CHANGE: these are now hl.bind with { repeating = true } flag (the old binde → repeating)
hl.bind(
	"SUPER + CTRL + left",
	hl.dsp.exec_cmd(
		'hyprctl --batch "keyword misc:animate_manual_resizes true ; dispatch resizeactive -'
			.. vars.resizeAmount
			.. ' 0 ; keyword misc:animate_manual_resizes false"'
	),
	{ repeating = true }
)
hl.bind(
	"SUPER + CTRL + right",
	hl.dsp.exec_cmd(
		'hyprctl --batch "keyword misc:animate_manual_resizes true ; dispatch resizeactive '
			.. vars.resizeAmount
			.. ' 0 ; keyword misc:animate_manual_resizes false"'
	),
	{ repeating = true }
)
hl.bind(
	"SUPER + CTRL + up",
	hl.dsp.exec_cmd(
		'hyprctl --batch "keyword misc:animate_manual_resizes true ; dispatch resizeactive 0 '
			.. vars.resizeAmount
			.. ' ; keyword misc:animate_manual_resizes false"'
	),
	{ repeating = true }
)
hl.bind(
	"SUPER + CTRL + down",
	hl.dsp.exec_cmd(
		'hyprctl --batch "keyword misc:animate_manual_resizes true ; dispatch resizeactive 0 -'
			.. vars.resizeAmount
			.. ' ; keyword misc:animate_manual_resizes false"'
	),
	{ repeating = true }
)
hl.bind(
	"SUPER + CTRL + H",
	hl.dsp.exec_cmd(
		'hyprctl --batch "keyword misc:animate_manual_resizes true ; dispatch resizeactive -'
			.. vars.resizeAmount
			.. ' 0 ; keyword misc:animate_manual_resizes false"'
	),
	{ repeating = true }
)
hl.bind(
	"SUPER + CTRL + L",
	hl.dsp.exec_cmd(
		'hyprctl --batch "keyword misc:animate_manual_resizes true ; dispatch resizeactive '
			.. vars.resizeAmount
			.. ' 0 ; keyword misc:animate_manual_resizes false"'
	),
	{ repeating = true }
)
hl.bind(
	"SUPER + CTRL + K",
	hl.dsp.exec_cmd(
		'hyprctl --batch "keyword misc:animate_manual_resizes true ; dispatch resizeactive 0 '
			.. vars.resizeAmount
			.. ' ; keyword misc:animate_manual_resizes false"'
	),
	{ repeating = true }
)
hl.bind(
	"SUPER + CTRL + J",
	hl.dsp.exec_cmd(
		'hyprctl --batch "keyword misc:animate_manual_resizes true ; dispatch resizeactive 0 -'
			.. vars.resizeAmount
			.. ' ; keyword misc:animate_manual_resizes false"'
	),
	{ repeating = true }
)

-- APPS
-- bind = SUPER, Tab, exec, wayxec --normal-window
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("waywingctl AppLauncher/toggle"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("resources"))
hl.bind("SUPER + Q", hl.dsp.exec_cmd(vars.terminal))
hl.bind("SUPER + T", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("obsidian"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("QT_QPA_PLATFORMTHEME=kvantum " .. vars.fileManager)) -- hack to fix font size bug with stylix, remove when fixed
hl.bind("SUPER + R", hl.dsp.exec_cmd(vars.browser))

-- SCREENSHOT
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("hyprshot -m active -m output"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m active -m output"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("hyprshot -m active -m window"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m active -m window"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("SHIFT + CTRL + Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("SUPER + SHIFT + CTRL + E", hl.dsp.exec_cmd("hyprshot -m region --freeze"))
hl.bind("SUPER + SHIFT + CTRL + ALT + E", hl.dsp.exec_cmd("hyprshot -m region --freeze"))
-- SCREEN RECORDING
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("record_screen output"))
hl.bind("SUPER + SHIFT + CTRL + R", hl.dsp.exec_cmd("record_screen region"))

-- NOTIFICATIONS
hl.bind("SUPER + N", hl.dsp.exec_cmd("waywingctl  Bar/togglePopover?feather=End/NotificationManager"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("waywingctl NotificationsService/toggleSilenced"))
hl.bind("SUPER + SHIFT + CTRL + N", hl.dsp.exec_cmd("waywingctl NotificationsService/toggleDnd"))

-- WORKSPACES
-- Hack to make cross-monitor workspaces
hl.bind("SUPER + Z", hl.dsp.exec_cmd("hyprcrsmntr_workspace 1"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("hyprcrsmntr_workspace 2"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("hyprcrsmntr_workspace 3"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("hyprcrsmntr_workspace 4"))
-- Monitor-aware window moving
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("hyprcrsmntr_movetoworkspace 1"))
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("hyprcrsmntr_movetoworkspace 2"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprcrsmntr_movetoworkspace 3"))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("hyprcrsmntr_movetoworkspace 4"))
-- Silent window moving (don't switch workspace)
hl.bind("SUPER + SHIFT + CTRL + Z", hl.dsp.window.move({ workspace = "r~1", follow = false }))
hl.bind("SUPER + SHIFT + CTRL + X", hl.dsp.window.move({ workspace = "r~2", follow = false }))
hl.bind("SUPER + SHIFT + CTRL + C", hl.dsp.window.move({ workspace = "r~3", follow = false }))
hl.bind("SUPER + SHIFT + CTRL + V", hl.dsp.window.move({ workspace = "r~4", follow = false }))

-- SPECIAL WORKSPACES
-- Switch workspaces
hl.bind("SUPER + 1", hl.dsp.workspace.toggle_special("1"))
hl.bind("SUPER + 2", hl.dsp.workspace.toggle_special("2"))
hl.bind("SUPER + 3", hl.dsp.workspace.toggle_special("3"))
hl.bind("SUPER + 4", hl.dsp.workspace.toggle_special("4"))
-- Move active window to a special workspace
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "special:1" }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "special:2" }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "special:3" }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "special:4" }))
-- Move silent
hl.bind("SUPER + SHIFT + CTRL + 1", hl.dsp.window.move({ workspace = "special:1", follow = false }))
hl.bind("SUPER + SHIFT + CTRL + 2", hl.dsp.window.move({ workspace = "special:2", follow = false }))
hl.bind("SUPER + SHIFT + CTRL + 3", hl.dsp.window.move({ workspace = "special:3", follow = false }))
hl.bind("SUPER + SHIFT + CTRL + 4", hl.dsp.window.move({ workspace = "special:4", follow = false }))
-- Close special workspace
hl.bind("Escape", hl.dsp.exec_cmd("close_special_workspace 0"), { non_consuming = true })
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("close_special_workspace"), { non_consuming = true })

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Laptop multimedia keys for volume and LCD brightness
-- CHANGE: bindel → { locked = true, repeating = true }
--         bindl  → { locked = true }
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("waywingctl VolumeService/increaseOutputVolume"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("waywingctl VolumeService/decreaseOutputVolume"),
	{ locked = true, repeating = true }
)
hl.bind(
	"SHIFT + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("waywingctl VolumeService/increaseInputVolume"),
	{ locked = true, repeating = true }
)
hl.bind(
	"SHIFT + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("waywingctl VolumeService/decreaseInputVolume"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("waywingctl VolumeService/muteOutput"), { locked = true })
hl.bind("SHIFT + XF86AudioMute", hl.dsp.exec_cmd("waywingctl VolumeService/muteInput"), { locked = true })
-- not used on current keyboard
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
-- fallbacks not using waywing
hl.bind(
	"CTRL + SHIFT + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"CTRL + SHIFT + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"CTRL + SHIFT + XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true }
)
-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
-- Mine added
hl.bind("SUPER + XF86AudioPlay", hl.dsp.exec_cmd("waywingctl VolumeService/cycleOutput"), { locked = true })
hl.bind("SUPER + SHIFT + XF86AudioPlay", hl.dsp.exec_cmd("waywingctl VolumeService/cycleInput"), { locked = true })

-- Zooming
hl.bind("SUPER + mouse_down", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.exec_cmd("hyprzoom in"), { repeating = true })
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.exec_cmd("hyprzoom out"), { repeating = true })
hl.bind("SUPER + SHIFT + CTRL + mouse_up", hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind("SUPER + SHIFT + CTRL + mouse_down", hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind("SUPER + equal", hl.dsp.exec_cmd("hyprzoom in"), { repeating = true })
hl.bind("SUPER + minus", hl.dsp.exec_cmd("hyprzoom out"), { repeating = true })
hl.bind("SUPER + SHIFT + equal", hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind("SUPER + SHIFT + minus", hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind("SUPER + KP_ADD", hl.dsp.exec_cmd("hyprzoom in"), { repeating = true })
hl.bind("SUPER + KP_SUBTRACT", hl.dsp.exec_cmd("hyprzoom out"), { repeating = true })
hl.bind("SUPER + SHIFT + KP_ADD", hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind("SUPER + SHIFT + KP_SUBTRACT", hl.dsp.exec_cmd("hyprzoom reset"))

-- SUBMAPS

-- # Not playing fgo anymore, so gg. Leaving as reference to maybe do something similar later
-- bind = SUPER ALT, O, submap, fgo # FGO keybinds
-- source = ~/.config/hypr/keybind_submaps/keybinds_fgo.conf
