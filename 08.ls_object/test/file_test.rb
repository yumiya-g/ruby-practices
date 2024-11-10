# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../file'

class CommandTest < Minitest::Test
  def file_info
    # dummy_files/.ls_test ファイルを参照
    @file = Dir.glob("dummy_files/*", ::File::FNM_DOTMATCH)[1]
  end

  def test_generate_date_object
    file_info
    date = Ls::File.new(@file).generate_date_object
    assert_equal date, {:year=>2024, :day=>7, :month=>11, :hour=>8, :min=>36}
  end

  def test_convert_characters
    file_info
    file = Ls::File.new(@file)
    assert_equal file.permission, "-rw-r--r--"
  end
  
end
