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

frames = []
shots.each_slice(2) do |shot|
  frames << shot
end

frame_10th = frames[9..11]
frame_10th.each do |f|
  f.pop if f.first == 10
end
frame_10th.flatten!

frames = frames[0..8] << frame_10th

points = 0

frames.each.with_index(1) do |frame, i|
  if frame.first == 10
    return p points += 10 + frame[1..2].sum if i == 10

    points += if frame == [10, 0] && frames[i] == [10, 0]
                10 + frames[i].first + frames[i + 1].first
              else
                10 + frames[i][0..1].sum
              end
  elsif frame.sum == 10
    points += 10 + frames[i].first
  else
    points += frame.sum
  end
end
p points
