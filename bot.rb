require_relative 'lib/discord_bot'
require_relative 'lib/slack_bot'

DIFFICULTIES = ["easy", "medium", "hard", "very hard"]

if ENV['DISCORD_API_TOKEN'] && ENV['DISCORD_APP_ID']
  ProblemDiscordBot.run
end

if ENV['SLACK_API_TOKEN']
  ProblemSlackBot.run
end
