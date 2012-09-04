require 'capistrano/vpmframe/common'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

# Default options
_cset :scm,                   :git
_cset :git_enable_submodules, 1
_cset :stages,                ["staging", "production"]
_cset :default_stage,         "staging"

# App settings
_cset :application,      project["application"]["name"]
_cset :app_name,         project["application"]["name"]
_cset :user,             project["application"]["deploy_user"]
_cset :app_user,         project["application"]["user"]
_cset :app_group,        project["application"]["group"]
_cset :app_access_users, project["application"]["access_users"]
_cset :app_theme,        project["application"]["theme"]
_cset :repository,       project["application"]["repo"]
_cset :site_domain,      project["application"]["domain"]
_cset :app_domain,       "#{app_stage}." + project["application"]["domain"]

# Pull in DB config
_cset :db_name,     database[fetch(:app_stage)]["name"]
_cset :db_user,     database[fetch(:app_stage)]["user"]
_cset :db_password, database[fetch(:app_stage)]["password"]
_cset :db_host,     database[fetch(:app_stage)]["host"]
_cset :db_grant_to, database[fetch(:app_stage)]["grant_to"]

# Deploy path (:deploy_to for Capistrano, :app_deploy_to for var consistency w/in wpframe)
_cset :deploy_to,     "/home/#{fetch(:app_user)}/#{fetch(:app_domain)}"
_cset :app_deploy_to, fetch(:deploy_to)

end