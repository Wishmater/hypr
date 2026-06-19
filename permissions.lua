-- https://wiki.hyprland.org/Configuring/Advanced-and-Cool/Permissions/

vars.setConfig({
	ecosystem = {
		enforce_permissions = true,
	},
})

hl.permission({ binary = "/nix/store/[a-z0-9]{32}-grim-[0-9.]*/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({
	binary = "/nix/store/[a-z0-9]{32}-hyprpicker-[0-9.]*/bin/hyprpicker",
	type = "screencopy",
	mode = "allow",
})
hl.permission({
	binary = "/nix/store/[a-z0-9]{32}-wf-recorder-[0-9.]*/bin/wf-recorder",
	type = "screencopy",
	mode = "allow",
})
hl.permission({
	binary = "/nix/store/[a-z0-9]{32}-wl-mirror-[0-9.]*/bin/wl-mirror",
	type = "screencopy",
	mode = "allow",
})
hl.permission({
	binary = "/nix/store/[a-z0-9]{32}-xdg-desktop-portal-hyprland-[0-9.]*/libexec/.xdg-desktop-portal-hyprland-wrapped",
	type = "screencopy",
	mode = "allow",
})
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
