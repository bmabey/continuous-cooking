directory "/home/hudson" do
  recursive true
  owner "hudson"
  mode 0700
end

# git requires that a user be set to checkout...
template "/home/hudson/.gitconfig" do
  owner "hudson"
  source "dot.gitconfig.erb"
  only_if "which git"
end

case node.platform
when "ubuntu"
  include_recipe "apt"
  package "wget"

  execute "wget -O - http://hudson-ci.org/debian/hudson-ci.org.key | apt-key add -" do
    not_if "apt-key finger | grep '150F DE3F 7787 E7D1 1EF4  E12A 9B7D 32F2 D505 82E6'"
  end

  remote_file "/etc/apt/sources.list.d/huson-ci.org.list" do
    mode "0644"
    source "hudson-ci.org.list"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
end

package "hudson" do
  action :upgrade
end
