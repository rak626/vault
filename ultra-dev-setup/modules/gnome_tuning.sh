#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

log "Applying GNOME 25.10 performance tuning"

# ----------------------------------------------------
# Disable Animations (GNOME 47 Safe)
# ----------------------------------------------------
gsettings set org.gnome.desktop.interface enable-animations false || true
gsettings set org.gnome.mutter experimental-features "[]" || true

# ----------------------------------------------------
# Disable Hot Corners
# ----------------------------------------------------
gsettings set org.gnome.desktop.interface enable-hot-corners false || true

# ----------------------------------------------------
# Dock (Dash-to-Dock) — Fully Hide Behaviorally
# ----------------------------------------------------
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false || true
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true || true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false || true

# Reduce dock visual noise
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED' || true

# ----------------------------------------------------
# Workspace Visual Noise Reduction
# ----------------------------------------------------
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4 || true

# Disable workspace switch popup animation (partial GNOME 47 workaround)
gsettings set org.gnome.shell.overrides dynamic-workspaces false || true

# ----------------------------------------------------
# GNOME Tracker / Indexer Kill (Expanded for 25.10)
# ----------------------------------------------------
systemctl --user mask tracker-miner-fs-3.service 2>/dev/null || true
systemctl --user mask tracker-extract-3.service 2>/dev/null || true
systemctl --user mask tracker-store.service 2>/dev/null || true
systemctl --user mask tracker-writeback-3.service 2>/dev/null || true

# Stop if currently running
systemctl --user stop tracker-miner-fs-3.service 2>/dev/null || true
systemctl --user stop tracker-extract-3.service 2>/dev/null || true
systemctl --user stop tracker-store.service 2>/dev/null || true
systemctl --user stop tracker-writeback-3.service 2>/dev/null || true

# ----------------------------------------------------
# Disable Unused Settings Daemon Modules
# ----------------------------------------------------
systemctl --user mask org.gnome.SettingsDaemon.Wacom.service 2>/dev/null || true
systemctl --user mask org.gnome.SettingsDaemon.PrintNotifications.service 2>/dev/null || true
systemctl --user mask org.gnome.SettingsDaemon.Smartcard.service 2>/dev/null || true

# ----------------------------------------------------
# Reduce Background Portal Noise (Safe)
# ----------------------------------------------------
systemctl --user mask xdg-desktop-portal-gtk.service 2>/dev/null || true

# ----------------------------------------------------
# File Indexing Off (If Tracker Survives Updates)
# ----------------------------------------------------
gsettings set org.freedesktop.Tracker3.Miner.Files enable-monitors false 2>/dev/null || true

# ----------------------------------------------------
# Power / Idle Tuning (Developer Friendly)
# ----------------------------------------------------
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing' || true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend' || true

# ----------------------------------------------------
# Optional: Faster Window Focus Feel
# ----------------------------------------------------
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click' || true

log "GNOME 25.10 tuning applied"

