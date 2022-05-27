# frozen_string_literal: true

require 'csv'
require 'terminal-table'

require_relative '../src/node'
require_relative '../src/edge'

# Dir['data/Network *.csv'].each do |file|
#   nodes = []
#
#   CSV.foreach(file, headers: true) do |row|
#     first_node  = nodes.find { |node| node.title == row['player1_name'] }
#     second_node = nodes.find { |node| node.title == row['player2_name'] }
#
#     if first_node.nil?
#       first_node = Node.new(title: row['player1_name'])
#       nodes.push(first_node)
#     end
#
#     if second_node.nil?
#       second_node = Node.new(title: row['player2_name'])
#       nodes.push(second_node)
#     end
#
#     first_node.add_neighbor(second_node)
#   end
#
#   new_file = file.split('/').last.split('.csv').first
#
#   CSV.open("data/#{new_file}_extract.csv", 'a+') do |csv|
#     csv << %w[tournament_year player1_name player2_name weight]
#
#     nodes.each do |node|
#       node.edges.each do |edge|
#         csv << [new_file, edge.from.title, edge.to.title, edge.weight]
#       end
#     end
#   end
# end

def draw_table(nodes, title, method)
  headings = nodes.map(&:title).map { |t| t.split.map { |s| s[0] }.join }.prepend(' ')
  rows     = nodes.map { |node| calculate_row(nodes, node, method) }

  table = Terminal::Table.new title: title, headings: headings, rows: rows
  rows.count.times { |index| table.align_column(index, index.positive? ? :center : :left) }

  puts table
  puts ''
  puts ''
  puts ''
end

def calculate_row(nodes, node, method)
  [
    node.title.split.map { |s| s[0] }.join,
    *(nodes.map { |s_node| node.send(method, s_node) })
  ]
end

nodes = []

Dir['data/Network 1.csv'].each do |file|
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

nodes = nodes.sort_by(&:title)
draw_table(nodes, 'Neighbor Matrix', :neighbor_matrix)
draw_table(nodes, 'Common Neighbor', :common_neighbor)
draw_table(nodes, 'Adamic-Adalar Index', :adamic_adalar_index)
draw_table(nodes, 'Jaccard Index', :jaccard_index)
draw_table(nodes, 'Preferential Attachment Index', :preferential_attachment_index)
draw_table(nodes, 'Sorenson Index', :sorenson_index)

# CSV.open('data/all_time_extract.csv', 'a+') do |csv|
#   csv << %w[tournament_year player1_name player2_name weight]
#
#   nodes.each do |node|
#     node.edges.each do |edge|
#       csv << ['all_time', edge.from.title, edge.to.title, edge.weight]
#     end
#   end
# end
