hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("xrandr --output DP-3 --primary") -- set primary monitor for xwayland apps (for games)
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("waywing")
	hl.exec_cmd("ghostty --initial-window=false --gtk-single-instance=true --quit-after-last-window-closed=false")

	hl.exec_cmd(vars.browser)
	-- hl.timer(function()
	--     hl.dispatch(hl.dsp.window.move({ window = , workspace = 1, follow = false }))
	-- end, { timeout = 2000, type = "oneshot" })

	hl.exec_cmd("obsidian")
	hl.timer(function()
		hl.dispatch(hl.dsp.window.move({ window = "class:obsidian", workspace = 2, follow = false }))
		hl.dispatch(hl.dsp.window.tag({ window = "class:obsidian", tag = "+crsmntr_pinned" }))
	end, { timeout = 2000, type = "oneshot" })

	hl.exec_cmd("Telegram")
	hl.timer(function()
		hl.dispatch(
			hl.dsp.window.move({ window = "class:org.telegram.desktop", workspace = "special:1", follow = false })
		)
	end, { timeout = 2000, type = "oneshot" })
end)

-- TODO: 2 move specific firefox windows: youtube to 3rd monitor, anime to 2nd monitor 2nd workspace, twitter to 2nd special
-- TODO: 2 pin some windows (obsidian + 3rd monitor firefox)
