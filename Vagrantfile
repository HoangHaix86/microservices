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

    MasterCount = 1
    (1..MasterCount).each do | i |
        config.vm.define "k8s-master-#{i}" do | master |
            master.vm.box = "ubuntu-jammy"
            master.vm.hostname = "k8s-master-#{i}"
            master.vm.network "private_network", ip: "172.16.1.#{i}"

            master.vm.provider "virtualbox" do |vb|
                vb.name = "k8s-master-#{i}"
                vb.memory = 4096
                vb.cpus = 2
            end
        end
    end

    WorkerCount = 2
    (1..WorkerCount).each do |i|
        config.vm.define "k8s-worker-#{i}" do |worker|
            worker.vm.box = "ubuntu-jammy"
            worker.vm.hostname = "k8s-worker-#{i}"
            worker.vm.network "private_network", ip: "172.16.2.#{i}"

            worker.vm.provider "virtualbox" do |vb|
                vb.name = "k8s-worker-#{i}"
                vb.memory = 4096
                vb.cpus = 2
            end
        end
    end

    # config.vm.provision "shell", path: "./setup_k8s.sh"
    # config.vm.provision "shell", inline: $script

    config.ssh.username = "jammy"
    config.ssh.private_key_path = "./.ssh/id_rsa"

end
