unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-vpmframe requires Capistrano 2+"
end

Capistrano::Configuration.instance.load do

namespace :alerts do

  desc "Deploy alert for HipChat"
  task :hipchat, :roles => :app do
    system("curl -s -d 'room_id=#{fetch(:alerts_hipchat_room)}&from=DeployBot&message=\<strong\>#{fetch(:application)}\<\/strong\>+deployed+successfully+to+\<strong\>#{fetch(:app_stage)}\<\/strong\>+at+\<strong\>#{fetch(:app_server)}\<\/strong\>&color=green' https://api.hipchat.com/v1/rooms/message\?auth_token\=#{fetch(:alerts_hipchat_key)}\&format\=json >> /dev/null")
  end

  desc "Deploy alert on Slack"
  task :slack, :roles => :app do
    system("curl -s -X POST --data-urlencode 'payload={\"channel\": \"#{fetch(:alerts_slack_room)}\", \"username\": \"deploybot\", \"text\": \"*#{fetch(:application)}* deployed *#{fetch(:current_revision)}* successfully to *#{fetch(:app_stage)}* at *#{fetch(:app_server)}*\", \"icon_emoji\": \":computer:\"}' #{fetch(:alerts_slack_hook)} > /dev/null")
  end

end

end
