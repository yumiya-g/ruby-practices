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
frame_10th = frames[9..11].flatten
frame_10th.delete(0)

frame_1st_to_9th = frames[0..8]
all_frames = frame_1st_to_9th << frame_10th

points = 0

all_frames.each.with_index(1) do |frame, i|
  if frame.first == 10 # Strike
    points += frame.sum if i == 10
    break if all_frames[i].nil?

    points += if all_frames[i].first == 10
                if i < 9
                  10 + all_frames[i].first + all_frames[i + 1].first
                elsif i == 9
                  frame.sum + all_frames[i][0..1].sum
                end
              else
                10 + all_frames[i][0..1].sum
              end
  elsif frame.sum == 10 # Spare
    points += 10 + all_frames[i].first
  else
    points += frame.sum
  end
end
puts points
