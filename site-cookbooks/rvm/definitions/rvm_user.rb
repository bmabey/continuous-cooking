define :rvm_user, :user => nil, :home => nil, :rubies => [], :gems => {}, :packages => [], :default_ruby => nil do

  package "curl"

  params[:home] ||= "/home/#{params[:user]}"
  rvm_script  = params[:home] + "/.rvm/scripts/rvm"
  default_ruby = params[:default_ruby]
  rubies = (params[:rubies] + [default_ruby]).uniq

  # this works with execute and script resources
  run_as_rvm_user = lambda { |code| "su - #{params[:user]} -c bash <<END\nsource #{rvm_script}\n#{code}\nEND" }

  execute "install rvm for #{params[:user]}" do
    user params[:user]
    environment "HOME" => params[:home]
    command "bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head"
    not_if  "test -d #{params[:home]}/.rvm"
  end

  # rvm doesn't provide a way to see what packages are installed (yet) so this is needed to tell...
  rvm_package_libs = {"zlib" => "libz.a", "openssl" => "libssl.a",
                      "readline" => "libreadline.so", "iconv" => "libiconv.so", "ncurses" => "libncurses.so"}
  params[:packages].each do |rvm_package|
    execute "install #{rvm_package} with and for rvm as #{params[:user]}" do
      command run_as_rvm_user["rvm package install #{rvm_package}"]
      not_if run_as_rvm_user["test -f #{params[:home]}/.rvm/usr/lib/#{rvm_package_libs[rvm_package]}"]
    end
  end

  execute "update #{params[:user]}'s rvm to the latest stable version" do
    command run_as_rvm_user["rvm update -—head"]
  end

  rubies.each do |ruby_version|
    execute "installing ruby #{ruby_version}" do
      command(run_as_rvm_user["rvm install #{ruby_version}"])
      not_if run_as_rvm_user["rvm list | grep -q '#{ruby_version}'"]
    end
  end

  if default_ruby
    execute "set #{params[:user]}'s default ruby is set to #{default_ruby}" do
      command(run_as_rvm_user["rvm use #{default_ruby} --default"])
      not_if run_as_rvm_user[%Q[rvm list default | grep -q "#{default_ruby}"]]
    end
  end

# TODO: update for linux and run only after installs...
#  execute "cleanup rvm build artifacts for #{params[:user]}" do
#    user params[:user]
#    command "find #{params[:home]}/.rvm/src -depth 1 | grep -v src/rvm | xargs rm -rf "
#  end

##  template "#{params[:home]}/.gemrc" do
##   source "dot.gemrc.erb"
##  end
#
  rubies.each do |ruby_version|
    gems = params[:gems][ruby_version] || {}
    (params[:gems][:all_versions] || {}).merge(gems).each do |name, version|
      execute "install as #{params[:user]} gem: #{name} -> #{version} for ruby #{ruby_version}" do
        command(run_as_rvm_user[<<-EOS])
          rvm use #{ruby_version}
          gem install #{name} --version #{version} --no-rdoc --no-ri
        EOS
        not_if(run_as_rvm_user[<<-EOS])
          rvm use #{ruby_version}
          gem list #{name} | grep -q '#{version}'
        EOS
      end
    end
  end

end
