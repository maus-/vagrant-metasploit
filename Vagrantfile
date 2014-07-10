# -*- mode: ruby -*-
# vi: set ft=ruby :

VBOX = "ubuntu_1310"
VBOX_URL = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-1310-i386-virtualbox-puppet.box"
VMWARE_BOX = "ubuntu_1310_fusion"
VMWARE_BOX_URL = "http://shopify-vagrant.s3.amazonaws.com/ubuntu-13.10_vmware.box"
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
    override.vm.box_URL = VMWARE_BOX_URL
    v.vmx["memsize"] = MEMORY
    v.vmx["numvcpus"] = CPU
  end
  config.vm.provision "shell", path: "scripts/buildmsf.sh"
end
