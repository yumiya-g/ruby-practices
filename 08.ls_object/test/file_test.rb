# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../file'

class Ls::FileTest < Minitest::Test
  def setup
    file = Dir.glob('dummy_files/*', ::File::FNM_DOTMATCH)[1]
    @file = Ls::File.new(file)
  end

  def test_generate_stats
    assert_equal @file.generate_file_stats,
                 {
                   blocks: 0,
                   permission: '-rw-r--r--',
                   nlink: 1,
                   owner: 'yumiya',
                   group: 'staff',
                   size: 0,
                   date: { year: '2024', month: '11', day: '11', hour: '12', min: '38' },
                   name: '.ls_test'
                 }
  end

  def test_generate_date_object
    assert_equal @file.date, { year: '2024', month: '11', day: '11', hour: '12', min: '38' }
  end

  def test_convert_characters
    assert_equal @file.permission, '-rw-r--r--'
  end
end
