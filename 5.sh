#!/bin/bash

# 2
sudo swapoff -a
sudo sed -i '/swap/s/^/#/' /etc/fstab
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt install containerd.io -y

mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

# 3
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

cat <<EOF | sudo tee -a /etc/hosts
172.16.2.11 k8s-master
172.16.3.11 k8s-worker
EOF

# Init
kubeadm init --control-plane-endpoint=k8s-master:6443 --upload-certs --pod-network-cidr=10.0.0.0/8
kubeadm init --control-plane-endpoint=k8s-master:6443 --upload-certs --pod-network-cidr=10.244.0.0/16


kubeadm join apiserver.lb:6443 --token y8mldi.kyucvfcnolu0kah3 \
	--discovery-token-ca-cert-hash sha256:571e9fa13960dbb197e054e04911e75f4099ce8d2b78e2433faaec7825175a90 \
	--control-plane --certificate-key 0d903aadd253cbac5ddb493cdd22043aa740d05ea59be8ed13dbb060237b0632

kubeadm token create

openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

kubeadm init phase upload-certs --upload-certs

kubeadm join apiserver.lb:6443 --token ut6lja.s6sc4lr8m5zn0pqq \
	--discovery-token-ca-cert-hash sha256:571e9fa13960dbb197e054e04911e75f4099ce8d2b78e2433faaec7825175a90


kubeadm init --control-plane-endpoint=k8s-master:6443 --upload-certs --pod-network-cidr=192.168.0.0/16




















