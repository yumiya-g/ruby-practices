# frozen_string_literal: true

require_relative 'shot'
require 'debug'

class Frame
  attr_reader :frame_number, :first_shot, :second_shot, :third_shot

  def initialize(frame_number, first_mark, second_mark = nil, third_mark = nil)
    @frame_number = frame_number
    @first_shot = Shot.new(first_mark).score
    @second_shot = Shot.new(second_mark).score
    @third_shot = Shot.new(third_mark).score
  end

  def calc_frames(next_frames)
    current_frame = [@first_shot, @second_shot, @third_shot]
    next_frame, after_next_frame = parse_next_frames(next_frames)

    point = 0
    total_score_to_point(point, current_frame, next_frame, after_next_frame)
  end

  private

  def parse_next_frames(frames)
    frames.map do |frame|
      [frame.first_shot, frame.second_shot, frame.third_shot]
    end
  end

  def total_score_to_point(point, current_frame, next_frame, after_next_frame)
    if one_to_nine_frame?
      if strike?
        point += current_frame.sum + next_frame[0..1].sum
        point += after_next_frame.first if next_frame[0] == 10 && after_next_frame != nil
      elsif spare?
        point += current_frame.sum + next_frame.first
      else
        point += current_frame[0..1].sum
      end
    else
       point += current_frame.sum
    end
    point
  end

  def strike?
    self.first_shot == 10
  end

  def spare?
    self.first_shot + self.second_shot == 10
  end

  def one_to_nine_frame?
    self.frame_number < 9
  end
end
