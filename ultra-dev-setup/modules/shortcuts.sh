#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

log "Applying keyboard shortcuts (Ubuntu 25.10 compatible)"

BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

# ----------------------------------------------------
# Detect Terminal (25.10 may not use gnome-terminal)
# ----------------------------------------------------
TERMINAL_CMD="gnome-terminal"

if command_exists ptyxis; then
  TERMINAL_CMD="ptyxis --new-window --maximize"
elif command_exists kgx; then
  TERMINAL_CMD="kgx"
elif command_exists gnome-terminal; then
  TERMINAL_CMD="gnome-terminal"
fi

log "Using terminal: $TERMINAL_CMD"

# ----------------------------------------------------
# Clear old bindings (GNOME 47 safe reset)
# ----------------------------------------------------
gsettings reset-recursively org.gnome.settings-daemon.plugins.media-keys || true

# ----------------------------------------------------
# Register new binding list
# ----------------------------------------------------
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"['$BASE/custom0/','$BASE/custom1/','$BASE/custom2/','$BASE/custom3/','$BASE/custom4/']"

sleep 0.5

# ----------------------------------------------------
# Helper
# ----------------------------------------------------
set_shortcut() {
 local path=$1
 local name=$2
 local cmd=$3
 local bind=$4

 gsettings set \
 org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path name "$name"

 gsettings set \
 org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path command "$cmd"

 gsettings set \
 org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path binding "$bind"
}

# ----------------------------------------------------
# Apply Shortcuts
# ----------------------------------------------------
set_shortcut "$BASE/custom0/" "Chrome" "google-chrome" "<Ctrl><Shift>1"
set_shortcut "$BASE/custom1/" "Firefox" "firefox" "<Ctrl><Shift>2"
set_shortcut "$BASE/custom2/" "Terminal" "$TERMINAL_CMD" "<Ctrl><Shift>3"
set_shortcut "$BASE/custom3/" "Files" "nautilus" "<Ctrl><Shift>4"
set_shortcut "$BASE/custom4/" "Brave" "brave-browser" "<Ctrl><Shift>5"

# ----------------------------------------------------
# Window + Workspace bindings
# ----------------------------------------------------
gsettings set org.gnome.desktop.wm.keybindings close "['<Ctrl><Shift>e']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left \
"['<Ctrl><Super>Left']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right \
"['<Ctrl><Super>Right']"

log "Keyboard shortcuts applied successfully"
