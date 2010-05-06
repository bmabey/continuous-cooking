include_recipe "hudson"
include_recipe "nginx"

nginx_vhost_proxy node[:hudson][:domain] do
  ssl_only false
  #root "#{lt_appraiser_dir}/current/public/"
  upstream ["127.0.0.1:#{node[:hudson][:port]}"]
end

