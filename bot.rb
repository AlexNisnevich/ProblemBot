require 'slack-ruby-bot'
require 'discordrb'

require_relative 'lib/aops'

DIFFICULTIES = ["easy", "medium", "hard", "very hard"]

aops = AoPS.new

class ProblemSlackBot < SlackRubyBot::Bot
  match /problem\?/ do |client, data, match|
    difficulty = DIFFICULTIES.sample
    DIFFICULTIES.each {|d| difficulty = d if match.string.include?(d) }

    client.say(text: "Let me fetch you a #{difficulty} problem ...", channel: data.channel)

    problem = nil
    problem = aops.get_problem(difficulty) while problem.nil?

    client.say(text: problem[:image_url], channel: data.channel)
    client.say(text: "Solution: #{problem[:url]}", channel: data.channel)
  end
end

if ENV['DISCORD_API_TOKEN'] && ENV['DISCORD_APP_ID']
  bot = Discordrb::Bot.new(token: ENV['DISCORD_API_TOKEN'], application_id: ENV['DISCORD_APP_ID'])
  
  bot.message(end_with: 'problem?') do |event|
    difficulty = DIFFICULTIES.sample
    DIFFICULTIES.each {|d| difficulty = d if event.message.to_s.include?(d) }

    event.respond "Let me fetch you a #{difficulty} problem ..."

    problem = nil
    problem = aops.get_problem(difficulty) while problem.nil?

    event.respond problem[:image_url]
    event.respond "Solution: #{problem[:url]}"
  end
  
  bot.run
else
  ProblemSlackBot.run
end
