# frozen_string_literal: true

require 'debug'

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark == 'X'
    mark.to_i
  end
end
