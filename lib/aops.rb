require 'mechanize'
require 'imgkit'
require 'upload_image'

DIFFICULTIES = ["easy", "medium", "hard", "very hard"]

class AoPS
  def initialize
    @index_page = Mechanize.new.get('http://www.artofproblemsolving.com/wiki/index.php?title=AMC_Problems_and_Solutions')
  end

  # Parses difficulty string (if any) from a given message,
  # fetches a problem (retrying until one is found),
  # and sends messages using a passed-in block.
  def parse_message_and_fetch_problem(msg)
    difficulty = DIFFICULTIES.sample
    DIFFICULTIES.each {|d| difficulty = d if msg.include?(d) }

    yield "Let me fetch you a #{difficulty} problem ..."

    problem = nil
    problem = $aops.get_problem(difficulty) while problem.nil?

    yield problem[:image_url]
    yield "Solution: #{problem[:url]}"
  end

  def get_problem(difficulty)
    if difficulty == "easy"
      competition_page = @index_page.links.find {|l| l.text.include?('AMC 10')}.click
      year_page = competition_page.links.find_all {|l| l.text =~ /AMC 10[A|B]/}.sample.click
      problem_page = year_page.links.find_all {|l| l.text.include? 'Problem'}.sample.click
      solution_url = problem_page.uri.to_s
    elsif difficulty == "medium"
      competition_page = @index_page.links.find {|l| l.text.include?('AMC 12')}.click
      year_page = competition_page.links.find_all {|l| l.text =~ /AMC 12[A|B]/}.sample.click
      problem_page = year_page.links.find_all {|l| l.text.include? 'Problem'}.sample.click
      solution_url = problem_page.uri.to_s
    elsif difficulty == "hard"
      competition_page = @index_page.links.find {|l| l.text.include? 'AIME'}.click
      year_page = competition_page.links.find_all {|l| l.text =~ /AIME I/}.sample.click
      problem_page = year_page.links.find_all {|l| l.text.include? 'Problem'}.sample.click
      solution_url = problem_page.uri.to_s
    elsif difficulty == "very hard"
      competition_page = @index_page.links.find {|l| l.text.include? 'USAMO'}.click
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
    uploaded = Upload::ImageForest.new("out/problem.jpg").upload

    {
      url: problem_page.uri.to_s,
      image_url: uploaded.url,
      image_html: problem_html,
      year: year_page.uri.to_s
    }
  end
end