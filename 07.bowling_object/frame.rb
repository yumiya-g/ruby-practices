# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(all_shots)
    @all_shots = all_shots
  end

  def calc_scores
    all_shots = parse_all_shots
    convert_shots_to_scores(all_shots)
  end

  private

  def parse_all_shots
    all_frames = []
    frame = []
    @all_shots.each do |shot|
      shot = Shot.new(shot).mark_to_score

      frame << shot
      if all_frames.size < 10
        if frame.size >= 2 || shot == 10
          all_frames << frame.dup
          frame.clear
        end
      else
        all_frames.last << shot
      end
    end
    all_frames
  end

  def convert_shots_to_scores(all_shots)
    scores = []
    all_shots.size.times do |shots|
      frame, next_frame, after_next_frame = all_shots[shots, 3]
      next_frame ||= []
      after_next_frame ||= []

      scores << if within_number_one_to_nine?(shots)
                  total_score_to_point(frame, next_frame, after_next_frame)
                else
                  frame.sum
                end
    end
    scores
  end

  def total_score_to_point(frame, next_frame, after_next_frame)
    point = 0

    if strike?(frame)
      point += frame.sum + next_frame[0..1].sum
      point += after_next_frame.first if next_strike?(next_frame)
    elsif spare?(frame)
      point += frame.sum + next_frame.first
    else
      point += frame[0..1].sum
    end
    point
  end

  def shot_exist?(shot)
    !shot.nil?
  end

  def strike?(frame)
    frame.first == 10
  end

  def next_strike?(frame)
    frame.count == 1
  end

  def spare?(frame)
    frame[0..1].sum == 10
  end

  def within_number_one_to_nine?(frame_number)
    frame_number < 9
  end
end
