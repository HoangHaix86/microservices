#!/bin/bash

publickey="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuqWZt6waqg1GMANZsNwLVr8M8CxVWQNc7w2jJfd+QM"

echo "root:vagrant" | sudo chpasswd
sudo usermod -aG sudo vagrant

sudo apt update

sudo apt remove -y openssh-server openssh-client ssh &&
    sudo apt autoremove &&
    sudo apt autoclean

sudo apt update &&
    sudo apt install -y openssh-server

[ -f ~/.ssh/authorized_keys ] && rm ~/.ssh/authorized_keys

echo "$publickey" | tee -a ~/.ssh/authorized_keys

sudo chmod 0700 ~/.ssh
sudo chmod 0600 ~/.ssh/authorized_keys

sudo tee -a /etc/sudoers <<EOF
vagrant ALL=(ALL) NOPASSWD: ALL
EOF

# config UseDNS
sed -ri 's/#?UseDNS.+/UseDNS no/g' /etc/ssh/sshd_config

# 1
sudo apt-get install -y linux-headers-$(uname -r) build-essential dkms

wget https://download.virtualbox.org/virtualbox/7.0.14/VBoxGuestAdditions_7.0.14.iso
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro VBoxGuestAdditions_7.0.14.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions /VBoxLinuxAdditions.run
rm VBoxGuestAdditions_7.0.14.iso
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions

sudo apt autoremove
sudo apt autoclean
sudo apt clean
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
