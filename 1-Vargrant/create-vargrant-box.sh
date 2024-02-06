#!/bin/bash

# Change root password
echo "root:root" | sudo chpasswd

# Remove user hoanghai
killall -u hoanghai && deluser --remove-home hoanghai

# Remove default OpenSSH server
apt remove -y openssh-server && apt autoremove -y && apt autoclean -y

# Remove old configuration
rm -rf /etc/ssh

# Reinstall OpenSSH server
apt install -y openssh-server

# Allow root login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Allow ssh with public key
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

# Disable DNS
sed -i 's/#?UseDNS.+/UseDNS no/g' /etc/ssh/sshd_config

# Setup for Vagrant box
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
