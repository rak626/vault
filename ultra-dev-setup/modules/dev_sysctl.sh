#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

log "Applying dev sysctl"

sudo tee /etc/sysctl.d/60-dev.conf <<EOF
fs.inotify.max_user_watches=1048576
fs.inotify.max_user_instances=1024
vm.swappiness=10
vm.max_map_count=262144
net.core.somaxconn=4096
EOF

sudo sysctl --system || true
