#!/bin/bash

UBUNTU_VERSION=23.10
echo "Ubuntu version: $UBUNTU_VERSION"

usermod --password "$(echo 1 | openssl passwd -1 -stdin)" root

# Firewall
yes y | ufw enable
ufw allow 22

# SSH
apt update
apt remove -y openssh-server
apt install -y openssh-server

# sshd_config
### PermitRootLogin
sed -ri 's/#?PermitRootLogin.+/PermitRootLogin yes/g' /etc/ssh/sshd_config              # Allow root login
sed -ri 's/#?PermitRootLogin.+/#PermitRootLogin yes/g' /etc/ssh/sshd_config             # Not allow root login
sed -ri 's/#?PermitRootLogin.+/PermitRootLogin without-password/g' /etc/ssh/sshd_config # Allow root login only with key

### PubkeyAuthentication
sed -ri 's/#?PubkeyAuthentication.+/PubkeyAuthentication yes/g' /etc/ssh/sshd_config # Allow public key authentication

### PasswordAuthentication
sed -ri 's/#?#PasswordAuthentication.+/PasswordAuthentication no/g' /etc/ssh/sshd_config # Not allow password authentication

systemctl restart sshd

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

apt remove -y curl wget git
apt install -y curl wget git

# ZSH
apt remove -y zsh
apt install -y zsh
chsh -s "$(which zsh)"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

tee -a ~/.zshrc <<EOF
[[ -r ~/Repos/znap/znap.zsh ]] ||
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh

znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-syntax-highlighting
EOF

source ~/.zshrc
