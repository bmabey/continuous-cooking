set_unless[:hudson][:port]  = 8080
set_unless[:hudson][:domain]  = "hudson.codebox"
set_unless[:hudson][:git_user_name]  = "Hudson"
set_unless[:hudson][:plugins]  = {"greenballs" => "1.6", "git" => "0.8.3"}
set_unless[:hudson][:apt_repository]  = "hudson-labs" # this version has the most recent builds

set_unless[:hudson][:rvm][:rubies] = %w[1.8.7-p248]
set_unless[:hudson][:rvm][:packages] = %w[zlib]
set_unless[:hudson][:rvm][:default_ruby] = "1.8.7-p248"
set_unless[:hudson][:rvm][:gems] = {"all_versions" => {'bundler' => '0.9.25', 'bundler08' => '0.8.5', 'rake' => '0.8.7'}}
