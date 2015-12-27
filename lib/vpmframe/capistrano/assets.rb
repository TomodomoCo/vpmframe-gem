unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :assets do

  ##
  # Download
  ##
  desc "Get local clone"
  task :local_temp_clone, :roles => :app do
    # Get the local clone
    system("git clone -b #{fetch(:branch)} #{fetch(:repository)} #{fetch(:tmpdir)}/#{fetch(:application)}")

    # Update submodules
    system("cd #{fetch(:tmpdir)}/#{fetch(:application)} && git submodule init && git submodule update")
  end

  ##  
  # Compile assets
  ##
  desc "Compile local assets"
  task :compile_local_assets, :roles => :app do
    system("cd #{fetch(:tmpdir)}/#{fetch(:application)} && make assets")
  end

  ##
  # Upload
  ##
  desc "Upload all local assets"
  task :upload_local_assets, :roles => :app do
    upload( "#{fetch(:tmpdir)}/#{fetch(:application)}/public/assets", "#{release_path}/public/", :via => :scp, :recursive => :true )
  end

  ##
  # Cleanup
  ##
  desc "Cleanup local copy"
  task :local_temp_cleanup, :roles => :app do
    system("rm -rf #{fetch(:tmpdir)}")
  end

end

end
