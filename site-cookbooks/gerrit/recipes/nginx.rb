include_recipe "gerrit"
include_recipe "nginx"

nginx_vhost_proxy node[:gerrit][:virtual_host_name] do
  ssl_only false
  upstream ["127.0.0.1:#{node[:gerrit][:port]}"]
end

