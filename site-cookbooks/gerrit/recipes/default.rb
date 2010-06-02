#
# Cookbook Name:: gerrit
# Recipe:: default

include_recipe "java"

site_path = node[:gerrit][:install_path] + "/review_site"

user node[:gerrit][:user] do
  shell "/bin/bash"
  home node[:gerrit][:install_path]
end


directory node[:gerrit][:install_path] do
  recursive true
  owner node[:gerrit][:user]
  mode 0700
end

unless FileTest.exists?(site_path)
  remote_file "gerrit" do
    path "/tmp/gerrit.war"
    owner node[:gerrit][:user]
    source "http://gerrit.googlecode.com/files/gerrit-2.1.2.4.war"
    checksum "1815e73be287b9eb8f651c019c9dd0e91e84eb2fc3cd7754a032be375a078787"
  end

  execute "install gerrit" do
    user "gerrit"
    command "java -jar /tmp/gerrit.war init -d #{site_path}"
  end
end

template "#{site_path}/etc/gerrit.config" do
  source "gerrit.config.erb"
  mode 0644
end

template "/etc/default/gerritcodereview" do
  source "etc.default.gerritcodereview.erb"
  mode 0644
end

link "/etc/init.d/gerrit" do
  to "#{site_path}/bin/gerrit.sh"
end

service "gerrit" do
  supports :status => true, :restart => true, :start => true, :stop => true
  status_command "/etc/init.d/gerrit check | grep -q 'Gerrit running pid'"
  action :start
end
