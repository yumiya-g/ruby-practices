# frozen_string_literal: true

require 'minitest/autorun'
require 'debug'
require_relative '../shot'

class ShotTest < Minitest::Test
  def test_score_x
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end

  def test_score_one_to_nine
    scores = [*0..9]
    scores.each do |score|
      shot = Shot.new(score)
      assert_equal score, shot.score
    end
  end

end
