define :nginx_vhost_proxy, :log_path => "/var/log/nginx/", :root => nil, :ssl => false, :ssl_only => false, :listen => nil, :upstream => [], :auth_basic => nil, :auth_basic_user_file => nil do

  name = params[:name]
  listen ||= (params[:ssl_only] ? [443] : (params[:ssl] ? [80, 443] : [80]))

  listen = params[:listen] || (params[:ssl_only] ? [443] : [80])
  include_recipe "nginx"

  template "#{node[:nginx][:dir]}/sites-available/#{name}.conf" do
    source "vhost_proxy.conf.erb"
    cookbook "nginx"
    owner "root"
    group "root"
    mode 0644
    variables(
      :name                 => name,
      :error_log            => "#{params[:log_path]}/#{name}-error.log",
      :access_log           => "#{params[:log_path]}/#{name}-access.log",
      :domains              => params[:domains],
      :root                 => params[:root],
      :listen               => listen,
      :upstream             => params[:upstream],
      :ssl                  => params[:ssl] || params[:ssl_only],
      :ssl_cert             => params[:ssl_cert] || "/etc/ssl_certs/#{name}.crt",
      :ssl_cert_key         => params[:ssl_cert_key] || "/etc/ssl_certs/#{name}.key",
      :auth_basic           => params[:auth_basic],
      :auth_basic_user_file => params[:auth_basic_user_file],
      :params     => params
    )
    notifies :restart, resources(:service => "nginx"), :delayed
  end

  nginx_site "#{name}.conf" do
    enable enable_setting
    only_if { File.exists?("#{node[:nginx][:dir]}/sites-available/#{name}") }
  end
end
