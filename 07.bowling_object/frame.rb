# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :frame_number, :first_shot, :second_shot, :third_shot

  def initialize(frame_number, first_mark, second_mark = nil, third_mark = nil)
    @frame_number = frame_number
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def calc_frames(next_frame = nil, after_next_frame = nil)
    point = 0
    current_score = first_shot.score + second_shot.score
    if one_to_nine_frame?
      if strike?
        point += current_score + next_frame.first_shot.score + next_frame.second_shot.score
        point += after_next_frame.first_shot.score if next_frame.first_shot.score == 10 && !after_next_frame.nil?
      elsif spare?
        point += current_score + next_frame.first_shot.score
      else
        point += current_score
      end
    else
      point += current_score + third_shot.score
    end
    point
  end

  private

  def strike?
    first_shot.score == 10
  end

  def spare?
    first_shot.score + second_shot.score == 10
  end

  def one_to_nine_frame?
    frame_number < 9
  end
end
