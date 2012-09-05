require 'vpmframe/capistrano/common'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

_cset(:project_yml_path)  { abort "Please specify the :project_yml_path." }
project  = YAML.load_file(fetch(:project_yml_path))

# Default options
_cset :scm,                   "git"
_cset :git_enable_submodules, 1
_cset :stages,                ["staging", "production"]
_cset :default_stage,         "staging"

# App settings
_cset(:application)       { project["application"]["name"] }
_cset(:app_name)          { project["application"]["name"] }
_cset(:user)              { project["application"]["deploy_user"] }
_cset(:app_user)          { project["application"]["user"] }
_cset(:app_group)         { project["application"]["group"] }
_cset(:app_access_users)  { project["application"]["access_users"] }
_cset(:app_theme)         { project["application"]["theme"] }
_cset(:repository)        { project["application"]["repo"] }
_cset(:site_domain)       { project["application"]["domain"] }

end
