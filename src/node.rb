# frozen_string_literal: true

# Node Class
class Node
  attr_accessor :title, :neighbors, :edges

  ZERO = 0.00

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

  # @param [Node] node
  # @return [Float]
  def neighbor_matrix(node)
    self == node ? ZERO : (neighbor?(node)&.weight.to_f || ZERO)
  end

  # @param [Node] node
  # @return [Float]
  def common_neighbor(node)
    return ZERO if self == node || neighbor?(node)

    neighbors.intersection(node.neighbors)
             .sum { |n| [n.neighbor?(self).weight, n.neighbor?(node).weight].sum }
             .to_f
             .ceil(2)
  end

  # @param [Node] node
  # @return [Float]
  def adamic_adalar_index(node)
    return ZERO if self == node || neighbor?(node)

    sum_of_edges = node.edges.sum(&:weight) + edges.sum(&:weight)
    log_of_edges = Math.log(1 + sum_of_edges)

    neighbors.intersection(node.neighbors)
             .sum { |n| [n.neighbor?(self).weight, n.neighbor?(node).weight].sum.to_f / log_of_edges }
             .to_f
             .ceil(2)
  end

  # @param [Node] node
  # @return [Float]
  def jaccard_index(node)
    return ZERO if self == node || neighbor?(node)

    (common_neighbor(node) / (node.edges.sum(&:weight) + edges.sum(&:weight))).ceil(2)
  end

  # @param [Node] node
  # @return [Float]
  def preferential_attachment_index(node)
    return ZERO if self == node || neighbor?(node)

    (node.edges.sum(&:weight) * edges.sum(&:weight)).to_f.ceil(2)
  end

  # @param [Node] node
  # @return [Float]
  def sorenson_index(node)
    return ZERO if self == node || neighbor?(node)

    ((2 * common_neighbor(node)) / (node.edges.sum(&:weight) * edges.sum(&:weight))).to_f.ceil(2)
  end
end
