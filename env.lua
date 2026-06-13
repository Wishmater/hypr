-- See https://wiki.hyprland.org/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("TERMINAL", "ghostty")
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")

hl.env("XCURSOR_THEME", "Nordzy-cursors-catppuccin-mocha-dark")
hl.env("XCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_THEME", "Nordzy-hyprcursors-catppuccin-mocha-dark")
hl.env("HYPRCURSOR_SIZE", "32")

-- GTK: Use wayland if available. If not: try x11, then any other GDK backend.
hl.env("GDK_BACKEND", "wayland,x11,*")
-- Qt: Use wayland if available, fall back to x11 if not.
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
-- Run SDL2 applications on Wayland. Remove or set to x11 if games that provide older versions of SDL cause compatibility issues
hl.env("SDL_VIDEODRIVER", "wayland")
-- Clutter package already has wayland enabled, this variable will force Clutter applications to try and use the Wayland backend
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- force wayland mode on electron, chromium and others
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- force HDR support on wayland and proton
hl.env("DXVK_HDR", "1")
hl.env("PROTON_ENABLE_WAYLAND", "1")
hl.env("PROTON_ENABLE_HDR", "1")
hl.env("ENABLE_HDR_WSI", "1") -- probably no longer needed

-- recommended for nvidia gpus https://wiki.hypr.land/Nvidia/#environment-variables
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
