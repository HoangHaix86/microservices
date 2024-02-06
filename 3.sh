#!/bin/bash

# Disable swap
sudo swapoff -a
sudo sed -i '/swap/s/^/#/' /etc/fstab

# ____ Config Hosts ____
cat <<EOF | sudo tee -a /etc/hosts
# K8s
172.16.2.11 k8s-master
172.16.3.11 k8s-worker
EOF

# ____ Config Container Runtime Interface (CRI) ____

# Forwarding IPv4 and letting iptables see bridged traffic
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# ____ Containerd ____
# Uninstall Docker Engine
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Set up the repository
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update

sudo apt-get install -y containerd.io

# ____ Kubernetes ____
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

#
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
# sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options\]/a \ \ \ \ SystemdCgroup = true' /etc/containerd/config.toml
sudo systemctl restart containerd

sudo apt install -y zsh
curl -sSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --skip-chsh

sudo tee -a ~/.zshrc <<EOF
# Znap
[[ -r ~/Repos/znap/znap.zsh ]] ||
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh

znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-syntax-highlighting

# kubectl
source <(kubectl completion zsh)
source <(kubeadm completion zsh)
EOF

source "~/.zshrc"


