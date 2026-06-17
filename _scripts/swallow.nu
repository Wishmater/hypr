#!/usr/bin/env nu

use std/log

# Run a command so its window replaces the current terminal window via Hyprland groups.
#
# The focused window is grouped, the command runs as a child of the shell,
# and any new window that spawns auto-joins the group. When the command
# exits, the group is torn down and the terminal reappears.
#
# This avoids Hyprland's PID-based swallow mechanism, which is unreliable
# with single-instance terminals (ghostty) where all windows share a PID.
def main [command: string, ...args: string] {
    # snapshot auto_group so we can restore it after
    let autoGroupOption = (^hyprctl getoption group:auto_group -j | from json)
    let autoGroupWas = if ($autoGroupOption | columns | "int" in $in) {
        $autoGroupOption.int
    } else {
        if $autoGroupOption.bool { 1 } else { 0 }
    }
    log debug $"auto_group was: ($autoGroupWas)"

    # snapshot focused window
    let active = (^hyprctl activewindow -j | from json)
    let oldAddress = $active.address
    log debug $"focused window: ($oldAddress) class=($active.class)"

    # briefly enable auto_group so new windows from our command
    # automatically join the focused window's group
    if $autoGroupWas == 0 {
        ^hyprctl eval "hl.config({ group = { auto_group = true } })"
    }

    # create a group on the focused window — the new app window will join it
    ^hyprctl dispatch "hl.dsp.group.toggle()"
    log info $"group opened on ($oldAddress), running ($command)..."

    # run the command; blocks until it exits (app window closes)
    # when it returns, the new window has been destroyed and the terminal
    # is left alone in a group of size 1 — we tear it down below
    ^$command ...$args

    # tear down the now-size-1 group so the terminal is a normal window again
    ^hyprctl dispatch "hl.dsp.group.toggle()"

    # restore previous auto_group state
    if $autoGroupWas == 0 {
        ^hyprctl eval "hl.config({ group = { auto_group = false } })"
    }

    log info "done"
}
