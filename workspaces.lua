--[[
CHANGE: Workspace rules use hl.workspace_rule() with Lua tables.
Format: workspace rule selectors (like m[DP-3]w[tv1]) remain as strings.
Variables are interpolated via Lua string concatenation.
]]

-- Assign workspaces per monitor
hl.workspace_rule({ workspace = 1,  monitor = vars.monitor1,                    default = true })
hl.workspace_rule({ workspace = 2,  monitor = vars.monitor2, layout = "scrolling", default = true })
hl.workspace_rule({ workspace = 3,  monitor = vars.monitor3,                    default = true })
hl.workspace_rule({ workspace = 4,  monitor = vars.monitor1 })
hl.workspace_rule({ workspace = 5,  monitor = vars.monitor2, layout = "scrolling" })
hl.workspace_rule({ workspace = 6,  monitor = vars.monitor3 })
hl.workspace_rule({ workspace = 7,  monitor = vars.monitor1 })
hl.workspace_rule({ workspace = 8,  monitor = vars.monitor2, layout = "scrolling" })
hl.workspace_rule({ workspace = 9,  monitor = vars.monitor3 })
hl.workspace_rule({ workspace = 10, monitor = vars.monitor1 })
hl.workspace_rule({ workspace = 11, monitor = vars.monitor2, layout = "scrolling" })
hl.workspace_rule({ workspace = 12, monitor = vars.monitor3 })

-- make special workspaces 3x the gaps as normal workspaces
hl.workspace_rule({ workspace = "special:1", gaps_in = 12, gaps_out = 36 })
hl.workspace_rule({ workspace = "special:2", gaps_in = 12, gaps_out = 36 })
hl.workspace_rule({ workspace = "special:3", gaps_in = 12, gaps_out = 36 })
hl.workspace_rule({ workspace = "special:4", gaps_in = 12, gaps_out = 36 })



-- Monitor-specific layout options, like direction/orientation

-- Monitor 1
-- Master
hl.workspace_rule({ workspace = "m[" .. vars.monitor1 .. "]w[tv1]",       
  -- layoutopt = { orientation = "center" } 
})
hl.workspace_rule({ workspace = "m[" .. vars.monitor1 .. "]w[tv2-6]",     
  -- layoutopt = { orientation = "right" } 
})
hl.workspace_rule({ workspace = "m[" .. vars.monitor1 .. "]w[tv7-999999]", 
  -- layoutopt = { orientation = "center" } 
})
-- Scrolling
hl.workspace_rule({ workspace = "m[" .. vars.monitor1 .. "]",             
  -- layoutopt = { direction = "right" } 
})

-- Monitor 2
-- Master
-- master layout has some issues with vertical monitors, check new versions for fixes
-- this could be a workaround IF IT WORKED
-- workspace = m[$monitor2], layoutopt:always_keep_position:false
hl.workspace_rule({ workspace = "m[" .. vars.monitor2 .. "]w[tv1]",       
  -- layoutopt = { orientation = "right" } 
}) -- center
hl.workspace_rule({ workspace = "m[" .. vars.monitor2 .. "]w[tv2-4]",     
  -- layoutopt = { orientation = "bottom" } 
})
hl.workspace_rule({ workspace = "m[" .. vars.monitor2 .. "]w[tv5-999999]", 
  -- layoutopt = { orientation = "bottom" } 
}) -- center
-- Scrolling
hl.workspace_rule({ workspace = "m[" .. vars.monitor2 .. "]",             
  -- layoutopt = { direction = "down" } 
})

-- Monitor 3
-- Master
hl.workspace_rule({ workspace = "m[" .. vars.monitor3 .. "]w[tv1-6]",     
  -- layoutopt = { orientation = "left" } 
})
hl.workspace_rule({ workspace = "m[" .. vars.monitor3 .. "]w[tv7-999999]", 
  -- layoutopt = { orientation = "center" } 
})
-- Scrolling
hl.workspace_rule({ workspace = "m[" .. vars.monitor3 .. "]",             
  -- layoutopt = { direction = "left" } 
})
