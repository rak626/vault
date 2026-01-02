#!/usr/bin/env bash
set -euo pipefail

USER_HOME="/home/rakesh"
TPKG_DIR="$USER_HOME/tpkg"

echo "==== Updating system ===="
sudo apt update
sudo apt upgrade -y

echo "==== Installing base tools ===="
sudo apt install -y \
  git curl wget gpg \
  build-essential vim tmux \
  kitty \
  gnome-tweaks \
  gnome-shell-extension-manager \
  timeshift \
  lolcat \
  ca-certificates apt-transport-https \
  zip unzip tree \
  fzf ripgrep htop bat tldr \
  software-properties-common

# ----------------------------------------------------
# VS CODE (APT REPO)
# ----------------------------------------------------
echo "==== Installing VS Code ===="
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
 | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# ----------------------------------------------------
# SPOTIFY
# ----------------------------------------------------
echo "==== Installing Spotify ===="
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify.gpg
echo "deb [signed-by=/usr/share/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" \
 | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install -y spotify-client

# ----------------------------------------------------
# DISCORD
# ----------------------------------------------------
echo "==== Installing Discord ===="
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y /tmp/discord.deb

# ----------------------------------------------------
# POSTMAN
# ----------------------------------------------------
echo "==== Installing Postman ===="
sudo mkdir -p /opt/postman
wget -qO /tmp/postman.tar.gz https://dl.pstmn.io/download/latest/linux_64
sudo tar -xzf /tmp/postman.tar.gz -C /opt/postman --strip-components=1
sudo ln -sf /opt/postman/Postman /usr/local/bin/postman

# ----------------------------------------------------
# DBeaver
# ----------------------------------------------------
echo "==== Installing DBeaver ===="
wget -O /tmp/dbeaver.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo apt install -y /tmp/dbeaver.deb

# ----------------------------------------------------
# Redis Insight
# ----------------------------------------------------
echo "==== Installing RedisInsight ===="
wget -O /tmp/redisinsight.deb https://downloads.redisinsight.redis.com/latest/redisinsight-linux-amd64.deb
sudo apt install -y /tmp/redisinsight.deb

# ----------------------------------------------------
# BRAVE
# ----------------------------------------------------
echo "==== Installing Brave Browser ===="
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
 | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# ----------------------------------------------------
# GITHUB DESKTOP
# ----------------------------------------------------
echo "==== Installing GitHub Desktop ===="
wget -qO - https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/mwt-desktop.gpg >/dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt-desktop.gpg] https://mirror.mwt.me/shiftkey-desktop/deb/ any main" \
 | sudo tee /etc/apt/sources.list.d/mwt-desktop.list
sudo apt update
sudo apt install -y github-desktop

# ----------------------------------------------------
# DOCKER
# ----------------------------------------------------
echo "==== Installing Docker ===="
sudo apt remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc || true

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
 | sudo tee /etc/apt/keyrings/docker.asc >/dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
 $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
 | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update
sudo apt install -y \
 docker-ce docker-ce-cli containerd.io \
 docker-buildx-plugin docker-compose-plugin

sudo groupadd docker || true
sudo usermod -aG docker "$USER"
sudo systemctl enable docker containerd

# ----------------------------------------------------
# DEV FOLDERS + REPOS
# ----------------------------------------------------
echo "==== Setting up development workspace ===="
mkdir -p "$USER_HOME/development/java" "$USER_HOME/development/js"

cd "$USER_HOME/development/java"
[ ! -d JavaLearning ] && git clone https://github.com/rak626/JavaLearning.git
[ ! -d Spring-Learning ] && git clone https://github.com/rak626/Spring-Learning.git

# ----------------------------------------------------
# JetBrains Toolbox
# ----------------------------------------------------
echo "==== Installing JetBrains Toolbox ===="
JB_DIR="$USER_HOME/.local/share/JetBrains"
mkdir -p "$JB_DIR"

TMP_DIR=$(mktemp -d)
wget -qO "$TMP_DIR/toolbox.tar.gz" https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.5.2.35332.tar.gz
tar -xzf "$TMP_DIR/toolbox.tar.gz" -C "$TMP_DIR"
mv "$TMP_DIR"/jetbrains-toolbox-* "$JB_DIR/toolbox"

# run once to initialize (non-blocking)
("$JB_DIR/toolbox/jetbrains-toolbox" &>/dev/null &)

rm -rf "$TMP_DIR"

# ----------------------------------------------------
# yt-dlp installation
# ----------------------------------------------------
echo "==== Installing yt-dlp ===="
mkdir -p "$TPKG_DIR"
pip3 install --upgrade yt-dlp --break-system-packages
cp "$(which yt-dlp)" "$TPKG_DIR/yt-dlp"

# ----------------------------------------------------
# ZSH + OH MY ZSH
# ----------------------------------------------------
echo "==== Installing Zsh & Oh My Zsh ===="
sudo apt install -y zsh

export RUNZSH=no
export CHSH=no
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "==== Installing Zsh plugins ===="
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || true

# ----------------------------------------------------
# Configure ZSHRC
# ----------------------------------------------------
echo "==== Updating .zshrc ===="

cat >> ~/.zshrc <<'EOF'
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# MP3 download
alias ym='python3 /home/rakesh/tpkg/yt-dlp -x --audio-format mp3 --audio-quality 0 --output "%(title)s.%(ext)s"'
alias yw='python3 /home/rakesh/tpkg/yt-dlp -x --audio-format wav --output "%(title)s.%(ext)s"'
alias yf='python3 /home/rakesh/tpkg/yt-dlp -x --audio-format flac --output "%(title)s.%(ext)s"'

alias pw="poweroff"
alias rb="reboot"
alias updt="sudo apt update && sudo apt upgrade -y"
alias nzsh="nano ~/.zshrc"

# git push helper
gpush() {
  git add .
  git commit -m "$1"
  git push
}

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
EOF

# ----------------------------------------------------
# Install NVM + Node
# ----------------------------------------------------
echo "==== Installing NVM & Node ===="
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.zshrc
nvm install --lts

# ----------------------------------------------------
# Install Bun
# ----------------------------------------------------
echo "==== Installing Bun ===="
curl -fsSL https://bun.sh/install | bash

# ----------------------------------------------------
# Make Zsh Default Shell
# ----------------------------------------------------
echo "==== Setting Zsh as default shell ===="
chsh -s /usr/bin/zsh "$USER"

# ----------------------------------------------------
# FONTS
# ----------------------------------------------------
echo "==== Installing fonts ===="
mkdir -p ~/userconfig
cd ~/userconfig
[ ! -d vault ] && git clone https://github.com/rak626/vault.git
mkdir -p ~/.local/share/fonts
cp -r ~/userconfig/vault/fonts/* ~/.local/share/fonts/
fc-cache -fv

echo "==== DONE ===="
echo "Logout/Login once to enable Docker & Zsh defaults"
