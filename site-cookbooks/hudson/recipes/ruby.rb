include_recipe "hudson"

rvm_user do
  user "hudson"
  rubies node[:hudson][:rvm][:rubies]
  packages []
  default_ruby node[:hudson][:rvm][:default_ruby]
  gems node[:hudson][:rvm][:gems]
end

hudson_plugin "ruby" => "1.2", "rubyMetrics" => "1.4", "rake" => "1.6.3"
