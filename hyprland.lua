-- https://wiki.hyprland.org/Configuring/

vars = require("vars")

require("autostart")
require("env")
require("input")
require("keybinds")
require("layer_rules")
require("layout")
require("monitors")
require("permissions")
require("style")
require("window_rules")
require("workspaces")

vars.setConfig({
	debug = {
		-- disable_logs = false,
		-- overlay = true,
	},
})

hl.config(vars.baseConfig)
