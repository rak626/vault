#!/usr/bin/env bash
source "$(dirname "$0")/../lib/common.sh"

log "Installing base packages"

sudo apt update

sudo apt install -y \
 build-essential git curl wget unzip \
 ripgrep fd-find htop btop neovim tmux fzf \
 gcc g++ make cmake pkg-config gpg \
 vim gnome-tweaks gnome-shell-extension-manager timeshift lolcat \
 ca-certificates apt-transport-https \
 zip unzip tree bat software-properties-common \
 python3 python3-pip python3-venv zram-tools || true

if ! command_exists fd; then
 sudo ln -sf "$(which fdfind)" /usr/local/bin/fd || true
fi
