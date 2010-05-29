set_unless[:hudson][:port]  = 8080
set_unless[:hudson][:domain]  = "hudson.codebox"
set_unless[:hudson][:git_user_name]  = "Hudson"
set_unless[:hudson][:plugins]  = {"greenballs" => "1.6", "git" => "0.8.3"}
