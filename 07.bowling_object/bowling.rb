#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

marks = ARGV[0]
all_shots = marks.split(',').map { |s| s }
puts Game.new(all_shots).calc_game_point
