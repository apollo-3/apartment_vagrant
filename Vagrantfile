Vagrant.configure(2) do |config|
  config.vm.box = "centos7x64"
  config.vm.box_url = "https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box"
  config.vm.hostname = "apartment-agent"

  # config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.network "private_network", ip: "192.168.33.11"

  # config.vm.network "public_network"

  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.environments_path = "environments"
    chef.roles_path = "roles"
    
    chef.environment = "development"
    chef.add_role "development-server"
  # Edit your git personal info in cookbooks/env/attributes/default.rb
    chef.add_recipe "env::git_configure"
  end  
end