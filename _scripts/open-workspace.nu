#!/usr/bin/env nu

use std/log
use std null-device

# Open multiple ghostty instances for workspace
#
# Scans directories recursively for task.yaml files with a "run" task.
# For each found directory, opens a ghostty with "nix develop" and "task run" typed.
# Also opens two additional ghostty instances: one with "v" and one with "opencode --port".
def main [--dry-run (-n), --dir (-d): string] {
    let start_dir = if $dir == null { $env.PWD } else { $dir }
    let basename = ($start_dir | path expand | path basename)

    log info $"Scanning ($start_dir) for taskfile.yaml files with 'run' task..."
    let dirs_with_run = (find-dirs-with-run-task $start_dir)
    if ($dirs_with_run | is-empty) {
        log info "  No directories with 'run' task found"
    } else {
        for dir_path in $dirs_with_run {
            let dir_name = ($dir_path | path expand | path basename)
            log info $"Opening task runner at ($dir_path)..."
            open-ghostty $"($basename)-($dir_name)" $dir_path $dry_run "task run"
        }
    }

    log info "Opening opencode in new terminal window..."
    open-ghostty $"($basename)-opencode" $start_dir $dry_run "opencode" true

    let editor_cmd = "neovide"
    log info "Opening editor in new window..."
    if not $dry_run {
        open-ghostty $"($basename)-editor" $start_dir $dry_run $editor_cmd true
    }

    print "Press any key to continue (this will close all opened windows)..."
    input
    # TODO: 2 we should listen to jobs spawned and report errors
}

# Find directories with taskfile.yaml containing a "run" task
def find-dirs-with-run-task [start_dir: string] {
    let finding = (^find $start_dir -type f -name "taskfile.yaml" | lines | where {|l| not ($l =~ "^find:") })
    let result = ($finding | each {|f|
        let dir = ($f | path dirname)
        let task_result = (^bash -c $"cd ($dir); task --list-all 2>&1" | complete)
        if $task_result.exit_code == 0 and $task_result.stdout =~ "run" {
            $dir
        }
    } | compact | sort)
    $result
}

# Open a ghostty window with a given title, then type commands into it via hyprctl
def open-ghostty [
    pane_name: string,
    dir_path: string,
    dry_run?: bool = false,
    after_cmd?: string,
    adter_cmd_enter?: bool = false,
] {
    let ghostty_cmd = $"ghostty --title=($pane_name) --gtk-single-instance=false --working-directory=($dir_path | path expand)"
    log debug $"    Ghostty cmd: ($ghostty_cmd)"

    if not $dry_run {
        job spawn {
            bash -c $ghostty_cmd
        }
        job spawn {
            wait-for-window $pane_name
            send-text-to-window $pane_name "nix develop" true
            if ($after_cmd != null) {
                send-text-to-window $pane_name $after_cmd $adter_cmd_enter
            }
        }
    }
}

# Poll hyprctl until a window with the given title appears
def wait-for-window [title: string] {
    for $i in 0..30 {
        let clients = (^hyprctl clients -j | from json)
        if ($clients | where title == $title | length) > 0 {
            sleep 200ms
            return
        }
        sleep 100ms
    }
    log warning $"Window with title '($title)' did not appear"
}

# Send text keystrokes to a window identified by its title, via hyprctl dispatch
def send-text-to-window [title: string, text: string, add_enter?: bool = false] {
    let chars = $text | split chars
    for char in $chars {
        let key = if $char == " " { "space" } else { $char }
        log debug $"    Hyprland cmd: hyprctl dispatch sendshortcut , ($key), title:($title)"
        ^hyprctl dispatch sendshortcut $", ($key), title:($title)" out> (null-device)
        sleep 30ms
    }

    if ($add_enter) {
        log debug $"    Hyprland cmd: hyprctl dispatch sendshortcut , Return, title:($title)"
        ^hyprctl dispatch sendshortcut $", Return, title:($title)" out> (null-device)
    }
}
