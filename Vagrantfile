Vagrant::Config.run do |config|
  config.vm.provisioner = :chef_solo
  config.chef.cookbooks_path = %w[site-cookbooks cookbooks]
  config.vm.forward_port "hudson", 8080, 4088
  config.vm.box = "lucid64"
end
