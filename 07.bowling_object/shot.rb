# frozen_string_literal: true

require 'debug'

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    if mark == 'X'
      10
    elsif mark == nil
      nil
    else
      mark.to_i
    end
  end
end
