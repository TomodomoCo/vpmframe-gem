unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :alerts do

  desc "Notify Hipchat"
  task :hipchat, :roles => :app do
    system("curl -d 'room_id=#{fetch(:alerts_hipchat_room)}&from=DeployBot&message=(successful)+#{fetch(:application)}+deployed+successfully+to+#{fetch(:app_stage)}&color=green' https://api.hipchat.com/v1/rooms/message\?auth_token\=#{fetch(:alerts_hipchat_key)}\&format\=json")
  end

end

end
