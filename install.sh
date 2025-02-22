# Update packages list and update system
sudo apt update
sudo apt upgrade -y

# Install nala
sudo apt install nala -y

# Installing Essential Programs
sudo nala install kitty gnome-tweaks gnome-shell-extension-manager git curl wget yt-dlp build-essential vim -y

#installing snap packages
sudo snap refresh

sudo snap install code --classic
sudo snap install intellij-idea-community --classic
sudo snap install spotify discord postman
sudo snap install dbeaver-ce
sudo snap install redisinsight
sudo snap install brave

# creating project setup
mkdir ~/development
cd ~/development
mkdir java js

# Add java projects
cd java
git clone https://github.com/rak626/JavaLearning.git
git clone https://github.com/rak626/Spring-Learning.git

cd ~
# Github desktop setup
wget -qO - https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/mwt-desktop.gpg > /dev/null
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt-desktop.gpg] https://mirror.mwt.me/shiftkey-desktop/deb/ any main" > /etc/apt/sources.list.d/mwt-desktop.list'

sudo nala update
sudo nala install github-dektop -y

# docker setup

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo nala update
sudo nala install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo nala update
sudo nala install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# post installation of docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo gpasswd -a $USER docker
newgrp docker
docker run hello-world

# docker configure
sudo systemctl enable docker.service
sudo systemctl enable containerd.service


# install fonts

cd ~
mkdir userconfig
cd userconfig
git clone https://github.com/rak626/vault.git
cp -r ~/userconfig/vault/fonts ~/.local/share/

cd ~
wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
sudo apt update && sudo apt install github-desktop -y
