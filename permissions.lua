-- https://wiki.hyprland.org/Configuring/Advanced-and-Cool/Permissions/

hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

hl.permission("/nix/store/[a-z0-9]{32}-grim-[0-9.]*/bin/grim", "screencopy", "allow")
hl.permission("/nix/store/[a-z0-9]{32}-hyprpicker-[0-9.]*/bin/hyprpicker", "screencopy", "allow")
hl.permission("/nix/store/[a-z0-9]{32}-wf-recorder-[0-9.]*/bin/wf-recorder", "screencopy", "allow")
hl.permission("/nix/store/[a-z0-9]{32}-wl-mirror-[0-9.]*/bin/wl-mirror", "screencopy", "allow")
hl.permission("/nix/store/[a-z0-9]{32}-xdg-desktop-portal-hyprland-[0-9.]*/libexec/.xdg-desktop-portal-hyprland-wrapped", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
