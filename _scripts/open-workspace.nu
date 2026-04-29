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

    log info $"Scanning ($start_dir) for taskfile.yaml files with 'run' task..."
    let dirs_with_run = (find-dirs-with-run-task $start_dir)
    if ($dirs_with_run | is-empty) {
        log info "  No directories with 'run' task found"
    } else {
        for dir_path in $dirs_with_run {
            log info $"Opening task runner at ($dir_path)..."
            # TODO: 2 figure out a way to open it with the text "task run" typed in
            open-ghostty $dir_path $dry_run
        }
    }

    log info "Opening opencode in new terminal window..."
    open-ghostty $start_dir $dry_run "opencode"

    let editor_cmd = "neovide";
    log info "Opening editor in new window..."
    if not $dry_run {
        open-ghostty $start_dir $dry_run $editor_cmd
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
def open-ghostty [dir_path: string, dry_run: bool, after_cmd?: string] {
    let cmd = if $after_cmd == null {
        $"ghostty --working-directory=($dir_path | path expand) -e nix-your-shell nu nix develop"
    } else {
        $"ghostty --working-directory=($dir_path | path expand) -e nix develop -c \"($after_cmd)\""
    }
    log debug $"    ($cmd)"
    if not $dry_run {
        job spawn { bash -c $'($cmd)' }
    }
}
