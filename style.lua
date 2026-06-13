-- https://wiki.hyprland.org/Configuring/Variables/#general

hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 12,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgb(33ccff)", "rgba(529E9399)", "rgb(98BB6C)" }, angle = 90 }, -- defaultHyprCyan interpWithLowerLuminance+opacity springGreen
            inactive_border = "rgba(625e5aaa)", -- dragonBlack6
        }
    },
})

-- https://wiki.hyprland.org/Configuring/Variables/#misc
hl.config({
    misc = {
        font_family             = "JetBrainsMono Nerd Font",
        background_color        = "rgb(0d0c0c)", -- this isn't used if there is a background, but whatever # dragonBlack0

        force_default_wallpaper = -1,   -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = false,
        col = {
            splash = "rgb(c5c9c5)", -- splash text color # dragonWhite
        },
        -- splash_font_family
    },
})

hl.config({
    ecosystem = {
        no_donation_nag = true,
    },
})

-- https://wiki.hyprland.org/Configuring/Variables/#decoration
hl.config({
    decoration = {
        rounding        = 12,
        rounding_power  = 4,

        active_opacity   = 1.0,
        fullscreen_opacity = 1.0,
        inactive_opacity = 1.0,

        dim_inactive = true,
        dim_strength = 0.1,
        dim_special  = 0.4,
        -- dim_special = 0 -- SET FOR TRANSPARENT SPECIAL WORKSPACE

        -- https://wiki.hyprland.org/Configuring/Variables/#shadow
        shadow = {
            enabled       = true,
            range         = 8,
            render_power  = 0,
            offset        = { 2, 2 }, -- CHANGE: vec2 values use table { x, y } instead of space-separated
            color         = "rgba(0d0c0caa)", -- dragonBlack0
        },

        -- https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,

            vibrancy = 0.1696,

            special  = true, -- note: expensive
            -- special = false -- SET FOR TRANSPARENT SPECIAL WORKSPACE
        },
    },
})

-- https://wiki.hyprland.org/Configuring/Advanced-and-Cool/Animations/

hl.config({
    animations = {
        enabled = true,
    },
})

-- CHANGE: bezier curves are now defined with hl.curve() instead of a single bezier keyword
-- The format changed from "bezier = name,x1,y1,x2,y2" to hl.curve("name", { type = "bezier", points = { {x1,y1}, {x2,y2} } })
hl.curve("linear",       { type = "bezier", points = { {0, 0},    {1, 1}    } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0},  {0.1, 1}  } })
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1},  {0.32, 1} } })

-- CHANGE: animation definitions changed from "animation = leaf, enabled, speed, curve, [style]"
-- to hl.animation({ leaf = "...", enabled = true, speed = N, bezier|spring = "...", style = "..." })
-- The speed values may need recalibration for 0.55 — these are the originals.
hl.animation({ leaf = "global",       enabled = true, speed = 5,    bezier = "default" })
hl.animation({ leaf = "windows",      enabled = true, speed = 3,    bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",    enabled = true, speed = 3,    bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 1,    bezier = "almostLinear",  style = "popin 87%" })
hl.animation({ leaf = "windowsMove",  enabled = true, speed = 2,    bezier = "easeOutQuint" })
hl.animation({ leaf = "layers",       enabled = true, speed = 3,    bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",     enabled = true, speed = 3,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",    enabled = true, speed = 1,    bezier = "almostLinear",  style = "fade" })
hl.animation({ leaf = "fade",         enabled = true, speed = 2,    bezier = "quick" })
hl.animation({ leaf = "fadeIn",       enabled = true, speed = 2,    bezier = "quick" })
hl.animation({ leaf = "fadeOut",      enabled = true, speed = 1,    bezier = "almostLinear" })
-- fadeSwitch
-- fadeShadows
-- fadeDim
-- fadeLayers
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2,   bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1,   bezier = "almostLinear" })
-- fadePopups
-- fadePopupsIn
-- fadePopupsOut
hl.animation({ leaf = "border",        enabled = true, speed = 4,   bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle",   enabled = false, speed = 0 }) -- speed = 0 disables
hl.animation({ leaf = "workspaces",    enabled = true, speed = 2,   bezier = "almostLinear",  style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.5, bezier = "easeOutQuint", style = "slidefadevert 33%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.5, bezier = "easeOutQuint", style = "slidefadevert 33%" })
hl.animation({ leaf = "specialWorkspace",     enabled = true, speed = 1.5, bezier = "quick", style = "slidefadevert" })
hl.animation({ leaf = "specialWorkspaceIn",   enabled = true, speed = 1.5, bezier = "quick", style = "slidefadevert 33%" })
hl.animation({ leaf = "specialWorkspaceOut",  enabled = true, speed = 1.2, bezier = "almostLinear", style = "slidefadevert 66%" })
hl.animation({ leaf = "zoomFactor",     enabled = true, speed = 0.8, bezier = "almostLinear" })
