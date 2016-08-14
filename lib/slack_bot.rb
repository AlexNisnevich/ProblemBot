require 'slack-ruby-bot'

require_relative 'aops'

$aops = AoPS.new

class ProblemSlackBot < SlackRubyBot::Bot
  match /problem\?/ do |client, data, match|
    difficulty = DIFFICULTIES.sample
    DIFFICULTIES.each {|d| difficulty = d if match.string.include?(d) }

    client.say(text: "Let me fetch you a #{difficulty} problem ...", channel: data.channel)

    problem = nil
    problem = $aops.get_problem(difficulty) while problem.nil?

    client.say(text: problem[:image_url], channel: data.channel)
    client.say(text: "Solution: #{problem[:url]}", channel: data.channel)
  end
end
