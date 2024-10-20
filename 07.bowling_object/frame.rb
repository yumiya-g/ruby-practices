# frozen_string_literal: true

require_relative 'shot'
require 'debug'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :frame_number

  def initialize(frame_number, first_mark, second_mark = nil, third_mark = nil)
    @frame_number = frame_number
    @first_shot = Shot.new(first_mark).mark_to_score
    @second_shot = Shot.new(second_mark).mark_to_score
    @third_shot = Shot.new(third_mark).mark_to_score
  end

  def calc_frames(next_frames)
    current_frame = [@first_shot, @second_shot, @third_shot]

    next_frame =  [next_frames[0].first_shot, next_frames[0].second_shot, next_frames[0].third_shot] unless next_frames[0].nil?
    after_next_frame = [next_frames[1].first_shot, next_frames[1].second_shot, next_frames[1].third_shot] unless next_frames[1].nil?

    point = 0
    if one_to_nine_frame?(@frame_number)
      point = total_score_to_point(point, current_frame, next_frame, after_next_frame)
    else
      point += current_frame.sum
    end
    point
  end

  def total_score_to_point(point, current_frame, next_frame, after_next_frame)
    if strike?(current_frame)
      point += current_frame.sum + next_frame[0..1].sum
      point += after_next_frame.first if strike?(next_frame) && shot_exist?(after_next_frame)
    elsif spare?(current_frame)
      point += current_frame.sum + next_frame.first
    else
      point += current_frame[0..1].sum
    end
    point
  end

  def strike?(frame)
    frame.first == 10
  end

  def spare?(frame)
    frame[0..1].sum == 10
  end

  def one_to_nine_frame?(frame_number)
    frame_number < 9
  end

  def shot_exist?(shot)
    !shot.nil?
  end
end
