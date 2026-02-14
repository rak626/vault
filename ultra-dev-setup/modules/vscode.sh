#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

if command_exists code; then
 log "VS Code already installed"
 exit 0
fi

log "Installing VS Code"

sudo mkdir -p /etc/apt/keyrings

retry wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
| gpg --dearmor \
| sudo tee /etc/apt/keyrings/packages.microsoft.gpg >/dev/null

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" \
| sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt update
sudo apt install -y code
