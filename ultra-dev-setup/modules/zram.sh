#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

log "Configuring ZRAM"

sudo systemctl enable zramswap || true
sudo systemctl start zramswap || true
