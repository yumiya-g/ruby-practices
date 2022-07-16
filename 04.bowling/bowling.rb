#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []

scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

# 第10フレームは最大3投になるので、3投分の点数を平坦化して配列に格納
# ex [10, 0, 10, 10] => [10, 10, 10]に変更する
shots_for_10th = frames[9..11].flatten
frame_10th = shots_for_10th.reject(&:zero?)

frame_1st_to_9th = frames[0..8]
all_frames = [*frame_1st_to_9th, frame_10th]

total_point = all_frames.size.times.sum do |nth|
  frame, next_frame, after_next_frame = all_frames[nth, 3]
  strike = frame.first == 10
  spare = !strike && frame.sum == 10

  if strike
    if nth == 9
      frame.sum
    else
      next_frame_strike = next_frame[0] == 10
      if next_frame_strike && nth < 8
        10 + next_frame[0] + after_next_frame[0]
      else
        10 + next_frame[0..1].sum
      end
    end
  elsif spare
    10 + next_frame[0]
  else
    frame.sum
  end
end
puts total_point
