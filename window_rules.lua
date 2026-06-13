--[[
CHANGE SUMMARY FOR WINDOW RULES:

Old syntax → New Lua syntax:
  windowrule {                            hl.window_rule({
    name = ...,                             name = "...",
    suppress_event = maximize,              suppress_event = "maximize",
    match:class = .*                        match = { class = ".*" },

    no_focus = on,                          no_focus = true,
    match:class = ^$                        match = { class = "^$" },
    match:xwayland = 1                      match = { xwayland = true },

    no_dim = on                             no_dim = true,
    match:fullscreen = 1                    match = { fullscreen = true },

    opacity = 0.67 override                 opacity = 0.67, opacity_override = true,
    match:tag = dragged                     match = { tag = "dragged" },

    tag = +popup                            tag = "+popup",
    match:float = 1                         match = { float = true },

    tag = -popup                            tag = "-popup",

    float = on                              float = true,
    monitor = $monitor1                     monitor = vars.monitor1 (or directly "DP-3"),
    move = (0) (0)                          move = "0 0",
    size = 1920 1080                        size = "1920 1080",
    fullscreen = on                         fullscreen = true,
    rounding = 0                            rounding = 0,
    idle_inhibit = focus                    idle_inhibit = "focus",

    stay_focused = on                       stay_focused = true,

    match:initial_class = ^(firefox-dev)$   match = { initial_class = "^(firefox-dev)$" },
    match:initial_title = ^()$              match = { initial_title = "^()$" },

  }                                       })

BIND inside window_rules.conf:
  bind = SUPER, mouse:272, tagwindow, +dragged  →  hl.bind(...) moved to keybinds
  bindrnip = , mouse:272, tagwindow, -dragged   →  hl.bind with { release = true, non_consuming = true, pass = true } flags
]]

-------------------
--- GENERAL RULES --
-------------------

-- [Default Rule] Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name           = "ignore-maximize-requests",
    suppress_event = "maximize",
    match          = { class = ".*" },
})

-- [Default Rule] Fix some dragging issues with XWayland
hl.window_rule({
    name     = "fix-dragging-issues-with-xwayland",
    no_focus = true,
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
})

-- Exclude fullscreen windows from dim inactive
hl.window_rule({
    name  = "exclude-fullscreen-from-dim-inactive",
    no_dim = true,
    match = { fullscreen = true },
})

-- Hack to make dragged windows transparent
hl.window_rule({
    name     = "hack-dragged-window-transparency",
    opacity         = "0.67 override",
    match    = { tag = "dragged" },
})

-- CHANGE: drag-related tag binds moved here from window_rules.conf
-- Old: bind = SUPER, mouse:272, tagwindow, +dragged
-- Old: bindrnip = , mouse:272, tagwindow, -dragged
-- Now using hyprctl via exec_cmd since tagwindow has special +/- prefix handling
hl.bind("SUPER + mouse:272", hl.dsp.exec_cmd("hyprctl dispatch tagwindow +dragged"))
hl.bind("mouse:272",         hl.dsp.exec_cmd("hyprctl dispatch tagwindow -dragged"), { release = true, non_consuming = true })



-------------------
--- POPUP RULES ---
-------------------
-- Add tag "popup" to windows. This tag will cause window to be floated, moved below mouse and dimmed around.
-- To create exceptions, remove it before those rules kick in.
-- There is another tag "persistent_popup", which is exclusive with "popup" and will override it.
-- Persistent popups are windows that will be there for a while and dont require immediate attention,
-- like file manager copy progress. Persistent popups will be floated, but not dimmed arount,
-- and will be moved to a corner of the screen,
-- Another tag is "game", this is also exclusive with "popup" and will overrde it.
-- Games will be forcefully moved to main monitor and fullscreend, along with other game-specific options.

-- Initially, assume all floating windows are popups, exceptions can be declared later
hl.window_rule({
    name = "tag-add-popup-all-floating",
    tag  = "+popup",
    match = { float = true },
})
-- xdg-desktop-portal-gtk windows should be considered popups and float, initially added for pinta save dialog
hl.window_rule({
    name = "tag-add-popup-xdg-desktop-portal",
    tag  = "+popup",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
})

-- Fix lots of issues with steam client if we mess with its windows
hl.window_rule({
    name = "tag-remove-popup-steam-client",
    tag  = "-popup",
    match = { class = "^(steam)$" },
})
-- Don't treat windows from proton games as popups
hl.window_rule({
    name = "tag-remove-popup-steam-proton-games",
    tag  = "-popup",
    match = { class = "^(games.exe)$" }, -- games running with some proton versions
})
-- Fix issues with Ardour, similiar to steam client
hl.window_rule({
    name = "tag-remove-popup-ardour",
    tag  = "-popup",
    match = { class = "^Ardour.*" },
})
-- Fix issues with Patchance, similiar to steam client
hl.window_rule({
    name = "tag-remove-popup-patchance",
    tag  = "-popup",
    match = { class = "^Patchance.*" },
})
-- Kamera fix to make it float above everything
hl.window_rule({
    name         = "tag-remove-popup-kamera",
    tag          = "-popup",
    stay_focused = true,
    match        = { class = "^(GStreamer)$" },
})

-- TODO:2 surely there is a better way to do this without repeating everything over and over
-- Dolphin copy progress windows are persistent popups
hl.window_rule({
    name = "tag-add-dolphin-copy-progress-1",
    tag  = "+dolphin_copy_progress",
    size = "408 160",
    match = {
        class         = "^(org.kde.dolphin)$",
        initial_title = "^(Copying — Dolphin)$",
    },
})
hl.window_rule({
    name = "tag-add-dolphin-copy-progress-2",
    tag  = "+dolphin_copy_progress",
    size = "408 160",
    match = {
        class         = "^(org.kde.dolphin)$",
        initial_title = "^(Moving — Dolphin)$",
    },
})
hl.window_rule({
    name = "tag-add-dolphin-copy-progress-3",
    tag  = "+dolphin_copy_progress",
    size = "408 160",
    match = {
        class         = "^(org.kde.dolphin)$",
        initial_title = "^(Deleting — Dolphin)$",
    },
})
hl.window_rule({
    name = "tag-add-dolphin-copy-progress-4",
    tag  = "+dolphin_copy_progress",
    size = "408 160",
    match = {
        class         = "^(org.kde.dolphin)$",
        initial_title = "^Copying \\(.*",
    },
})
hl.window_rule({
    name = "tag-add-dolphin-copy-progress-5",
    tag  = "+dolphin_copy_progress",
    size = "408 160",
    match = {
        class         = "^(org.kde.dolphin)$",
        initial_title = "^Moving \\(.*",
    },
})
hl.window_rule({
    name = "tag-add-dolphin-copy-progress-6",
    tag  = "+dolphin_copy_progress",
    size = "408 160",
    match = {
        class         = "^(org.kde.dolphin)$",
        initial_title = "^Deleting \\(.*",
    },
})
hl.window_rule({
    name = "tag-add-dolphin-copy-progress-7",
    tag  = "+dolphin_copy_progress",
    size = "408 160",
    match = {
        class         = "^(org.kde.dolphin)$",
        initial_title = "^(Progress Dialog — Dolphin)$",
    },
})
hl.window_rule({
    name = "tag-add-persistent-popup-dolphin-copy-progress",
    tag  = "+persistent_popup",
    match = { tag = "dolphin_copy_progress" },
})

-- Firefox notification windows, usually from extensions or site notifications
hl.window_rule({
    name = "tag-add-persistent-popup-firefox",
    tag  = "+persistent_popup",
    match = {
        initial_class = "^(firefox-dev)$",
        initial_title = "^()$",
    },
})

-- Steam update window
hl.window_rule({
    name = "tag-add-persistent-popup-steam-update",
    tag  = "+persistent_popup",
    match = {
        class         = "^$",
        initial_title = "Steam",
    },
})
-- Steam splash
hl.window_rule({
    name = "tag-add-persistent-popup-steam-splash",
    tag  = "+persistent_popup",
    match = {
        initial_class = "^(steam)$",
        initial_title = "^(Sign in to Steam)$",
    },
})

-- Assume all steam apps are games
hl.window_rule({
    name = "tag-add-game-steam-apps",
    tag  = "+game",
    size = "1920 1080",
    match = { class = "^steam_app_.*" },
})
-- TODO: 2 test if this is still true in new version
-- NOTE: size rule doesn't apply when filtering by tag, so we need to set it here



--[[
--- APPLY TAG RULES ---
]]

-- Apply "game" rules
hl.window_rule({
    name           = "apply-tag-rules-game",
    match          = { tag = "game" },
    tag            = "-popup",
    float          = true,
    monitor        = vars.monitor1,
    move           = "0 0",              -- CHANGE: move syntax from (0) (0) to "0 0"
    size           = "1920 1080",
    fullscreen     = true,
    rounding       = 0,
    idle_inhibit   = "focus",
    suppress_event = "fullscreen maximize fullscreenoutput",
})

-- Apply "persistent_popup" rules
hl.window_rule({
    name  = "apply-tag-rules-persistent-group",
    match = { tag = "persistent_popup" },
    tag   = "-popup",
    float = true,
    move  = "20 20",                     -- CHANGE: move (20) (20) → "20 20"
})

-- windowrule = fullscreenstate 0 0, tag:persistent_popup
-- TODO: 3 make a script to stack multiple "persistent popups" below each other

-- Apply "popup" rules
hl.window_rule({
    name  = "apply-tag-rules-popup",
    float = true,
    match = { tag = "popup" },
})
hl.window_rule({
    name       = "apply-tag-rules-popup-not-fullscreen",
    dim_around = true,
    -- CHANGE: move expression changed from space-separated to string format
    move       = "min(monitor_w-window_w-12,max(12,(cursor_x-window_w*0.5))) min(monitor_h-window_h-12,max(12,(cursor_y-32)))",
    match      = {
        tag        = "popup",
        fullscreen = false,
    },
})



------------------------
--- APP-SPECIFIC RULES --
------------------------

-- Float telegram media viewer popups
hl.window_rule({
    name  = "app-specific-telegram",
    float = true,
    match = {
        class = "^(org.telegram.desktop)$",
        title = "^(Media viewer)$",
    },
})

-- Force a set size for dolphin copy dialogs, because they are initialy tiled and do weird shit
-- NOTE: for some reason, size rule doesn't apply when filtering by tag
-- windowrule = size 408 160, tag:dolphin_copy_progress
