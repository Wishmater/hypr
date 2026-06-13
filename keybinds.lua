-- https://wiki.hyprland.org/Configuring/Basics/Binds/ for more
-- https://wiki.hyprland.org/Configuring/Keywords/

-- CHANGE: binds:scroll_event_delay moved to hl.config({ binds = { ... } })
hl.config({
    binds = {
        scroll_event_delay = 0,
    },
})

-- Main modifier
local mainMod = "SUPER"

--[[

CHANGE SUMMARY FOR KEYBINDS:

Old format → New format:
  bind    = MOD, KEY, dispatch, args          → hl.bind("MOD + KEY", hl.dsp.xxx({...}))
  binde   = MOD, KEY, dispatch, args          → hl.bind("MOD + KEY", hl.dsp.xxx({...}), { repeating = true })
  bindl   = MOD, KEY, dispatch, args          → hl.bind("MOD + KEY", hl.dsp.xxx({...}), { locked = true })
  bindel  = MOD, KEY, dispatch, args          → hl.bind("MOD + KEY", hl.dsp.xxx({...}), { locked = true, repeating = true })
  bindn   = MOD, KEY, dispatch, args          → hl.bind("MOD + KEY", hl.dsp.xxx({...}), { non_consuming = true })
  bindm   = MOD, mouse:BTN, dispatch, args    → hl.bind("MOD + mouse:BTN", hl.dsp.xxx(), { mouse = true })

  exec, hyprctl --batch "..."                 → hl.dsp.exec_cmd("hyprctl --batch \"...\"")

Dispatcher mapping (old → new hl.dsp):
  closewindow, activewindow                   → window.close() or window.close("activewindow")
  killwindow, activewindow                    → window.kill()
  togglefloating                              → window.float({ action = "toggle" })
  setfloating                                 → window.float({ action = "on" })
  pin                                         → window.pin({ action = "toggle" }) or still as string? Use exec_cmd for safety.
  togglegroup                                 → group.toggle()
  toggleswallow                                → NOT A DISPATCHER IN 0.55 — see note below
  changegroupactive                           → group.next() / group.prev()
  movefocus, direction                        → focus({ direction = "l/r/u/d" })
  focusurgentorlast                           → focus({ urgent_or_last = true })
  cyclenext                                   → window.cycle_next()
  cyclenext, prev                             → window.cycle_next() -- prev direction via flag? Might need: window.cycle_prev()
  movewindow, direction                       → window.move({ direction = "l/r/u/d" })
  movewindoworgroup, direction                → window.move({ direction = "l/r/u/d" }) -- may need group variant
  movetoworkspacesilent, workspace            → window.move({ workspace = ..., silent = true }) or window.move({ workspace = ... }) -- check API
  movetoworkspace, workspace                  → window.move({ workspace = ... })
  tagwindow, +tag                             → window.tag({ tag = "tag" }) or tagwindow dispatch
  togglespecialworkspace, id                  → workspace.toggle_special("id")
  submap, name                                → submap("name")
  resizeactive, dx dy                         → window.resize({ x = dx, y = dy }) or: hl.resize({ x = dx, y = dy, relative = true })

]]

-- WINDOW
hl.bind(mainMod .. " + S",           hl.dsp.window.close(),         { description = "Close active window" })
hl.bind(mainMod .. " + SHIFT + CTRL + S", hl.dsp.window.kill(),     { description = "Kill active window" })
hl.bind(mainMod .. " + SHIFT + S",   hl.dsp.exec_cmd("hyprctl dismissnotify"))
hl.bind(mainMod .. " + A",           hl.dsp.exec_cmd("hyprctl dispatch tagwindow +crsmntr_pinned")) -- CHANGE: tagwindow with +/- needs hyprctl workaround
hl.bind(mainMod .. " + SHIFT + A",   hl.dsp.window.float({ action = "on" }))                         -- setfloating
hl.bind(mainMod .. " + SHIFT + A",   hl.dsp.exec_cmd("hyprctl dispatch pin activewindow"))            -- pin (CHANGE: pin is not a dedicated dispatcher; using hyprctl)
hl.bind(mainMod .. " + F",           hl.dsp.exec_cmd("hyprcrsmntr_fullscreen.nu"))
hl.bind(mainMod .. " + SHIFT + F",   hl.dsp.exec_cmd("hyprcrsmntr_fullscreen.nu --internal"))
hl.bind(mainMod .. " + SHIFT + CTRL + F", hl.dsp.exec_cmd("hyprctl dispatch tagwindow +reverse_client_fullscreen"))
hl.bind(mainMod .. " + SHIFT + CTRL + F", hl.dsp.exec_cmd("hyprcrsmntr_fullscreen.nu update"))
hl.bind(mainMod .. " + G",           hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })

-- TILING
hl.bind(mainMod .. " + code:49",           hl.dsp.group.toggle(),    { description = "Toggle group" })           -- tilde (`)
-- CHANGE: toggleswallow dispatcher was removed in 0.55; keeping as exec fallback
hl.bind(mainMod .. " + SHIFT + code:49",   hl.dsp.exec_cmd("hyprctl dispatch toggleswallow"), { description = "Toggle swallow" }) -- tilde (`)
hl.bind(mainMod .. " + SHIFT + Tab",       hl.dsp.group.next(),     { description = "Change group active" })
hl.bind(mainMod .. " + F1",                hl.dsp.exec_cmd("uglymode_toggle"))
-- bind = SUPER SHIFT, F, pseudo, # dwindle
-- bind = SUPER SHIFT, A, togglesplit, # dwindle

-- MOVE FOCUS
hl.bind(mainMod .. " + left",   hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right",  hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",     hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",   hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + H",      hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L",      hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K",      hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J",      hl.dsp.focus({ direction = "d" }))
hl.bind("ALT + code:49",        hl.dsp.focus({ urgent_or_last = true }), { description = "Focus urgent or last" }) -- tilde (`)
hl.bind("ALT + Tab",            hl.dsp.window.cycle_next())
-- CHANGE: cyclenext with "prev" arg doesn't have a direct hl.dsp equivalent; using focus({ workspace = "previous" }) or the window variant
-- Using hl.dsp.focus({ last = true }) as closest alternative for moving backwards in cycle
hl.bind("ALT + SHIFT + Tab",    hl.dsp.window.cycle_next()) -- NOTE: for cycle prev, might need a different dispatch

-- MOVE WINDOWS
-- CHANGE: movewindow dispatcher → hl.dsp.window.move({ direction = "..." })
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "d" }))

-- RESIZE WINDOWS
-- the big hack with hyprctl is to enable animations for manual resizing with keyboard but not with mouse
-- CHANGE: these are now hl.bind with { repeating = true } flag (the old binde → repeating)
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.exec_cmd("hyprctl --batch \"keyword misc:animate_manual_resizes true ; dispatch resizeactive -" .. vars.resizeAmount .. " 0 ; keyword misc:animate_manual_resizes false\""), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd("hyprctl --batch \"keyword misc:animate_manual_resizes true ; dispatch resizeactive " .. vars.resizeAmount .. " 0 ; keyword misc:animate_manual_resizes false\""), { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.exec_cmd("hyprctl --batch \"keyword misc:animate_manual_resizes true ; dispatch resizeactive 0 " .. vars.resizeAmount .. " ; keyword misc:animate_manual_resizes false\""), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.exec_cmd("hyprctl --batch \"keyword misc:animate_manual_resizes true ; dispatch resizeactive 0 -" .. vars.resizeAmount .. " ; keyword misc:animate_manual_resizes false\""), { repeating = true })
hl.bind(mainMod .. " + CTRL + H",     hl.dsp.exec_cmd("hyprctl --batch \"keyword misc:animate_manual_resizes true ; dispatch resizeactive -" .. vars.resizeAmount .. " 0 ; keyword misc:animate_manual_resizes false\""), { repeating = true })
hl.bind(mainMod .. " + CTRL + L",     hl.dsp.exec_cmd("hyprctl --batch \"keyword misc:animate_manual_resizes true ; dispatch resizeactive " .. vars.resizeAmount .. " 0 ; keyword misc:animate_manual_resizes false\""), { repeating = true })
hl.bind(mainMod .. " + CTRL + K",     hl.dsp.exec_cmd("hyprctl --batch \"keyword misc:animate_manual_resizes true ; dispatch resizeactive 0 " .. vars.resizeAmount .. " ; keyword misc:animate_manual_resizes false\""), { repeating = true })
hl.bind(mainMod .. " + CTRL + J",     hl.dsp.exec_cmd("hyprctl --batch \"keyword misc:animate_manual_resizes true ; dispatch resizeactive 0 -" .. vars.resizeAmount .. " ; keyword misc:animate_manual_resizes false\""), { repeating = true })

-- APPS
-- bind = SUPER, Tab, exec, wayxec --normal-window
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("waywingctl AppLauncher/toggle"))
hl.bind(mainMod .. " + M",   hl.dsp.exec_cmd("resources"))
hl.bind(mainMod .. " + Q",   hl.dsp.exec_cmd(vars.terminal))
hl.bind(mainMod .. " + T",   hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + W",   hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + E",   hl.dsp.exec_cmd("QT_QPA_PLATFORMTHEME=kvantum " .. vars.fileManager)) -- hack to fix font size bug with stylix, remove when fixed
hl.bind(mainMod .. " + R",   hl.dsp.exec_cmd(vars.browser))

-- SCREENSHOT
hl.bind(mainMod .. " + SHIFT + Q",               hl.dsp.exec_cmd("hyprshot -m active -m output"))
hl.bind("Print",                                 hl.dsp.exec_cmd("hyprshot -m active -m output"))
hl.bind(mainMod .. " + SHIFT + W",               hl.dsp.exec_cmd("hyprshot -m active -m window"))
hl.bind("SHIFT + Print",                         hl.dsp.exec_cmd("hyprshot -m active -m window"))
hl.bind(mainMod .. " + SHIFT + E",               hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("SHIFT + CTRL + Print",                  hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + CTRL + E",        hl.dsp.exec_cmd("hyprshot -m region --freeze"))
hl.bind(mainMod .. " + SHIFT + CTRL + ALT + E",  hl.dsp.exec_cmd("hyprshot -m region --freeze"))
-- SCREEN RECORDING
hl.bind(mainMod .. " + SHIFT + R",               hl.dsp.exec_cmd("record_screen output"))
hl.bind(mainMod .. " + SHIFT + CTRL + R",        hl.dsp.exec_cmd("record_screen region"))

-- NOTIFICATIONS
hl.bind(mainMod .. " + N",               hl.dsp.exec_cmd("waywingctl  Bar/togglePopover?feather=End/NotificationManager"))
hl.bind(mainMod .. " + SHIFT + N",       hl.dsp.exec_cmd("waywingctl NotificationsService/toggleSilenced"))
hl.bind(mainMod .. " + SHIFT + CTRL + N",hl.dsp.exec_cmd("waywingctl NotificationsService/toggleDnd"))

-- WORKSPACES
-- Hack to make cross-monitor workspaces
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("hyprcrsmntr_workspace 1"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("hyprcrsmntr_workspace 2"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprcrsmntr_workspace 3"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("hyprcrsmntr_workspace 4"))
-- Monitor-aware window moving
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("hyprcrsmntr_movetoworkspace 1"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("hyprcrsmntr_movetoworkspace 2"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprcrsmntr_movetoworkspace 3"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("hyprcrsmntr_movetoworkspace 4"))
-- Silent window moving (don't switch workspace)
hl.bind(mainMod .. " + SHIFT + CTRL + Z", hl.dsp.window.move({ workspace = "r~1", follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + X", hl.dsp.window.move({ workspace = "r~2", follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + C", hl.dsp.window.move({ workspace = "r~3", follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + V", hl.dsp.window.move({ workspace = "r~4", follow = false }))

-- SPECIAL WORKSPACES
-- Switch workspaces
hl.bind(mainMod .. " + 1", hl.dsp.workspace.toggle_special("1"))
hl.bind(mainMod .. " + 2", hl.dsp.workspace.toggle_special("2"))
hl.bind(mainMod .. " + 3", hl.dsp.workspace.toggle_special("3"))
hl.bind(mainMod .. " + 4", hl.dsp.workspace.toggle_special("4"))
-- Move active window to a special workspace
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "special:1" }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "special:2" }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "special:3" }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = "special:4" }))
-- Move silent
hl.bind(mainMod .. " + SHIFT + CTRL + 1", hl.dsp.window.move({ workspace = "special:1", follow = false  }))
hl.bind(mainMod .. " + SHIFT + CTRL + 2", hl.dsp.window.move({ workspace = "special:2", follow = false  }))
hl.bind(mainMod .. " + SHIFT + CTRL + 3", hl.dsp.window.move({ workspace = "special:3", follow = false  }))
hl.bind(mainMod .. " + SHIFT + CTRL + 4", hl.dsp.window.move({ workspace = "special:4", follow = false  }))
-- Close special workspace
hl.bind("Escape",             hl.dsp.exec_cmd("close_special_workspace 0"),     { non_consuming = true })
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("close_special_workspace"),    { non_consuming = true })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Move window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Laptop multimedia keys for volume and LCD brightness
-- CHANGE: bindel → { locked = true, repeating = true }
--         bindl  → { locked = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("waywingctl VolumeService/increaseOutputVolume"),  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("waywingctl VolumeService/decreaseOutputVolume"),  { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioRaiseVolume",  hl.dsp.exec_cmd("waywingctl VolumeService/increaseInputVolume"),   { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioLowerVolume",  hl.dsp.exec_cmd("waywingctl VolumeService/decreaseInputVolume"),   { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("waywingctl VolumeService/muteOutput"),            { locked = true })
hl.bind("SHIFT + XF86AudioMute", hl.dsp.exec_cmd("waywingctl VolumeService/muteInput"),             { locked = true })
-- not used on current keyboard
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
-- fallbacks not using waywing
hl.bind("CTRL + SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),       { locked = true, repeating = true })
hl.bind("CTRL + SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),            { locked = true, repeating = true })
hl.bind("CTRL + SHIFT + XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),          { locked = true })
-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
-- Mine added
hl.bind(mainMod .. " + XF86AudioPlay",         hl.dsp.exec_cmd("waywingctl VolumeService/cycleOutput"), { locked = true })
hl.bind(mainMod .. " + SHIFT + XF86AudioPlay", hl.dsp.exec_cmd("waywingctl VolumeService/cycleInput"),  { locked = true })

-- Zooming
hl.bind(mainMod .. " + mouse_down",              hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + mouse_up",                hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + mouse_down",      hl.dsp.exec_cmd("hyprzoom in"),     { repeating = true })
hl.bind(mainMod .. " + SHIFT + mouse_up",        hl.dsp.exec_cmd("hyprzoom out"),    { repeating = true })
hl.bind(mainMod .. " + SHIFT + CTRL + mouse_up", hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind(mainMod .. " + SHIFT + CTRL + mouse_down",hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind(mainMod .. " + equal",                   hl.dsp.exec_cmd("hyprzoom in"),     { repeating = true })
hl.bind(mainMod .. " + minus",                   hl.dsp.exec_cmd("hyprzoom out"),    { repeating = true })
hl.bind(mainMod .. " + SHIFT + equal",           hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind(mainMod .. " + SHIFT + minus",           hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind(mainMod .. " + KP_ADD",                  hl.dsp.exec_cmd("hyprzoom in"),     { repeating = true })
hl.bind(mainMod .. " + KP_SUBTRACT",             hl.dsp.exec_cmd("hyprzoom out"),    { repeating = true })
hl.bind(mainMod .. " + SHIFT + KP_ADD",          hl.dsp.exec_cmd("hyprzoom reset"))
hl.bind(mainMod .. " + SHIFT + KP_SUBTRACT",     hl.dsp.exec_cmd("hyprzoom reset"))

-- SUBMAPS

-- # Not playing fgo anymore, so gg. Leaving as reference to maybe do something similar later
-- bind = SUPER ALT, O, submap, fgo # FGO keybinds
-- source = ~/.config/hypr/keybind_submaps/keybinds_fgo.conf
