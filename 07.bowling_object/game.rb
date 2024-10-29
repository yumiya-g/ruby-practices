# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    scores = parse_all_frames(marks)
    @frames = scores.map.with_index do |score, frame_number|
      Frame.new(frame_number, *score)
    end
  end

  def calc_game_point
    total_points = @frames.map do |frame|
      next_frames = @frames[frame.frame_number + 1, 2]
      frame.calc_frames(*next_frames)
    end
    total_points.sum
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
