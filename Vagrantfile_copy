Vagrant.configure("2") do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "monk"

  # Provisioning using a shell script
  config.vm.provision "shell", path: "vagrant_install.sh"
end
