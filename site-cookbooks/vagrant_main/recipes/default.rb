require_recipe "hudson::nginx"
require_recipe "hudson::ruby"
require_recipe "gitosis"

# During bootstrap the restarting of Hudson after plugins are installed leaves it in a bad state...
service "hudson" do
  action :start
  only_if "/etc/init.d/hudson status | grep -q 'Hudson is not running'"
end
