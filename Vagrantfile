Vagrant::Config.run do |config|
  config.vm.provisioner = :chef_solo
  config.chef.cookbooks_path = %w[site-cookbooks cookbooks]
  config.chef.log_level = :debug
  config.vm.forward_port "hudson", 8080, 4088
  config.vm.forward_port "gerrit", 7080, 4070
  config.vm.forward_port "nginx", 80, 4080
  config.vm.forward_port "gerrit-ssh", 29418, 29418
  config.vm.box = "lucid64"
end
