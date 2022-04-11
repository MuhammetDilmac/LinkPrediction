# frozen_string_literal: true

require 'csv'

require_relative '../src/node'
require_relative '../src/edge'

Dir['data/Network *.csv'].each do |file|
  nodes = []

  CSV.foreach(file, headers: true) do |row|
    first_node  = nodes.find { |node| node.title == row['player1_name'] }
    second_node = nodes.find { |node| node.title == row['player2_name'] }

    if first_node.nil?
      first_node = Node.new(title: row['player1_name'])
      nodes.push(first_node)
    end

    if second_node.nil?
      second_node = Node.new(title: row['player2_name'])
      nodes.push(second_node)
    end

    first_node.add_neighbor(second_node)
  end

  new_file = file.split('/').last.split('.csv').first

  CSV.open("data/#{new_file}_extract.csv", 'a+') do |csv|
    csv << %w[tournament_year player1_name player2_name weight]

    nodes.each do |node|
      node.edges.each do |edge|
        csv << [new_file, edge.from.title, edge.to.title, edge.weight]
      end
    end
  end
end

nodes = []

Dir['data/Network *.csv'].each do |file|
  CSV.foreach(file, headers: true) do |row|
    first_node  = nodes.find { |node| node.title == row['player1_name'] }
    second_node = nodes.find { |node| node.title == row['player2_name'] }

    if first_node.nil?
      first_node = Node.new(title: row['player1_name'])
      nodes.push(first_node)
    end

    if second_node.nil?
      second_node = Node.new(title: row['player2_name'])
      nodes.push(second_node)
    end

    first_node.add_neighbor(second_node)
  end
end

CSV.open('data/all_time_extract.csv', 'a+') do |csv|
  csv << %w[tournament_year player1_name player2_name weight]

  nodes.each do |node|
    node.edges.each do |edge|
      csv << ['all_time', edge.from.title, edge.to.title, edge.weight]
    end
  end
end
