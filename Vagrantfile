# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # config.vm.allow_fstab_modification
  # config.vm.allow_hosts_modification
  # config.vm.allowed_synced_folder_types
  # config.vm.base_mac
  # config.vm.base_address
  # config.vm.boot_timeout
  config.vm.box = "ubuntu-jammy"
  # config.vm.box_architecture
  # config.vm.box_check_update
  # config.vm.box_download_checksum
  # config.vm.box_download_checksum_type
  # config.vm.box_download_client_cert
  # config.vm.box_download_ca_cert
  # config.vm.box_download_ca_path
  # config.vm.box_download_disable_ssl_revoke_best_effort
  # config.vm.box_download_options
  # config.vm.box_download_insecure
  # config.vm.box_download_location_trusted
  # config.vm.box_url
  # config.vm.box_version
  # config.vm.cloud_init
  # config.vm.communicator
  # config.vm.disk
  # config.vm.graceful_halt_timeout
  # config.vm.guest
  # config.vm.hostname
  # config.vm.ignore_box_vagrantfile
  config.vm.network "private_network", ip: "192.168.70.40"
  # config.vm.post_up_message
  # config.vm.provider
  # config.vm.provision
  # config.vm.synced_folder
  # config.vm.usable_port_range


  # config.ssh.compression
  # config.ssh.connect_timeout
  # config.ssh.config
  # config.ssh.disable_deprecated_algorithms
  # config.ssh.dsa_authentication
  # config.ssh.export_command_template
  # config.ssh.extra_args
  # config.ssh.forward_agent
  # config.ssh.forward_env
  # config.ssh.forward_x11
  # config.ssh.guest_port
  # config.ssh.host
  # config.ssh.insert_key = false
  # config.ssh.keep_alive
  # config.ssh.keys_only
  # config.ssh.paranoid
  # config.ssh.password
  # config.ssh.port
  config.ssh.private_key_path = "../.ssh/id_rsa"
  # config.ssh.proxy_command
  # config.ssh.pty
  # config.ssh.remote_user
  # config.ssh.shell
  # config.ssh.sudo_command
  config.ssh.username = "jammy"
  # config.ssh.verify_host_key


  #  config.winrm.username
  #  config.winrm.password
  #  config.winrm.host
  #  config.winrm.port
  #  config.winrm.guest_port
  #  config.winrm.transport
  #  config.winrm.basic_auth_only
  #  config.winrm.execution_time_limit
  #  config.winrm.ssl_peer_verification
  #  config.winrm.timeout
  #  config.winrm.max_tries
  #  config.winrm.retry_delay
  #  config.winrm.codepage


  # config.winssh.forward_agent
  # config.winssh.forward_env
  # config.winssh.proxy_command
  # config.winssh.keep_alive
  # config.winssh.shell
  # config.winssh.export_command_template
  # config.winssh.sudo_command
  # config.winssh.upload_directory


  # config.vagrant.host
  # config.vagrant.plugins
  # entry_point
  # sources
  # version
  # config.vagrant.sensitive

  config.vm.provider "vmware_desktop" do |v, override|
    override.vm.box = "ubuntu-jammy"
    v.gui = true
    # v.vmx["displayName"] = "test"
    v.allowlist_verified = true
    v.whitelist_verified = true
    v.vmx["cpuid.coresPerSocket"] = "1"
  end


end
