#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

marks = ARGV[0]
all_shots = marks.split(',').map { |s| s }
frame = Frame.new(all_shots)
scores_per_frames = frame.calc_scores

puts Game.new(scores_per_frames).sum
