#!/usr/bin/env nu

use std/log

# Run a command so its window replaces the current terminal window via Hyprland groups.
#
# The focused window is grouped, the command runs as a child of the shell,
# and any new window that spawns auto-joins the group. Once the new window
# is detected, auto_group is restored so unrelated windows aren't affected.
# When the command exits, the group is torn down and the terminal reappears.
#
# This avoids Hyprland's PID-based swallow mechanism, which is unreliable
# with single-instance terminals (ghostty) where all windows share a PID.
def --wrapped main [...rawArgs: string] {
    if ($rawArgs | length) == 0 {
        log error "usage: swallow <command> [args...]"
        return
    }
    let command = $rawArgs.0
    let args = ($rawArgs | slice 1..)
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

    # snapshot current windows to detect the new one later
    let beforeAddresses = (^hyprctl -j clients | from json | get address)

    # briefly enable auto_group so new windows from our command
    # automatically join the focused window's group
    if $autoGroupWas == 0 {
        ^hyprctl eval "hl.config({ group = { auto_group = true } })" out> /dev/null
    }

    # create a group on the focused window — the new app window will join it
    # but only if the window isn't already in a group (toggle inverts state)
    let wasGrouped = ($active.grouped | length) > 0
    let groupDispatch = ("hl.dsp.group.toggle({ window = \"address:" + $oldAddress + "\" })")
    if not $wasGrouped {
        ^hyprctl dispatch $groupDispatch out> /dev/null
        log info $"group opened, running ($command)..."
    } else {
        log info $"window already grouped, running ($command)..."
    }

    # build bash-safe escaped command string
    let cmdStr = ([$command ...$args] | each {|a| bash-escape $a} | str join ' ')

    # start command in background via bash:
    #   stdout/stderr → /dev/tty (the terminal, so user sees output)
    #   PID captured from $! to detect crashes
    let pid = (^bash "-c" $"($cmdStr) >/dev/tty 2>/dev/tty & echo \$!" | str trim | into int)

    # wait for a new window spawned by our command to appear;
    # also bail early if the command crashes before spawning anything
    mut newAddress = null
    for i in 1..50 {
        if not (is-alive $pid) {
            log warning "command exited before spawning a window"
            break
        }
        let current = (^hyprctl -j clients | from json | get address)
        let candidates = ($current | where {|a| $a not-in $beforeAddresses and $a != $oldAddress})
        if ($candidates | length) > 0 {
            $newAddress = $candidates.0
            break
        }
        sleep 100ms
    }

    # restore auto_group immediately so unrelated windows don't get grouped
    if $autoGroupWas == 0 {
        ^hyprctl eval "hl.config({ group = { auto_group = false } })" out> /dev/null
    }

    if $newAddress == null {
        # nothing spawned — tear down the group if we created one
        log warning "no new window detected"
        if not $wasGrouped {
            ^hyprctl dispatch $groupDispatch out> /dev/null
        }
        return
    }

    log info $"new window ($newAddress) grouped, auto_group restored"

    # wait for the app window to close
    loop {
        sleep 1sec
        let clients = (^hyprctl -j clients | from json)
        if ($clients | where address == $newAddress | is-empty) {
            break
        }
    }

    # app closed — tear down the group if we created one
    if not $wasGrouped {
        ^hyprctl dispatch $groupDispatch out> /dev/null
        log info "app closed, group torn down"
    } else {
        log info "app closed"
    }
}

# escape a string for safe inclusion in a bash single-quoted string
def bash-escape [s: string] {
    let q = "'"
    # within a bash single-quoted string, the only character that
    # needs escaping is the single quote itself: ' → '\''
    let esc = ($q + "\\" + $q + $q)
    $q + ($s | str replace --all $q $esc) + $q
}

# check whether a process is still alive by PID
def is-alive [pid: int] {
    try {
        ^kill -0 $pid out> /dev/null err> /dev/null
        true
    } catch {
        false
    }
}
