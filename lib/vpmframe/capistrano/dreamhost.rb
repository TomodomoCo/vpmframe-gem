unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :dreamhost do

  desc "Copy .htaccess file from previous release"
  task :copy_htaccess, :except => { :no_release => true } do
    run "if [ -f #{previous_release}/public/.htaccess ]; then cp -a #{previous_release}/public/.htaccess #{latest_release}/public/.htaccess; fi"
  end

  desc "Symlink the Let's Encrypt ACME challenge folder"
  task :symlink_letsencrypt, :except => { :no_release => true } do
    run "#{try_sudo} ln -nfs #{shared_path}/config/.well-known #{release_path}/public/.well-known"
  end

end

end
