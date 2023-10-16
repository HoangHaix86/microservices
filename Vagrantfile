ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
    config.vm.hostname = "master"
    config.vm.network "private_network", ip: "192.168.0.1", hostname: true

    config.vm.provider "vmware_desktop" do |vmware|
        vmware.vmx["displayName"] = "vagrant-vm"
    endhttps://developer.hashicorp.com/vagrant/docs/providers/basic_usage
end