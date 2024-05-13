# frozen_string_literal: true

require_relative './shot.rb'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end



  # 1フレームのスコア合計
  def score
    shots = [first_shot.score, second_shot.score, third_shot.score]
    shots.sum
  end
end


