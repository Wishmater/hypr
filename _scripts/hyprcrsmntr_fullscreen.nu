#!/usr/bin/env nu

use std/log
use std/assert

# Smartly toggle fullscreen on the focused hyprland window, adding behaviour like:
#   - Recognizing all fullscreen states as fullscreen for toggle
#   - Using maximize instead of fullscreen for special workspaces
#   - Invert internal state for windows with tag reverse_client_fullscreen
def main [
  action: string@actions = "toggle" # one of: "toggle", "update", "fullscreen", "unfullscreen"
  --internal (-i) # set the internal client window state as fullscreen
] {
  if $action not-in (actions) { error make { msg: $"Invalid value "($action)" for action, valid values are: (actions)" } }

  # call hyprctl to get data of active window
  let active_window = hyprctl activewindow -j | from json
  log debug $"Active window data received from hyprctl: ($active_window)"

  # parse active window result data into easily-usable variables
  let is_fullscreen = $active_window.fullscreen != 0
  let is_special = $active_window.workspace.name | str starts-with "special"
  let reverse_client_fullscreen = "reverse_client_fullscreen" in $active_window.tags
  print $"current state: is_fullscreen: ($is_fullscreen), is_special: ($is_special), reverse_client_fullscreen: ($reverse_client_fullscreen)"

  # compute desired new state from parsed window data
  let fullscreen_state = match $action {
    "toggle" => (if $is_fullscreen { 0 } else if $is_special { 1 } else { 2 })
    "update" => $active_window.fullscreen
    "fullscreen" => (if $is_special { 1 } else { 2 })
    "unfullscreen" => 0
  }
  mut fullscreen_state_client = if $fullscreen_state == 0 { 0 } else if $internal { 2 } else { 0 }
  if $reverse_client_fullscreen { 
    $fullscreen_state_client = if $fullscreen_state_client == 0 { 2 } else { 0 }
  }
  print $"desired new state: hyprland state: (fulscreenstate_string $fullscreen_state), client state: (fulscreenstate_string $fullscreen_state_client)"

  # call hyprctl to set desired new state
  if $fullscreen_state != $active_window.fullscreen or $fullscreen_state_client != $active_window.fullscreenClient {
    print $"calling `hyprctl dispatch fullscreenstate ($fullscreen_state) ($fullscreen_state_client)`..."
    hyprctl dispatch fullscreenstate $fullscreen_state $fullscreen_state_client
  } else {
    # if we call hyprctl with the same state it already has, it toggles it :))
    print "Desired state is already the current one, skipping hyprctl call."
  }

}


def actions [] {
  ["toggle", "update", "fullscreen", "unfullscreen"]
}

def fulscreenstate_string [state:int] {
  let result = match $state {
    0 => "windowed"
    1 => "maximized"
    2 => "fullscreen"
  }
  return $result
}
