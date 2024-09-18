# frozen_string_literal: true
require 'debug'

class Shot
  def initialize(mark)
    @mark = mark
  end

  def mark_to_score
    @mark == 'X' ? 10 : @mark.to_i
  end
end
