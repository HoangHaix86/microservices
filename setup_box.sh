#!/bin/bash

# change password
sudo echo "root:jammy" | chpasswd
sudo echo "jammy:jammy" | chpasswd

# add user to root group
sudo useradd -aG root jammy

cat >> /etc/sudoers <<EOF
jammy ALL=(ALL) NOPASSWD: ALL
EOF

# config sshd_config
sudo sed -ri "s/#UseDNS no/UseDNS no/" /etc/ssh/sshd_config
sudo sed -ri "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config    
sudo systemctl restart ssh

# config ssh
sudo rm -Rf /home/jammy/.ssh
sudo mkdir /home/jammy/.ssh
sudo wget -O /home/jammy/.ssh/authorized_keys https://raw.githubusercontent.com/HoangHaix86/microservices/main/.ssh/id_rsa.pub
sudo chown -R jammy:jammy /home/jammy/.ssh
sudo chmod 0700 /home/jammy/.ssh
sudo chmod 0600 /home/jammy/.ssh/authorized_keys

# require
sudo apt-get install -y linux-headers-$(uname -r) build-essential dkms

sudo wget https://download.virtualbox.org/virtualbox/7.0.10/VBoxGuestAdditions_7.0.10.iso 
sudo mkdir /media/VBoxGuestAdditions 
sudo mount -o loop,ro VBoxGuestAdditions_7.0.10.iso /media/VBoxGuestAdditions 
sudo sh /media/VBoxGuestAdditions /VBoxLinuxAdditions.run 
sudo rm VBoxGuestAdditions_7.0.10.iso 
sudo umount /media/VBoxGuestAdditions 
sudo rmdir /media/VBoxGuestAdditions

sudo apt update
sudo apt -y full-upgrade
[ -f /var/run/reboot-required ] && sudo reboot -f
