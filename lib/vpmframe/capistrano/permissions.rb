unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :permissions do

  desc "Fix ownership on setup"
  task :fix_setup_ownership, :roles => :app do
    run "#{sudo} chown #{app_user}:#{app_group} #{deploy_to}"
    run "#{sudo} chown -R #{user}:#{user} #{deploy_to}/releases #{deploy_to}/shared #{deploy_to}/shared/system #{deploy_to}/shared/log #{deploy_to}/shared/pids"
    run "#{sudo} chmod -R g+s #{deploy_to}/releases #{deploy_to}/shared #{deploy_to}/shared/system #{deploy_to}/shared/log #{deploy_to}/shared/pids"
  end

  desc "Fix ownership on deploy"
  task :fix_deploy_ownership, :roles => :app do
    run "#{sudo} chown --dereference -RL #{app_user}:#{app_group} #{deploy_to}/current/public"
    run "#{sudo} chmod -R g+s #{deploy_to}/current/public"
  end

end

end
