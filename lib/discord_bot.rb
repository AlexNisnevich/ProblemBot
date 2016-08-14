require 'discordrb'

require_relative 'aops'

class ProblemDiscordBot
  def initialize(token, app_id)
    @bot = Discordrb::Bot.new(token: token, application_id: app_id)
    @aops = AoPS.new
  end

  def run
    @bot.message(end_with: 'problem?') do |event|
      @aops.parse_message_and_fetch_problem(event.message) do |text|
        event.respond text
      end
    end

    @bot.run
  end
end
