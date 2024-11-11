# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../file'

class RowTest < Minitest::Test
  def file_stats_no_options
    @file_stats = ['000.txt', '001.txt', 'alice.txt']
    @options = []
  end

  def test_display_file_name
   file_stats_no_options
   sliced_file_name = [@file_stats]
   row = Row.new(@file_stats, @options)
   assert_equal row.adjust_padding(sliced_file_name), [["000.txt  ", "001.txt  ", "alice.txt"]]
  end
end
