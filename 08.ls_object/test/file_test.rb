# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../file'

class Ls::FileTest < Minitest::Test
  def setup
    file_name = Dir.glob('*', ::File::FNM_DOTMATCH)[2]
    @file_stats = Ls::File.new(file_name)
  end

  def test_generate_stats
    assert_equal @file_stats.file_stats,
                 {
                   blocks: 0,
                   type: 'file',
                   permission: '-rw-r--r--',
                   nlink: 1,
                   owner: 'yumiya',
                   group: 'staff',
                   size: 0,
                   date: { year: '2022', month: '06', day: '09', hour: '23', min: '10' },
                   name: '.gitkeep'
                 }
  end

  def test_generate_date_object
    assert_equal @file_stats.file_stats[:date], { year: '2022', month: '06', day: '09', hour: '23', min: '10' }
  end

  def test_convert_characters
    assert_equal @file_stats.file_stats[:permission], '-rw-r--r--'
  end
end
