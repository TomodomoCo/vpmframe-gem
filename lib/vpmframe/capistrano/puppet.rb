unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :puppet do

  desc "Set up puppet"
  task :show, :roles => :app do
    # Remove any existing directories, so we can reupload them
    run "rm -rf /home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}"

    # Make the directory again
    run "mkdir -p /home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}"

    # Upload the configurations
    upload("./config/erb-render.rb", "/home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}/erb-render.rb", :via => :scp)
    upload("./config/puppet", "/home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}", :via => :scp, :recursive => :true)
    upload("./config/nginx", "/home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}/nginx", :via => :scp, :recursive => :true)
    upload("./config/php", "/home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}/php", :via => :scp, :recursive => :true)
    upload("./config/scripts", "/home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}/scripts", :via => :scp, :recursive => :true)
    upload("./config/varnish", "/home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}/varnish", :via => :scp, :recursive => :true)

    # Render the manifest
    puppet_manifest = ERB.new(File.read("./config/puppet/site.pp.erb")).result(binding)
    put puppet_manifest, "/home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}/site.pp"

    # Apply the manifest
    run "#{try_sudo} puppet apply /home/#{fetch(:user)}/tmp/#{fetch(:app_name)}/#{fetch(:app_stage)}/site.pp"
  end

end

end
