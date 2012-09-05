unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :assets do

  desc "Get (and compile) local clone"
  task :local_temp_clone, :roles => :app do
    # Clear out any existing local clones
    system("rm -rf ~/.captemp")

    # Get the local clone
    system("mkdir -p ~/.captemp")
    system("git clone #{fetch(:repository)} ~/.captemp/#{fetch(:application)}")
	system("cd ~/.captemp/#{fetch(:application)} && git submodule init && git submodule update")
  end

  desc "Upload compiled CSS"
  task :upload_asset_css, :roles => :app do
    # Compile local assets
    system("cd ~/.captemp/#{fetch(:application)} && compass compile -e production --force")

    # Make remote dir
    run "mkdir -p #{release_path}/public/content/themes/#{fetch(:app_theme)}/css/"

    # Upload assets
    system("scp -r -P #{fetch(:app_port)} ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/css #{fetch(:user)}@#{fetch(:app_server)}:#{release_path}/public/content/themes/#{fetch(:app_theme)}/")
  end

  desc "Upload compiled JS"
  task :upload_asset_js, :roles => :app do
    # Compile local assets
    system("cd ~/.captemp/#{fetch(:application)} && jammit -c config/assets.yml")

    # Make remote dir
    run "mkdir -p #{release_path}/public/content/themes/#{fetch(:app_theme)}/js/"

    # Upload assets
    system("scp -r -P #{fetch(:app_port)} ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/js #{fetch(:user)}@#{fetch(:app_server)}:#{release_path}/public/content/themes/#{fetch(:app_theme)}/")
  end

  desc "Upload compiled images"
  task :upload_asset_images, :roles => :app do
    # Compile local assets
    system("cp -R ~/.captemp/#{fetch(:application)}/app/assets/images/ ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/img")
    #system("open -a ImageOptim.app ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/img/*")

    # Make remote dir
    run "mkdir -p #{release_path}/public/content/themes/#{fetch(:app_theme)}/img/"

    system("scp -r -P #{fetch(:app_port)} ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/img #{fetch(:user)}@#{fetch(:app_server)}:#{release_path}/public/content/themes/#{fetch(:app_theme)}/")
  end

  desc "Cleanup local copy"
  task :local_temp_cleanup, :roles => :app do
    system("rm -rf ~/.captemp")
  end

end

end