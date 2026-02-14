#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

log "Configuring Firefox (Full Snap removal + Mozilla official install)"

# ----------------------------------------------------
# Remove Snap Firefox
# ----------------------------------------------------
if snap list firefox >/dev/null 2>&1; then
  log "Removing snap Firefox"
  sudo snap remove firefox || true
fi

# ----------------------------------------------------
# Remove Snap Snapshots
# ----------------------------------------------------
log "Removing snap Firefox snapshots"

SNAP_IDS=$(snap saved | awk '/firefox/{print $1}')

for id in $SNAP_IDS; do
  log "Removing snap snapshot ID $id"
  sudo snap forget "$id" || true
done

# ----------------------------------------------------
# Remove Snap User + System Data
# ----------------------------------------------------
log "Removing snap leftover data"

rm -rf "$HOME/snap/firefox" 2>/dev/null || true
sudo rm -rf /var/snap/firefox 2>/dev/null || true

# ----------------------------------------------------
# Remove Apt Transitional Firefox
# ----------------------------------------------------
if dpkg -s firefox >/dev/null 2>&1; then
  log "Removing apt Firefox transitional package"
  sudo apt purge -y firefox firefox-locale-en || true
fi

# ----------------------------------------------------
# Block Firefox Snap Reinstall via Apt
# ----------------------------------------------------
log "Blocking Firefox from Ubuntu repo"

sudo tee /etc/apt/preferences.d/no-firefox-snap <<EOF
Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1
EOF

# ----------------------------------------------------
# If Mozilla Firefox Already Installed → Exit
# ----------------------------------------------------
if command_exists firefox && [[ -x /opt/firefox/firefox ]]; then
  log "Mozilla Firefox already installed"
  exit 0
fi

# ----------------------------------------------------
# Install Mozilla Firefox Official Binary
# ----------------------------------------------------
log "Installing Mozilla Firefox binary"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

cd "$TMP_DIR"

retry curl -L \
"https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" \
-o firefox.tar

FILE_TYPE=$(file firefox.tar)

sudo rm -rf /opt/firefox
sudo mkdir -p /opt

if [[ "$FILE_TYPE" == *"XZ"* ]]; then
  sudo tar -xJf firefox.tar -C /opt/
else
  sudo tar -xjf firefox.tar -C /opt/
fi

# ----------------------------------------------------
# Symlink Binary
# ----------------------------------------------------
sudo ln -sf /opt/firefox/firefox /usr/local/bin/firefox

# ----------------------------------------------------
# Desktop Entry
# ----------------------------------------------------
sudo tee /usr/share/applications/firefox.desktop <<EOF
[Desktop Entry]
Name=Firefox
Exec=/opt/firefox/firefox %u
Terminal=false
Type=Application
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Categories=Network;WebBrowser;
EOF

log "Mozilla Firefox installation complete"
