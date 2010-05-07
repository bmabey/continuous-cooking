package "gitosis" do
  not_if "test -f /srv/gitosis/.gitosis.conf"
end
execute "initalize gitosis" do
  command "sudo -H -u gitosis gitosis-init < /home/#{node[:gitosis][:admin]}/.ssh/authorized_keys"
  not_if "test -f /srv/gitosis/.gitosis.conf"
end

