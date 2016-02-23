unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :salts do
  
  desc "Generate new salts"
  task :generate_wp_salts, :roles => :app do
    run "echo '<?php' > #{shared_path}/config/wp-salts.php && curl https://api.wordpress.org/secret-key/1.1/salt >> #{shared_path}/config/wp-salts.php"
  end

  desc "Symlink salts"
  task :symlink_wp_salts, :roles => :app do
    run "ln -nfs #{shared_path}/config/wp-salts.php #{release_path}/config/wp-salts.php"
  end

end

end
