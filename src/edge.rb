# frozen_string_literal: true

# Edge Class
class Edge
  attr_reader :weight, :from, :to

  # @param [Node] from
  # @param [Node] to
  # @param [Integer] weight
  def initialize(from:, to:, weight: 0)
    @from       = from
    @to         = to
    @weight     = weight

    from.neighbors.push(to) unless from.neighbors.include?(to)
    to.neighbors.push(from) unless to.neighbors.include?(from)
  end

  # @param [Integer] weight
  def increment_weight!(weight: 1)
    @weight += weight
  end
end
