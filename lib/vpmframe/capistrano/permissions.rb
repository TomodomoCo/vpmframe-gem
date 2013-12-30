unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :permissions do

  desc "Fix ownership on setup"
  task :fix_setup_ownership, :roles => :app do
    run "#{try_sudo} chown #{app_user}:#{app_group} #{deploy_to}"
    run "#{try_sudo} mkdir -p #{deploy_to}/shared/config"
    run "#{try_sudo} chown -R #{user}:#{user} #{deploy_to}/releases #{deploy_to}/shared #{deploy_to}/shared/system #{deploy_to}/shared/log #{deploy_to}/shared/pids"
    run "#{try_sudo} find #{deploy_to} -type d -exec chmod g+s '{}' \\;"
  end

  desc "Fix ownership on deploy"
  task :fix_deploy_ownership, :roles => :app do
    run "#{try_sudo} chown --dereference -RL #{app_user}:#{app_group} #{deploy_to}/current/public"
  end

end

end
