-- https://wiki.hyprland.org/Configuring/

-- Minimal configuration, to preserve as much resources as possible.
-- This is mainly useful to reserve graphic memory for gaming.

vars = require("../vars")

-- Config files imported as-is
require("../env")

-- Custom style config to be as resource-efficient as possible
require("style")

-- Custom monitors config to enable only the main monitor
require("monitors")

-- Config files imported as-is
require("../permissions")
require("../input")
require("../layout")
require("../workspaces")
require("../window_rules")
require("../layer_rules")
require("../keybinds")

-- We definitely don't want to autostart anything
-- require("../autostart")

vars.setConfig({
	debug = {
		-- disable_logs = false,
		-- overlay = true,
	},
})

hl.config(vars.baseConfig)
