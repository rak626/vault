#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

log "Checking JetBrains Toolbox"

# 1. Quick Check
if pgrep -x "jetbrains-toolb" > /dev/null; then
  log "JetBrains Toolbox is already running."
  exit 0
fi

# 2. Fetch Latest Download URL
API_URL="https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"
DOWNLOAD_URL=$(curl -s "$API_URL" | grep -Po '"linux":\s*{"link":\s*"\K[^"]+')

log "Downloading latest version..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

retry curl -L "$DOWNLOAD_URL" -o toolbox.tar.gz

# 3. Extract and Execute
log "Extracting and launching..."
tar -xzf toolbox.tar.gz --strip-components=1

# Find the binary (it's usually named jetbrains-toolbox in the root of the extract)
TOOLBOX_EXEC=$(find . -maxdepth 2 -executable -type f -name "jetbrains-toolbox" | head -n 1)

if [[ -n "$TOOLBOX_EXEC" ]]; then
  log "Launching JetBrains Toolbox..."
  # Run and disown so the script can finish while the app stays open
  "$TOOLBOX_EXEC" --nosplash >/dev/null 2>&1 &
  disown
  log "Launch successful. Toolbox will handle its own persistent installation."
else
  log "ERROR: Could not find the jetbrains-toolbox binary."
  exit 1
fi