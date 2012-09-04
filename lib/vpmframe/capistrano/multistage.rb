require 'vpmframe/capistrano/common'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

# Specify the app_domain
_cset(:app_domain)       { abort "Please specify the :app_domain." }

# Deploy path (:deploy_to for Capistrano, :app_deploy_to for var consistency w/in wpframe)
_cset :deploy_to,     "/home/#{fetch(:app_user)}/#{fetch(:app_domain)}"
_cset :app_deploy_to, fetch(:deploy_to)

end
