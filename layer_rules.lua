--[[
CHANGE: Layer rules move from the old layerrule {} block to hl.layer_rule({})
with match:namespace becoming match = { namespace = "..." }
]]

-- Rules for waywing
hl.layer_rule({
    name         = "layerrule-waywing",
    blur         = true,
    ignore_alpha = 0.88,
    match        = { namespace = "WayWings" },
})
