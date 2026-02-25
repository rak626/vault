# Linux Setup Guide

## firefox setup

- go to

        about:config

- full screen warning remove 

        full-screen-api.warning.timeout

- full screen warning delay remove 

        full-screen-api.warning.delay

- alt key problem fixed

        ui.key.menuAccessKeyFocuses

---
## Docker user add

    sudo usermod -aG docker $USER

---

## Github SSH key Setup

- create ssh key

        ssh-keygen -t ed25519 -C "rakeshacot@gmail.com"

- start ssh key
    
        eval "$(ssh-agent -s)"

- add ssh key to agent

        ssh-add ~/.ssh/id_ed25519

- copy the ssh key to add it in Github

        cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard


## Git setup local

- sample setup to change from http to ssh

        git remote set-url origin git@github.com:rak626/vault.git

- global setup for git (local)

        git config --global user.email "rakeshacot@gmail.com"
        git config --global user.name "rak626"