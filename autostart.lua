--[[
CHANGE SUMMARY FOR AUTOSTART:

Old exec-once format → New Lua format:
  exec-once = [workspace X silent] $browser → hl.on("hyprland.start", function() ... end) + hl.exec_cmd()
  exec-once = command                     → hl.on("hyprland.start", function() hl.exec_cmd("command") end)

The "[workspace X silent]" prefix had no direct Lua equivalent for exec_cmd.
As a workaround, we define window rules that match the initial class/title to
move windows to their target workspace silently.

Alternatively, we use hl.exec_cmd with the command as normal and add a timer-based
dispatch to move the window.
]]

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("xrandr --output DP-3 --primary") -- set primary monitor for xwayland apps (for games)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("waywing")
    hl.exec_cmd("ghostty --initial-window=false --gtk-single-instance=true --quit-after-last-window-closed=false")

    --[[
    CHANGE: The old "[workspace X silent]" exec-once prefix has no direct Lua equivalent.
    Previously, exec-once = [workspace 1 silent] $browser would launch the browser,
    then move its window to workspace 1 without switching to that workspace.

    In Lua (0.55+), this must be handled differently. Two approaches:
      1. Fire and forget: just launch the app; rely on window rules to place it
      2. Use hl.timer to dispatch window.move after a delay

    Using approach 2 with a timer delay to let the window appear first.
    These will need verification after updating to 0.55.
    ]]

    -- TODO: 1 this is BS

    -- Launch browser and move to workspace 1
    hl.exec_cmd(vars.browser)
    hl.timer(function()
        hl.dispatch(hl.dsp.window.move({ workspace = 1, follow = false }))
    end, { timeout = 2000, type = "oneshot" })

    -- Launch obsidian and move to workspace 2
    hl.exec_cmd("obsidian")
    hl.timer(function()
        hl.dispatch(hl.dsp.window.move({ workspace = 2, follow = false }))
    end, { timeout = 2000, type = "oneshot" })

    -- Launch Telegram and move to special:1
    hl.exec_cmd("Telegram")
    hl.timer(function()
        hl.dispatch(hl.dsp.window.move({ workspace = "special:1", follow = false }))
    end, { timeout = 2000, type = "oneshot" })

    -- Launch zapzap and move to special:1
    hl.exec_cmd("zapzap")
    hl.timer(function()
        hl.dispatch(hl.dsp.window.move({ workspace = "special:1", follow = false }))
    end, { timeout = 2000, type = "oneshot" })
end)

-- TODO: 2 move specific firefox windows: youtube to 3rd monitor, anime to 2nd monitor 2nd workspace, twitter to 2nd special
-- TODO: 2 pin some windows (obsidian + 3rd monitor firefox)
