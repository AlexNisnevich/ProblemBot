require 'slack-ruby-bot'

require_relative 'aops'

$aops = AoPS.new

class ProblemSlackBot < SlackRubyBot::Bot
  match /problem\?/ do |client, data, match|
    $aops.parse_message_and_fetch_problem(match.string) do |text|
      client.say(text: text, channel: data.channel)
    end
  end
end
