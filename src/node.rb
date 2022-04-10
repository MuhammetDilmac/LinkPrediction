# frozen_string_literal: true

# Node Class
class Node
  attr_reader :title, :meta, :neighbors, :edges

  def initialize(title:, meta:, options: { directed: false, weighted: false })
    @title   = title
    @meta    = meta
    @options = options

    @neighbors = []
    @edges     = []
  end

  def neighbor?(node)
    neighbor = @edges.find do |edge|
      if @options[:directed]
        edge.from == self && edge.to == node
      else
        (edge.from == self && edge.to == node) || (edge.from == node && edge.to == self)
      end
    end

    neighbor != nil
  end
end
