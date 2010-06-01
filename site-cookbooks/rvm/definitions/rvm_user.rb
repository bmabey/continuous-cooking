define :rvm_user, :user => nil, :home => nil, :rubies => [], :gems => {}, :packages => [], :default_ruby => nil do


  package "curl"
  include_recipe "git"

  # TODO: need to ensure proper ordering if 1.9.2, etc is requested...
  #*  If you wish to install rbx and/or any MRI head (eg. 1.9.2-head) then you must install and use rvm 1.8.7 first.

  # *  For MRI & ree (if you wish to use it) you will need:
  %w[bison build-essential zlib1g zlib1g-dev libssl-dev libreadline5-dev 
     libreadline6-dev libxml2-dev git-core subversion autoconf].each do |p|
    package p
  end
  # TODO: add JRuby deps only if jruby is lised as a dep:
  # *  For JRuby (if you wish to use it) you will need:
  #    $ aptitude install curl sun-java6-bin sun-java6-jre sun-java6-jdk
  #

  params[:home] ||= "/home/#{params[:user]}"
  rvm_path  = params[:home] + "/.rvm"
  rvm_script  = rvm_path + "/scripts/rvm"
  default_ruby = params[:default_ruby]
  rubies = (params[:rubies] + [default_ruby]).uniq

  # this works with execute and script resources
  run_as_rvm_user = lambda { |code|
    "su - #{params[:user]} -c bash <<END\nexport rvm_path=#{rvm_path}\nsource #{rvm_script}\n#{code}\nEND" }

  if File.directory? rvm_path
    log("Skipping RVM installation for #{params[:user]} since RVM was detected") { level :debug }
  else
    remote_file "rvm-install" do
      path "/tmp/rvm-install"
      source "http://rvm.beginrescueend.com/releases/rvm-install-head"
      not_if  "test -f /tmp/rvm-install"
      mode 0755
    end

    execute "install rvm for #{params[:user]}" do
      user params[:user]
      environment "HOME" => params[:home]
      command "/tmp/rvm-install"
    end
  end

  # rvm doesn't provide a way to see what packages are installed (yet) so this is needed to tell...
  rvm_package_libs = {"zlib" => "libz.a", "openssl" => "libssl.a",
                      "readline" => "libreadline.so", "iconv" => "libiconv.so", "ncurses" => "libncurses.so"}
  params[:packages].each do |rvm_package|
    execute "install #{rvm_package} with and for rvm as #{params[:user]}" do
      command run_as_rvm_user["rvm package install #{rvm_package}"]
      not_if run_as_rvm_user["test -f #{rvm_path}/usr/lib/#{rvm_package_libs[rvm_package]}"]
    end
  end

  # TODO: if packages are installed we need to use them when installing the rubies...

  execute "update #{params[:user]}'s rvm to the latest stable version" do
    command run_as_rvm_user["rvm update -—head"]
  end

  # TODO: use 'rmv list' to uninstall the uneeded ones and install the new ones
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
    (params[:gems]["all_versions"].dup || {}).to_hash.merge(gems).each do |name, version|
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
