-- assign workspaces per monitor
for workspaceIndex = 1, vars.workspaceCount do
	workspaceIdOffset = (workspaceIndex - 1) * #vars.monitors
	for monitorIndex, monitor in ipairs(vars.monitors) do
		hl.workspace_rule({
			workspace = tostring(workspaceIdOffset + monitorIndex),
			monitor = monitor.id,
			layout = monitor.layout,
			default = workspaceIndex == 1,
		})
	end
end

-- assign gaps per monitor orientation
for _, monitor in ipairs(vars.monitors) do
	hl.workspace_rule({
		workspace = "s[false]m[" .. monitor.id .. "]",
		gaps_in = vars.aspectRatioGaps(vars.baseConfig.general.gaps_in, 16 / 9, monitor.orientation),
		gaps_out = vars.aspectRatioGaps(vars.baseConfig.general.gaps_out, 16 / 9, monitor.orientation),
	})

	-- make special workspaces have more gaps than normal workspaces
	hl.workspace_rule({
		workspace = "s[true]m[" .. monitor.id .. "]",
		gaps_in = vars.aspectRatioGaps(vars.baseConfig.general.gaps_in, 16 / 9, monitor.orientation, 2),
		gaps_out = vars.aspectRatioGaps(vars.baseConfig.general.gaps_out, 16 / 9, monitor.orientation, 2),
	})

	-- layout/orientation-specific options
	-- we can just set options for all layouts, because they are only used when enabled
	-- if monitor.layout == "master" then
	hl.workspace_rule({
		workspace = "m[" .. monitor.id .. "]w[tv1]",
		layout_opts = {
			-- TODO: 1 should just be chenter, this hack is because master layout doesn't work properly on vertical monitors
			orientation = monitor.orientation == "horizontal" and "center" or "right",
		},
	})
	hl.workspace_rule({
		workspace = "m[" .. monitor.id .. "]w[tv2-6]",
		layout_opts = { orientation = vars.directionForMaster(monitor.direction) },
	})
	hl.workspace_rule({
		workspace = "m[" .. monitor.id .. "]w[tv7-999999]",
		layout_opts = {
			-- TODO: 1 should just be chenter, this hack is because master layout doesn't work properly on vertical monitors
			orientation = monitor.orientation == "horizontal" and "center"
				or vars.directionForMaster(monitor.direction),
		},
	})
	-- elseif monitor.layout == "scrolling" then
	hl.workspace_rule({
		workspace = "m[" .. monitor.id .. "]",
		layout_opts = { direction = vars.directionForScrolling(monitor.direction) },
	})
	-- end
end
