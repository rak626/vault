#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

if command_exists dbeaver; then
 log "DBeaver already installed"
 exit 0
fi

log "Installing DBeaver"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

cd "$TMP_DIR"

retry wget -O dbeaver.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo apt install -y ./dbeaver.deb || sudo apt -f install -y
