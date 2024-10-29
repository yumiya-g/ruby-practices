# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../shot'

class ShotTest < Minitest::Test
  def test_score_x
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end

  def test_score_one_to_nine
    scores = [*0..9].map(&:to_s)
    scores.each do |score|
      shot = Shot.new(score)
      assert_equal score.to_i, shot.score
    end
  end
end
