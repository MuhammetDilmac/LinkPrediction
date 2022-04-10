# frozen_string_literal: true

# Edge Class
class Edge
  attr_reader :weight, :from, :to

  def initialize(from:, to:, weight: 0)
    @from       = from
    @to         = to
    @weight     = weight
  end

  def increment_weight!(weight: 1)
    @weight += weight
  end
end
