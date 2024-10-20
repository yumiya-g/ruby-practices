#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'
require 'debug'

marks = ARGV[0]
all_shots = marks.split(',').map { |s| s }

game = Game.new(all_shots)
puts game.calc_game_point
