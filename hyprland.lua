-- https://wiki.hyprland.org/Configuring/

vars = require("vars")

require("env")
require("monitors")
require("autostart")
require("style")
require("input")
require("layout")
require("workspaces")
require("window_rules")
require("layer_rules")
require("permissions")
require("keybinds")

vars.setConfig({
	debug = {
		-- disable_logs = false,
		-- overlay = true,
	},
})

hl.config(vars.baseConfig)
