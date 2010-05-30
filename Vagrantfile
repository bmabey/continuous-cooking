Vagrant::Config.run do |config|
  config.vm.provisioner = :chef_solo
  config.chef.cookbooks_path = %w[site-cookbooks cookbooks]
  config.chef.log_level = :info # :debug
  config.vm.forward_port "hudson", 8080, 4088
  config.vm.forward_port "nginx", 80, 4080
  config.vm.box = "lucid64"
end
