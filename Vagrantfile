# -*- mode: ruby -*-
# vi: set ft=ruby :

VBOX = "bento/ubuntu-14.04"
VMWARE_BOX = "bento/ubuntu-14.04"
# Dynamically allocate memory & cpu resources to use half of what
# is available on the host. Change to 1 if you want to go all in.
VM_CPU_UTIL = 2
VM_MEM_UTIL = 2
host = RbConfig::CONFIG['host_os']
if host =~ /darwin/
  CPU = `sysctl -n hw.ncpu`.to_i/VM_CPU_UTIL
  MEMORY = `sysctl -n hw.memsize`.to_i / 1024 / 1024 /VM_MEM_UTIL
elsif host =~ /linux/
  CPU =`nproc`.to_i/VM_CPU_UTIL
  MEMORY = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 /VM_MEM_UTIL
end
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
