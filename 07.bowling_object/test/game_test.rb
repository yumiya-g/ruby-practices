# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'

class GameTest < Minitest::Test
  def test_calc_scores_mark1
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'.split(',').map { |s| s }
    scores_per_frames = Frame.new(marks).calc_scores
    assert_equal 139, Game.new(scores_per_frames).sum
  end

  def test_calc_scores_mark2
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'.split(',').map { |s| s }
    scores_per_frames = Frame.new(marks).calc_scores
    assert_equal 164, Game.new(scores_per_frames).sum
  end

  def test_calc_scores_mark3
    marks = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'.split(',').map { |s| s }
    scores_per_frames = Frame.new(marks).calc_scores
    assert_equal 107, Game.new(scores_per_frames).sum
  end

  def test_calc_scores_mark4
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'.split(',').map { |s| s }
    scores_per_frames = Frame.new(marks).calc_scores
    assert_equal 134, Game.new(scores_per_frames).sum
  end

  def test_calc_scores_mark5
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'.split(',').map { |s| s }
    scores_per_frames = Frame.new(marks).calc_scores
    assert_equal 144, Game.new(scores_per_frames).sum
  end

  def test_calc_scores_mark6
    marks = 'X,X,X,X,X,X,X,X,X,X,X,X'.split(',').map { |s| s }
    scores_per_frames = Frame.new(marks).calc_scores
    assert_equal 300, Game.new(scores_per_frames).sum
  end

  def test_calc_scores_mark7
    marks = 'X,X,X,X,X,X,X,X,X,X,X,2'.split(',').map { |s| s }
    scores_per_frames = Frame.new(marks).calc_scores
    assert_equal 292, Game.new(scores_per_frames).sum
  end

  def test_calc_scores_mark8
    marks = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'.split(',').map { |s| s }
    scores_per_frames = Frame.new(marks).calc_scores
    assert_equal 50, Game.new(scores_per_frames).sum
  end
end
