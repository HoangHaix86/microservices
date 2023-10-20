#!/bin/bash

# ============================= 0 =============================

# Set up hostnames
sudo hostnamectl set-hostname "worker-1"
exec bash

# config /etc/hosts
cat <<EOF | sudo tee /etc/hosts
172.16.10.100 master
172.16.10.101 worker-1
172.16.10.102 worker-2
EOF

# Disable swap
sudo swapoff -
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Set up the IPV4 bridge on all nodes
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
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

# Install kubelet, kubeadm, and kubectl on each node
# https://www.cherryservers.com/blog/install-kubectl-ubuntu#method-2---install-kubectl-using-apt
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install kubectl

# ============================= 1 =============================
sudo apt update

# install docker
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker

# install kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

sudo apt update
sudo apt install kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo kubeadm init