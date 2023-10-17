# Local

## Windows

    ```
    ubuntu22 - HoangHai!@#
    ```

1. Setup
    - https://developer.hashicorp.com/vagrant/downloads
    - https://developer.hashicorp.com/vagrant/downloads/vmware
    - https://developer.hashicorp.com/packer/downloads?product_intent=packer

2. Create Box VMWare
    ```shell
    apt install open-vm-tools

    mkdir -p 0700 ~/.ssh
    touch ~/.ssh/authorized_keys
    chmod 0600 ~/.ssh/authorized_keys

    echo "hoanghai  ALL=(ALL:ALL)   NOPASSWD:ALL" >> /etc/sudoers

    sed -ri "s/#UseDNS no/UseDNS no/" /etc/ssh/sshd_config
    systemctl restart ssh

    ```