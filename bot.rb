require 'slack-ruby-bot'
require 'mechanize'
require 'imgkit'
require 'upload_image'
require 'discordrb'

DIFFICULTIES = ["easy", "medium", "hard", "very hard"]
$index_page = Mechanize.new.get('http://www.artofproblemsolving.com/wiki/index.php?title=AMC_Problems_and_Solutions')

def get_problem(difficulty)
  if difficulty == "easy"
    competition_page = $index_page.links.find {|l| l.text.include?('AMC 10')}.click
    year_page = competition_page.links.find_all {|l| l.text =~ /AMC 10[A|B]/}.sample.click
    problem_page = year_page.links.find_all {|l| l.text.include? 'Problem'}.sample.click
    solution_url = problem_page.uri.to_s
  elsif difficulty == "medium"
    competition_page = $index_page.links.find {|l| l.text.include?('AMC 12')}.click
    year_page = competition_page.links.find_all {|l| l.text =~ /AMC 12[A|B]/}.sample.click
    problem_page = year_page.links.find_all {|l| l.text.include? 'Problem'}.sample.click
    solution_url = problem_page.uri.to_s
  elsif difficulty == "hard"
    competition_page = $index_page.links.find {|l| l.text.include? 'AIME'}.click
    year_page = competition_page.links.find_all {|l| l.text =~ /AIME I/}.sample.click
    problem_page = year_page.links.find_all {|l| l.text.include? 'Problem'}.sample.click
    solution_url = problem_page.uri.to_s
  elsif difficulty == "very hard"
    competition_page = $index_page.links.find {|l| l.text.include? 'USAMO'}.click
    year_page = competition_page.links.find_all {|l| l.text =~ /^\d{4}/}.sample.click
    problem_page = year_page.links.find_all {|l| l.text.include?('Problems/Problem') || l.text =~ /Problem \d/ || l.text == 'Solution'}.sample.click rescue return
  else
    raise "Must specify a difficulty"
  end

  problem_query = "//div[@id='mw-content-text']//*[self::p|self::div][count(preceding::*[contains(text(), 'Solution')])=0]"
  problem_page.search('#toc').remove
  problem_html = problem_page.parser
                             .xpath(problem_query).to_s
                             .gsub('"//', '"http://')
  return if problem_html.empty?

  IMGKit.new(problem_html, width: 600).to_file('out/problem.jpg')
  uploaded = Upload::ImageForrest.new("out/problem.jpg").upload

  {
    url: problem_page.uri.to_s,
    image_url: uploaded.url,
    image_html: problem_html,
    year: year_page.uri.to_s
  }
end

class ProblemSlackBot < SlackRubyBot::Bot
  match /problem\?/ do |client, data, match|
    difficulty = DIFFICULTIES.sample
    DIFFICULTIES.each {|d| difficulty = d if match.string.include?(d) }

    client.say(text: "Let me fetch you a #{difficulty} problem ...", channel: data.channel)

    problem = nil
    problem = get_problem(difficulty) while problem.nil?

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
    problem = get_problem(difficulty) while problem.nil?

    event.respond problem[:image_url]
    event.respond "Solution: #{problem[:url]}"
  end
  
  bot.run
else
  ProblemSlackBot.run
end
