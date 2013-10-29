unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :composer do

  desc "Copy vendors from previous release"
  task :copy_vendors, :except => { :no_release => true } do
    run "if [ -d #{previous_release}/vendor/composer ]; then cp -a #{previous_release}/vendor/composer #{latest_release}/vendor/composer; fi"
  end

  desc "Run composer install"
  task :install, :except => { :no_release => true } do
    run "cd #{release_path} && composer install"
  end

end

end