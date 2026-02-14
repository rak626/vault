#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

if command_exists brave-browser; then
 log "Brave already installed"
 exit 0
fi

log "Installing Brave"

sudo apt install curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

sudo apt update

sudo apt install brave-browser -y
