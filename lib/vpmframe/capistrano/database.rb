require 'vpmframe/capistrano/common'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

_cset(:database_yml_path) { abort "Please specify the :database_yml_path." }
database = YAML.load_file(fetch(:database_yml_path))

# Pull in DB config
_cset :db_name,     database[fetch(:app_stage)]["name"]
_cset :db_user,     database[fetch(:app_stage)]["user"]
_cset :db_password, database[fetch(:app_stage)]["password"]
_cset :db_host,     database[fetch(:app_stage)]["host"]
_cset :db_grant_to, database[fetch(:app_stage)]["grant_to"]

end
