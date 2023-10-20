# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
echo 132
cat >> /etc/hosts<<EOF
172.16.10.100 master
172.16.10.101 worker-1
172.16.10.102 worker-2
EOF
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu-jammy"
  config.vm.hostname = "master"
  config.vm.network "private_network", ip: "172.16.10.100"
  config.vm.network "forwarded_port", id: 'ssh', guest:22, host: 2222

  config.vm.provision "shell", path: "./setup_k8s.sh"
  config.vm.provision "shell", inline: $script

  config.ssh.private_key_path = "./.ssh/id_rsa"
  config.ssh.username = "jammy"

  config.vm.provider "virtualbox" do |vb, override|
    vb.name = "master"
    vb.cpus = 2
    vb.memory = "4096"
  end


end
