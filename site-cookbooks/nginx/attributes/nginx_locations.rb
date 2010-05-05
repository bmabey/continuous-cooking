nginx Mash.new unless attribute? "nginx"
case platform
when "debian","ubuntu"
  nginx[:dir] = "/etc/nginx"
  nginx[:log_dir] = "/var/log/nginx"
  nginx[:user] = "www-data"
  nginx[:binary]= `which nginx`.chomp!
else
  nginx[:dir] = "/etc/nginx"
  nginx[:log_dir] = "/var/log/nginx"
  nginx[:user] = "www-data"
  nginx[:binary] = `which nginx`.chomp!
end
