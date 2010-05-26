# Cookbook Name:: rvm
# Recipe:: default
# 
# Originally taken from Corey Donohoe's cider/smeagol
# Modified by Ben Mabey to be non-cider specific

DEFAULT_RUBY_VERSION = "1.8.7-p248"

execute "install rvm for the user" do
  command "rvm-install"
  not_if  "test -d ~/.rvm"
end

script "installing ruby" do
  interpreter "bash"
  code <<-EOS
    source ~/.cider.profile
    `rvm list | grep -q '#{DEFAULT_RUBY_VERSION}'`
    if [ $? -ne 0 ]; then
      rvm install #{DEFAULT_RUBY_VERSION}
      rvm use #{DEFAULT_RUBY_VERSION} --default
    fi
  EOS
end

script "updating rvm to the latest stable version" do
  interpreter "bash"
  code <<-EOS
    source ~/.cider.profile
    rvm update -—head
  EOS
end

execute "cleanup rvm build artifacts" do
  command "find ~/.rvm/src -depth 1 | grep -v src/rvm | xargs rm -rf "
end

template "#{ENV['HOME']}/.gemrc" do
  source "dot.gemrc.erb"
end

{ 'bundler' => '0.9.25', 'bundler08' => '0.8.5', 'cider' => '0.1.2',
  'mysql'   => '2.8.1',  'pg' => '0.9.0' }.each do |name, version|
  script "updating to the latest #{name} -> #{version}" do
    interpreter "bash"
    code <<-EOS
      source ~/.cider.profile
      `gem list #{name} | grep -q '#{version}'`
      if [[ $? -ne 0 ]]; then
        gem install #{name} --no-rdoc --no-ri
      fi
    EOS
  end
end
