# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../frame'

class FrameTest < Minitest::Test
  def test_scores_strike
    frame = Frame.new('X')
    assert_equal frame.create_scores_per_frame, [10]
  end

  def test_scores_spare
    frame = Frame.new('1', '9')
    assert_equal frame.create_scores_per_frame, [1, 9]
  end

  def test_scores_less_than_ten
    frame = Frame.new('1', '0')
    assert_equal frame.create_scores_per_frame, [1, 0]
  end

  def test_ten_frame_strike
    frame = Frame.new('X', '0' ,'X')
    assert_equal frame.create_scores_per_frame, [10, 0, 10]
  end

  def test_ten_frame_spare
    frame = Frame.new('4', '6' ,'X')
    assert_equal frame.create_scores_per_frame, [4, 6, 10]
  end
end
