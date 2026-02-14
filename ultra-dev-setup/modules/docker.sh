#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

if systemctl is-active docker >/dev/null 2>&1; then
 log "Docker already running"
 exit 0
fi

log "Installing Docker"

sudo mkdir -p /etc/apt/keyrings

retry curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| sudo tee /etc/apt/keyrings/docker.asc >/dev/null

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker "$USER"
sudo systemctl enable docker
sudo systemctl start docker
