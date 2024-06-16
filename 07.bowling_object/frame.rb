# frozen_string_literal: true

require_relative 'shot'
require 'debug'

class Frame
  # 各ショットをインスタンス変数に格納
  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark).score
    @second_shot = Shot.new(second_mark).score
    @third_shot = Shot.new(third_mark).score
  end

  # フレームごとのスコアを生成する
  def create_scores_per_frame
    shots = []
    shots << @first_shot
    shots << @second_shot unless @second_shot.nil?
    shots << @third_shot unless @second_shot.nil?
    shots.compact
  end
end
