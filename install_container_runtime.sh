#!/bin/bash

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

# Verify
lsmod | grep br_netfilter
lsmod | grep overlay
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward







# Install containerd
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md

tar Cxzvf /usr/local https://github.com/containerd/containerd/releases/download/v1.7.7/containerd-1.7.7-linux-amd64.tar.gz

# systemd
# https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
wget -O https://raw.githubusercontent.com/containerd/containerd/main/containerd.service /usr/local/lib/systemd/system/containerd.service

systemctl daemon-reload
systemctl enable --now containerd

# Installing runc
# https://github.com/opencontainers/runc/releases
wget https://github.com/opencontainers/runc/releases/download/v1.1.9/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

# Installing CNI plugins
# https://github.com/containernetworking/plugins/releases
wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.3.0.tgz


# ===== Master =====
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
# export KUBECONFIG=/etc/kubernetes/admin.conf




