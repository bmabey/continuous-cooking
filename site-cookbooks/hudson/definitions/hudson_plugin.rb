define :hudson_plugin do
  plugin_dir = "/var/lib/hudson/plugins"

  plugins_to_install = params[:name].select do |plugin_name, version|
    manifest = "#{plugin_dir}/#{plugin_name}/META-INF/MANIFEST.MF"
    !(File.exist?(manifest) && File.read(manifest)["Plugin-Version: #{version.strip}"])
  end

  plugins_to_install.each do |plugin_name, version|
    execute "remove previous Hudson plugin version: #{plugin_name}" do
      user "hudson"
      command "rm #{plugin_dir}/#{plugin_name}.hpi"
      only_if "test -f #{plugin_dir}/#{plugin_name}.hpi"
    end
    remote_file "#{plugin_dir}/#{plugin_name}.hpi" do
      owner "hudson"
      source "http://hudson-ci.org/download/plugins/#{plugin_name}/#{version}/#{plugin_name}.hpi"
    end
  end

  execute("/etc/init.d/hudson restart") unless plugins_to_install.empty?
end

