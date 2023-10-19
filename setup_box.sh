#!/bin/bash

echo "root:jammy" | chpasswd
echo "jammy:jammy" | chpasswd

cat >> /etc/sudoers <<EOF
jammy ALL=(ALL) NOPASSWD: ALL
EOF

sed -ri "s/#UseDNS no/UseDNS no/" /etc/ssh/sshd_config

rm -Rf /home/jammy/.ssh
mkdir /home/jammy/.ssh
wget -O /home/jammy/.ssh/authorized_keys https://raw.githubusercontent.com/HoangHaix86/microservices/main/.ssh/id_rsa.pub
chown -R jammy:jammy /home/jammy/.ssh
chmod 0700 /home/jammy/.ssh
chmod 0600 /home/jammy/.ssh/authorized_keys

apt-get install -y linux-headers-$(uname -r) build-essential dkms

wget https://download.virtualbox.org/virtualbox/7.0.10/VBoxGuestAdditions_7.0.10.iso 
sudo mkdir /media/VBoxGuestAdditions 
sudo mount -o loop,ro VBoxGuestAdditions_7.0.10.iso /media/VBoxGuestAdditions 
sudo sh /media/VBoxGuestAdditions /VBoxLinuxAdditions.run 
rm VBoxGuestAdditions_7.0.10.iso 
sudo umount /media/VBoxGuestAdditions 
sudo rmdir /media/VBoxGuestAdditions
