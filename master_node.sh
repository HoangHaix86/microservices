#!/bin/bash

# Enable kubelet service.
sudo systemctl enable kubelet
sudo kubeadm config images pull

# CRI-O
sudo kubeadm config images pull --cri-socket /var/run/crio/crio.sock

# Containerd
sudo kubeadm config images pull --cri-socket /run/containerd/containerd.sock

# Docker
sudo kubeadm config images pull --cri-socket /run/cri-dockerd.sock 

# /etc/hosts
172.29.20.5 k8s-cluster.master-01

# Select
# CRI-O
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket /var/run/crio/crio.sock \
  --upload-certs \
  --control-plane-endpoint=k8s-cluster.computingforgeeks.com

# Containerd
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket /run/containerd/containerd.sock \
  --upload-certs \
  --control-plane-endpoint=k8s-cluster.computingforgeeks.com

# Docker
# Must do https://computingforgeeks.com/install-mirantis-cri-dockerd-as-docker-engine-shim-for-kubernetes/
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket /run/cri-dockerd.sock  \
  --upload-certs \
  --control-plane-endpoint=k8s-cluster.computingforgeeks.com


mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubeadm join k8s-cluster.computingforgeeks.com:6443 --token sr4l2l.2kvot0pfalh5o4ik \
    --discovery-token-ca-cert-hash sha256:c692fb047e15883b575bd6710779dc2c5af8073f7cab460abd181fd3ddb29a18 \
    --control-plane 






















