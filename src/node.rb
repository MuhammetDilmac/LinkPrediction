# frozen_string_literal: true

# Node Class
class Node
  attr_accessor :title, :neighbors, :edges

  def initialize(title:)
    @title = title

    @neighbors = []
    @edges     = []
  end

  # @return [Edge, NilClass]
  def neighbor?(node)
    @edges.find { |edge| (edge.from == self && edge.to == node) || (edge.from == node && edge.to == self) }
  end

  # @return [Edge]
  def add_neighbor(node)
    edge = neighbor?(node)

    if edge.nil?
      edge = Edge.new(from: self, to: node, weight: 1)
      @edges.push(edge)
      node.edges.push(edge)
    else
      edge.increment_weight!
    end

    edge
  end
end
