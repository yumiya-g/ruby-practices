# frozen_string_literal: true
require 'debug'

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    if @mark.nil?
      nil
    else
      return 10 if @mark == 'X'

      @mark.to_i
    end
  end
end
