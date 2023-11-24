#!/bin/bash

sudo apt-get update
sudo apt-get install -y bash-completion
sudo apt-get install -y git
sudo apt-get install -y openssh-server

# change password root
usermod --password $(echo 1 | openssl passwd -1 -stdin) root

# firewall
yes y | sudo ufw enable
sudo ufw status
sudo ufw status verbose
sudo ufw allow 22

# sshd_config
### PermitRootLogin
sudo sed -ri 's/#?PermitRootLogin.+/PermitRootLogin yes/g' /etc/ssh/sshd_config # Allow root login
sudo sed -ri 's/#?PermitRootLogin.+/#PermitRootLogin yes/g' /etc/ssh/sshd_config # Not allow root login
sudo sed -ri 's/#?PermitRootLogin.+/PermitRootLogin without-password/g' /etc/ssh/sshd_config # Allow root login only with key

### PubkeyAuthentication
sudo sed -ri 's/#?PubkeyAuthentication.+/PubkeyAuthentication yes/g' /etc/ssh/sshd_config # Allow public key authentication

### PasswordAuthentication
sudo sed -ri 's/#?#PasswordAuthentication.+/PasswordAuthentication no/g' /etc/ssh/sshd_config # Allow public key authentication

sudo systemctl restart sshd

sudo mkdir -p -m 700 ~/.ssh
sudo touch ~/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/authorized_keys

## Github
ssh-keygen -t ed25519 -C 'hai.hoang.2762@gmail.com' -f ~/.ssh/id_ed25519 -q -N ''
cat ~/.ssh/id_ed25519.pub

## Dotnet
apt-get install -y dotnet-sdk-7.0
apt-get install -y nginx

sudo tee /etc/nginx/sites-available/test.conf <<EOF
server {
    listen        80;
    server_name   192.168.245.130;
    location / {
        proxy_pass         http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade \$http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
}
EOF
sudo ln -s /etc/nginx/sites-available/test.conf /etc/nginx/sites-enabled/test.conf
sudo nginx -s reload
