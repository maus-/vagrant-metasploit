# -*- mode: ruby -*-
# vi: set ft=ruby :

VBOX = "ubuntu_1404"
VBOX_URL = "https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/1/providers/virtualbox.box"
VMWARE_BOX = "ubuntu_1404_fusion"
VMWARE_BOX_URL = "https://vagrantcloud.com/chef/boxes/ubuntu-14.04-i386/versions/1/providers/vmware_desktop.box"
MEMORY = "4096"
CPU = "4"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = VBOX
  config.vm.box_url = VBOX_URL
  config.vm.network "public_network"
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", MEMORY ]
    v.customize ["modifyvm", :id, "--cpus", CPU ]
  end
  config.vm.provider "vmware_fusion" do |v, override| 
    override.vm.box = VMWARE_BOX
    override.vm.box_url = VMWARE_BOX_URL
    v.vmx["memsize"] = MEMORY
    v.vmx["numvcpus"] = CPU
  end
  config.vm.provision "shell", path: "scripts/buildmsf.sh"
end
