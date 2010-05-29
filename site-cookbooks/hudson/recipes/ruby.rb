include_recipe "hudson"

rvm_user do
  user "hudson"
  rubies %w[1.8.7-p248 1.8.7-p249]
  packages %w[zlib]
  default_ruby "1.8.7-p248"
  gems :all_versions => {'bundler' => '0.9.25', 'bundler08' => '0.8.5'}
end

hudson_plugin "ruby" => "1.2", "rubyMetrics" => "1.4", "rake" => "1.6.3"
