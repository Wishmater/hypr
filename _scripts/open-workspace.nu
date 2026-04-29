#!/usr/bin/env nu

use std/log
use std/assert
use std null-device

# Find directories with task.yaml containing a "run" task
def find-dirs-with-run-task [start_dir: string, dry_run: bool] {
    let finding = (^find $start_dir -type f -name "task.yaml" 2>/dev/null | lines)
    let result = ($finding | each {|f|
        let dir = ($f | path dirname)
        if not $dry_run {
            let task_check = (^bash -c $"cd ($dir); task --list 2>&1")
            if $task_check =~ "run" {
                $dir
            }
        } else {
            $dir
        }
    } | compact)
    $result
}

# Open a ghostty instance on a directory
def open-ghostty [dir_path: string, after_cmd: string, dry_run: bool] {
    let cmd = $"ghostty --working-directory=($dir_path | path expand) -e nix develop -c \"($after_cmd)\""
    log debug $"    ($cmd)"
    if not $dry_run {
        job spawn { bash -c $'($cmd)' }
    }
}

# Open multiple ghostty instances for workspace
#
# Scans directories recursively for task.yaml files with a "run" task.
# For each found directory, opens a ghostty with "nix develop" and "task run" typed.
# Also opens two additional ghostty instances: one with "v" and one with "opencode --port".
def main [--dry-run (-n), --dir (-d): string] {
    let start_dir = if $dir == null { $env.PWD } else { $dir }

    log info $"Scanning ($start_dir) for task.yaml files with 'run' task..."
    let dirs_with_run = (find-dirs-with-run-task $start_dir $dry_run)

    for dir_path in $dirs_with_run {
        log info $"Opening task runner at ($dir_path)..."
        open-ghostty $dir_path "print -n 'task run' > /dev/tty" $dry_run
    }

    log info "Opening opencode in new terminal window..."
    open-ghostty $start_dir "opencode" $dry_run

    let editor_cmd = "nix develop -c neovide";
    log info "Opening editor in new window..."
    log debug $"    ($editor_cmd)"
    job spawn { bash -c $editor_cmd }

    print "Press any key to continue..."
    input
    # TODO: 2 do we want to close all windows? (kill jobs?)
    # TODO: 2 we should listen to jobs spawned and report errors
}
