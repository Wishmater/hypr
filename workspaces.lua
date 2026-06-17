-- assign workspaces per monitor
for workspace_index = 1, vars.workspaceCount do
	workspace_id_offset = (workspace_index - 1) * #vars.monitors
	for monitor_index, monitor in ipairs(vars.monitors) do
		hl.workspace_rule({
			workspace = tostring(workspace_id_offset + monitor_index),
			monitor = monitor.id,
			layout = monitor.layout,
			default = workspace_index == 1,
		})
	end
end

-- assign gaps per monitor orientation
for _, monitor in ipairs(vars.monitors) do
	hl.workspace_rule({
		workspace = "s[false]m[" .. monitor.id .. "]",
		gaps_in = vars.aspectRatioGaps(3, 16 / 9, monitor.orientation == "horizontal"),
		gaps_out = vars.aspectRatioGaps(12, 16 / 9, monitor.orientation == "horizontal"),
	})
end

-- make special workspaces 3x the gaps as normal workspaces
hl.workspace_rule({
	workspace = "s[true]",
	gaps_in = vars.aspectRatioGaps(9, 16 / 9),
	gaps_out = vars.aspectRatioGaps(36, 16 / 9),
})

-- Monitor-specific layout options, like direction/orientation
for monitor_index, monitor in ipairs(vars.monitors) do
end

-- Monitor 1
-- Master
hl.workspace_rule({ workspace = "m[" .. vars.monitor1 .. "]w[tv1]", layout_opts = { orientation = "center" } })
hl.workspace_rule({ workspace = "m[" .. vars.monitor1 .. "]w[tv2-6]", layout_opts = { orientation = "right" } })
hl.workspace_rule({ workspace = "m[" .. vars.monitor1 .. "]w[tv7-999999]", layout_opts = { orientation = "center" } })
-- Scrolling
hl.workspace_rule({ workspace = "m[" .. vars.monitor1 .. "]", layout_opts = { direction = "right" } })

-- Monitor 2
-- Master
-- master layout has some issues with vertical monitors, check new versions for fixes
-- this could be a workaround IF IT WORKED
-- workspace = m[$monitor2], layoutopt:always_keep_position:false
hl.workspace_rule({ workspace = "m[" .. vars.monitor2 .. "]w[tv1]", layout_opts = { orientation = "right" } }) -- center
hl.workspace_rule({ workspace = "m[" .. vars.monitor2 .. "]w[tv2-4]", layout_opts = { orientation = "bottom" } })
hl.workspace_rule({ workspace = "m[" .. vars.monitor2 .. "]w[tv5-999999]", layout_opts = { orientation = "bottom" } }) -- center
-- Scrolling
hl.workspace_rule({ workspace = "m[" .. vars.monitor2 .. "]", layout_opts = { direction = "down" } })

-- Monitor 3
-- Master
hl.workspace_rule({ workspace = "m[" .. vars.monitor3 .. "]w[tv1-6]", layout_opts = { orientation = "left" } })
hl.workspace_rule({ workspace = "m[" .. vars.monitor3 .. "]w[tv7-999999]", layout_opts = { orientation = "center" } })
-- Scrolling
hl.workspace_rule({ workspace = "m[" .. vars.monitor3 .. "]", layout_opts = { direction = "left" } })
