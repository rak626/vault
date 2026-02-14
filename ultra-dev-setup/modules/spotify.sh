#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

if command_exists spotify; then
 log "Spotify already installed"
 exit 0
fi

log "Installing Spotify"

retry curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update
sudo apt install -y spotify-client
