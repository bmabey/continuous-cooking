define :nginx_redirect_proxy, :redirect_url => nil, :listen => [80] do

  raise "redirect_url is required" unless params[:redirect_url]
  name = params[:name]

  include_recipe "nginx"

  template "#{node[:nginx][:dir]}/sites-available/#{name}.conf" do
    source "vhost_redirect.conf.erb"
    cookbook "nginx"
    owner "root"
    group "root"
    mode 0644
    variables(params)
    notifies :restart, resources(:service => "nginx"), :delayed
  end

  nginx_site "#{name}.conf" do
    enable enable_setting
    only_if { File.exists?("#{node[:nginx][:dir]}/sites-available/#{name}") }
  end
end
