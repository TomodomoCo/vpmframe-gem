require 'guard'

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
    # Clear out any existing local clones
    system("rm -rf ~/.captemp")

    # Get the local clone
    system("mkdir -p ~/.captemp")
    system("git clone #{fetch(:repository)} ~/.captemp/#{fetch(:application)}")

    # Update submodules
    system("cd ~/.captemp/#{fetch(:application)} && git submodule init && git submodule update")
  end


  ##  
  # TODO: Temporary compilation method. Ideally, we just run the Guardfile's :compile group.
  ##

  desc "Compile local images"
  task :compile_local_images, :roles => :app do
    system("cp -R ~/.captemp/#{fetch(:application)}/app/assets/images/ ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/img")
    system("image_optim --no-pngout ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/img/*")
  end

  desc "Compile local JS"
  task :compile_local_js, :roles => :app do
    system("cd ~/.captemp/#{fetch(:application)} && jammit -c config/assets.yml") # Jammit
  end

  desc "Compile local CSS"
  task :compile_local_css, :roles => :app do
    system("cd ~/.captemp/#{fetch(:application)} && compass compile -e production --force") # Compass
  end


  ##
  # Upload
  ##

  desc "Upload compiled CSS"
  task :upload_asset_css, :roles => :app do
    # Make remote dir
    run "mkdir -p #{release_path}/public/content/themes/#{fetch(:app_theme)}/css/"

    # Upload assets
    system("scp -r -P #{fetch(:app_port)} ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/css #{fetch(:user)}@#{fetch(:app_server)}:#{release_path}/public/content/themes/#{fetch(:app_theme)}/")
  end

  desc "Upload compiled JS"
  task :upload_asset_js, :roles => :app do
    # Make remote dir
    run "mkdir -p #{release_path}/public/content/themes/#{fetch(:app_theme)}/js/"

    # Upload assets
    system("scp -r -P #{fetch(:app_port)} ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/js #{fetch(:user)}@#{fetch(:app_server)}:#{release_path}/public/content/themes/#{fetch(:app_theme)}/")
  end

  desc "Upload compiled images"
  task :upload_asset_images, :roles => :app do
    # Make remote dir
    run "mkdir -p #{release_path}/public/content/themes/#{fetch(:app_theme)}/img/"

    system("scp -r -P #{fetch(:app_port)} ~/.captemp/#{fetch(:application)}/public/content/themes/#{fetch(:app_theme)}/img #{fetch(:user)}@#{fetch(:app_server)}:#{release_path}/public/content/themes/#{fetch(:app_theme)}/")
  end


  ##
  # Cleanup
  ##

  desc "Cleanup local copy"
  task :local_temp_cleanup, :roles => :app do
    system("rm -rf ~/.captemp")
  end

end

end
