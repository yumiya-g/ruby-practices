#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'
require 'debug'

class Game
  def initialize(marks)
    # フレームごとに分割されたスコアを配列で格納
    scores = parse_all_frames(marks)

    # 1フレームごとの情報をFrameに渡す
    @all_points = scores.map.with_index do |score, frame_number|
      Frame.new(frame_number, *score)
    end
  end

  def calc_game_point
    total_point = @all_points.map do |point|
      next_frames = @all_points[point.frame_number + 1, 2]
      point.calc_frames(next_frames)
    end
    total_point.sum
  end

  private

  def parse_all_frames(marks)
    all_frames = []
    frame = []
    marks.each do |mark|
      frame << mark
      if all_frames.size < 10
        if frame.size >= 2 || mark == 'X'
          all_frames << frame.dup
          frame.clear
        end
      else
        all_frames.last << mark
      end
    end
    all_frames
  end
end
