user "hudson" do
  home "/home/hudson"
  shell "/bin/bash"
end

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

  apt_repo = node[:hudson][:apt_repository]
  execute "wget -O - http://#{apt_repo}.org/debian/#{apt_repo}.org.key | apt-key add -" do
    not_if "apt-key finger | grep '150F DE3F 7787 E7D1 1EF4  E12A 9B7D 32F2 D505 82E6'"
  end

  remote_file "/etc/apt/sources.list.d/huson-ci.org.list" do
    mode "0644"
    source "#{apt_repo}.org.list"
    #checksum "eb072c6240d248e8343e3724595865c6c68bb42f5838762b5389edefdd917759"
    #not_if "test -f /etc/apt/sources.list.d/#{apt_repo}.org.list"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
end

package "hudson" do
  action :upgrade
end

service "hudson" do
  supports :status => true, :restart => true, :start => true, :stop => true
  status_command "/etc/init.d/hudson status | grep 'Hudson is running'"
  action :start
end

hudson_plugin node[:hudson][:plugins]

link "/home/hudson/lib" do
  to "/var/lib/hudson"
end
