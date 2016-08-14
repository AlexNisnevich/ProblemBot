require 'discordrb'

require_relative 'aops'

class ProblemDiscordBot
  def initialize
    @bot = Discordrb::Bot.new(token: ENV['DISCORD_API_TOKEN'], application_id: ENV['DISCORD_APP_ID'])
    @aops = AoPS.new
    
    @bot.message(end_with: 'problem?') do |event|
      difficulty = DIFFICULTIES.sample
      DIFFICULTIES.each {|d| difficulty = d if event.message.to_s.include?(d) }

      event.respond "Let me fetch you a #{difficulty} problem ..."

      problem = nil
      problem = @aops.get_problem(difficulty) while problem.nil?

      event.respond problem[:image_url]
      event.respond "Solution: #{problem[:url]}"
    end
  end

  def run
    @bot.run
  end
end
