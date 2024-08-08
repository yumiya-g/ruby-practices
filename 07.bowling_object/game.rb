# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(scores)
    @scores = scores
  end

  def sum
    @scores.sum
  end
end
