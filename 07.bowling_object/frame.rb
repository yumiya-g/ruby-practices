# frozen_string_literal: true

require_relative 'shot'

require "debug"

class Frame
  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark).score
    @second_shot = Shot.new(second_mark).score
    @third_shot = Shot.new(third_mark).score
  end

  def create_scores
    shots = []
    shots << @first_shot
    shots << @second_shot if shot_exist?(@second_shot)
    shots << @third_shot if shot_exist?(@third_shot)
    shots.compact
  end

  def shot_exist?(shot)
    !shot.nil?
  end
end
