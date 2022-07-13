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
frame_10th_processing = frames[9..11].flatten
frame_10th = frame_10th_processing.reject(&:zero?)

frame_1st_to_9th = frames[0..8]
p all_frames = [*frame_1st_to_9th << frame_10th]

total_point = 0

all_frames.each.with_index(1) do |frame, frame_nth|
  strike = frame.first == 10
  spare = !strike && frame.sum == 10
  next_frame = all_frames[frame_nth]
  after_next_frame = all_frames[frame_nth + 1]

  if strike
    if frame_nth == 10
      total_point += frame.sum
    else
      next_frame_strike = next_frame[0] == 10
      total_point += if next_frame_strike
                       if frame_nth < 9
                         10 + next_frame[0] + after_next_frame[0]
                       elsif frame_nth == 9
                         10 + next_frame[0..1].sum
                       end
                     else
                       10 + next_frame[0..1].sum
                     end
    end
  elsif spare
    total_point += 10 + next_frame[0]
  else
    total_point += frame.sum
  end
end
puts total_point
