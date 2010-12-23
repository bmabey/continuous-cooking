package "git-core"
require_recipe "hudson::nginx"
require_recipe "hudson::ruby"
require_recipe "hudson::headless"
require_recipe "gitosis"
require_recipe "postfix"
require_recipe "gerrit::nginx"

hudson_plugin "gerrit" => "0.4"
