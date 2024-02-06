#!/bin/bash


stream {
  upstream kubernetes {
    server 172.16.2.11:6443 max_fails=3 fail_timeout=30s;
    server 172.16.2.12:6443 max_fails=3 fail_timeout=30s;
    server 172.16.2.13:6443 max_fails=3 fail_timeout=30s;
  }

  server {
    listen 6443;
    listen 443;
    proxy_pass kubernetes;
  }
}

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

# Install containerd
wget https://github.com/containerd/containerd/releases/download/v1.7.13/containerd-1.7.13-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.7.13-linux-amd64.tar.gz

# Systemd
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service \
  -O /etc/systemd/system/containerd.service

systemctl daemon-reload
systemctl enable --now containerd

# Installing runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64 \
  && install -m 755 runc.amd64 /usr/local/sbin/runc

# Install cni plugins
wget https://github.com/containernetworking/plugins/releases/download/v1.4.0/cni-plugins-linux-amd64-v1.4.0.tgz \
 && mkdir -p /opt/cni/bin \
 && tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz

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

kubeadm init --control-plane-endpoint=k8s-master:6443 --upload-certs --pod-network-cidr=10.0.0.0/8

kubeadm join apiserver.lb:6443 --token y8mldi.kyucvfcnolu0kah3 \
	--discovery-token-ca-cert-hash sha256:571e9fa13960dbb197e054e04911e75f4099ce8d2b78e2433faaec7825175a90 \
	--control-plane --certificate-key 0d903aadd253cbac5ddb493cdd22043aa740d05ea59be8ed13dbb060237b0632

kubeadm token create

openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

kubeadm init phase upload-certs --upload-certs

kubeadm join apiserver.lb:6443 --token ut6lja.s6sc4lr8m5zn0pqq \
	--discovery-token-ca-cert-hash sha256:571e9fa13960dbb197e054e04911e75f4099ce8d2b78e2433faaec7825175a90


kubeadm init --control-plane-endpoint=k8s-master:6443 --upload-certs --pod-network-cidr=192.168.0.0/16




















