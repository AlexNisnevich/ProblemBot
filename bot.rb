require_relative 'lib/discord_bot'
require_relative 'lib/slack_bot'

if ENV['DISCORD_API_TOKEN'] && ENV['DISCORD_APP_ID']
  ProblemDiscordBot.run(ENV['DISCORD_API_TOKEN'], ENV['DISCORD_APP_ID'])
end

if ENV['SLACK_API_TOKEN']
  ProblemSlackBot.run  # slack_ruby_bot gem uses ENV['SLACK_API_TOKEN']
end
