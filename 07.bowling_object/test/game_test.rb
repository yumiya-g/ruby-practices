# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'

class GameTest < Minitest::Test
  def mark_split(marks)
    marks.split(',').map { |s| s }
  end

	def test_calc_scores_mark1
    marks = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5"
    all_shots = mark_split(marks)
    game = Game.new(all_shots)
    assert_equal 139, game.calc_scores
  end

  def test_calc_scores_mark2
    marks = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X"
    all_shots = mark_split(marks)
    game = Game.new(all_shots)
    assert_equal 164, game.calc_scores
  end

  def test_calc_scores_mark3
    marks = "0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4"
    all_shots = mark_split(marks)
    game = Game.new(all_shots)
    assert_equal 107, game.calc_scores
  end

  def test_calc_scores_mark4
    marks = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0"
    all_shots = mark_split(marks)
    game = Game.new(all_shots)
    assert_equal 134, game.calc_scores
  end

  def test_calc_scores_mark5
    marks = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8"
    all_shots = mark_split(marks)
    game = Game.new(all_shots)
    assert_equal 144, game.calc_scores
  end

  def test_calc_scores_mark6
    marks = "X,X,X,X,X,X,X,X,X,X,X,X"
    all_shots = mark_split(marks)
    game = Game.new(all_shots)
    assert_equal 300, game.calc_scores
  end

  def test_calc_scores_mark7
    marks = "X,X,X,X,X,X,X,X,X,X,X,2"
    all_shots = mark_split(marks)
    game = Game.new(all_shots)
    assert_equal 292, game.calc_scores
  end

  def test_calc_scores_mark8
    marks = "X,0,0,X,0,0,X,0,0,X,0,0,X,0,0"
    all_shots = mark_split(marks)
    game = Game.new(all_shots)
    assert_equal 50, game.calc_scores
  end
end
