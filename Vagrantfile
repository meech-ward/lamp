
IP_ADDR = "192.168.44.10"
HOST_DIR = "./"
VM_DIR =  "/home/vagrant/shared"

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"

  config.vm.network :private_network, ip: IP_ADDR

  config.vm.synced_folder HOST_DIR, VM_DIR

  config.vm.provision "shell", path: "lamp.sh"

end