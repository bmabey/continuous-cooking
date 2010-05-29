require_recipe "hudson::nginx"
require_recipe "hudson::ruby"
require_recipe "git" # has bash completion
require_recipe "gitosis"
require_recipe "rvm"

