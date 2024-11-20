# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../file'

class Ls::FileTest < Minitest::Test
  def file_info
    @file = Dir.glob('dummy_files/*', ::File::FNM_DOTMATCH)[1]
  end

  def test_generate_date_object
    file_info
    file = Ls::File.new(@file)
    assert_equal file.date, { year: "2024", month: "11", day: "11", hour: "12", min: "38" }
  end

  def test_convert_characters
    file_info
    debugger
    file = Ls::File.new(@file)
    assert_equal file.permission, '-rw-r--r--'
  end
end
