#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'
require 'debug'

class Game
  def initialize(marks)
    @all_shots = marks
  end

  def calc_scores
    all_frames = parse_all_frames
    scores = score_per_frames(all_frames)
    sum(scores)
  end

  private

  def parse_all_frames
    all_frames = []
    frame = []
    @all_shots.each do |shot|
      frame << shot
      if all_frames.size < 10
        if frame.size >= 2 || shot == 'X'
          all_frames << frame.dup
          frame.clear
        end
      else
        all_frames.last << shot
      end
    end
    all_frames
  end

  def score_per_frames(frames)
    frames.map do |frame|
      frame = Frame.new(*frame)
      frame.create_scores
    end
  end

  def sum(scores)
    point_sum = 0
    scores.size.times do |frame_number|
      frame, next_frame, after_next_frame = scores[frame_number, 3]
      next_frame ||= []
      after_next_frame ||= []

      point = 0
      if one_to_nine_frame?(frame_number)
        point = total_score_to_point(point, frame, next_frame, after_next_frame)
      else
        point += frame.sum
      end
      point_sum += point
    end
    point_sum
  end

  def total_score_to_point(point, frame, next_frame, after_next_frame)
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

  def strike?(frame)
    frame.first == 10
  end

  def next_strike?(frame)
    frame.count == 1
  end

  def spare?(frame)
    frame[0..1].sum == 10
  end

  def one_to_nine_frame?(frame_number)
    frame_number < 9
  end
end
