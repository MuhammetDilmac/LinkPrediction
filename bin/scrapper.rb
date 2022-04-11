# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'csv'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :chrome
Capybara.configure do |config|
  config.default_max_wait_time = 10 # seconds
  config.default_driver = :selenium
end

browser = Capybara.current_session
browser.visit 'https://www.livesport.com/en/darts/world/pdc-world-championship/archive/'
tournaments = browser.find_all('#tournament-page-archiv .archive__season a.archive__text.archive__text--clickable')
puts "[*] Founded tournaments count: #{tournaments.count}"

tournaments = tournaments.map do |tournament|
  { title: tournament.text.strip, url: "#{tournament[:href]}results" }
end

tournaments = tournaments.map do |tournament|
  title = tournament[:title]
  browser.visit tournament[:url]

  matches = browser.find_all('.sportName.darts > div')
  stage   = nil
  matches = matches.filter_map do |match|
    next unless match[:class].include?('event__round') || match[:class].include?('event__match--static')

    if match[:class].include?('event__round')
      stage = match.text.strip

      nil
    else
      first_player, second_player             = match.find_all('.event__participant').map(&:text)
      first_player_score, second_player_score = match.find_all('.event__sets').map(&:text)
      time                                    = match.find('.event__time').text

      { stage:, first_player:, second_player:, first_player_score:, second_player_score:, time: }
    end
  end

  { title:, matches: }
end

File.write('data/output.json', tournaments.to_json)

initiated = []

tournaments.each do |tournament|
  year = tournament[:title].split.last.to_i

  index = if year < 2000
            '1'
          elsif year < 2006
            '2'
          elsif year < 2012
            '3'
          elsif year < 2018
            '4'
          else
            '5'
          end

  CSV.open("data/#{year}.csv", 'w+') do |csv|
    csv << %w[tournament_year stage player1_name player2_name]

    tournament[:matches].each { |match| csv << [year, match[:stage], match[:first_player], match[:second_player]] }
  end

  CSV.open("data/Network #{index}.csv", 'a+') do |csv|
    unless initiated.include?(index)
      initiated.push(index)
      csv << %w[tournament_year stage player1_name player2_name]
    end

    tournament[:matches].each { |match| csv << [year, match[:stage], match[:first_player], match[:second_player]] }
  end
end
