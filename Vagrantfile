# -*- mode: ruby -*-
# vi: set ft=ruby :

VBOX = "chef/ubuntu-14.04"
VMWARE_BOX = "chef/ubuntu-14.04"
MEMORY = "4096"
CPU = "4"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = VBOX
  config.vm.network "public_network"
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", MEMORY ]
    v.customize ["modifyvm", :id, "--cpus", CPU ]
  end
  config.vm.provider "vmware_fusion" do |v, override| 
    override.vm.box = VMWARE_BOX
    v.vmx["memsize"] = MEMORY
    v.vmx["numvcpus"] = CPU
  end
  config.vm.provision "shell", path: "scripts/buildmsf.sh"
end
