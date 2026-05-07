#!/usr/bin/env nu

use std/log
use std/assert
use std null-device

# Open multiple ghostty instances for workspace
#
# Scans directories recursively for task.yaml files with a "run" task.
# For each found directory, opens a ghostty with "nix develop" and "task run" typed.
# Also opens two additional ghostty instances: one with "v" and one with "opencode --port".
def main [--dry-run (-n), --dir (-d): string] {
    let start_dir = if $dir == null { $env.PWD } else { $dir }
    let basename = $start_dir | path expand | path basename

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

    let editor_cmd = "neovide";
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

# Open a ghostty instance on a directory
def open-ghostty [pane_name: string, dir_path: string, dry_run: bool, after_cmd?: string, enter_after_cmd? = false: bool,] {
    let create_session = $"tmux new-session -d -s ($pane_name) -c ($dir_path | path expand)"
    let send_nix_cmd = $"tmux send-keys -t ($pane_name) \"nix develop\" ENTER"
    mut full_tmux_builder = $"sleep 0.1;\n($create_session);\nsleep 0.1;\n($send_nix_cmd)"
    if ($after_cmd != null) {
        let send_cmd = $"tmux send-keys -t ($pane_name) \"($after_cmd)\""
        $full_tmux_builder = $"($full_tmux_builder); ($send_cmd)"
        if ($enter_after_cmd) {
            $full_tmux_builder = $"($full_tmux_builder) ENTER"
        }
    }
    let full_tmux_cmd = $full_tmux_builder
    log debug $"    Creating tmux session:\n($full_tmux_cmd)"

    let ghostty_cmd = $"ghostty --working-directory=($dir_path | path expand) -e tmux attach -t ($pane_name)"
    log debug $"    Ghostty cmd:\n($ghostty_cmd)"

    if not $dry_run {
        job spawn { bash -c $full_tmux_cmd }
        job spawn { bash -c $ghostty_cmd }
    }
}
