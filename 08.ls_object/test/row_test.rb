# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../file'

class RowTest < Minitest::Test
  def setup
    @file_stats =
      [
        { blocks: 0,
          permission: 'drwxr-xr-x',
          nlink: 14,
          owner: 'yumiya',
          group: 'staff',
          size: 448,
          date: { year: '2024', month: '11', day: '18', hour: '08', min: '32' },
          name: '.' },
        { blocks: 0,
          permission: '-rw-r--r--',
          nlink: 1,
          owner: 'yumiya',
          group: 'staff',
          size: 0,
          date: { year: '2024', month: '11', day: '11', hour: '12', min: '38' },
          name: '.ls_test' },
        { blocks: 8,
          permission: '-rw-r--r--',
          nlink: 1,
          owner: 'yumiya',
          group: 'staff',
          size: 1,
          date: { year: '2024', month: '11', day: '15', hour: '08', min: '44' },
          name: '000.txt' }
      ]
    @options = []
  end

  def test_output_columns
    @options = [:l]
    row = Row.new(@file_stats, @options)
    assert_equal row.send(:output_columns),
                 ['drwxr-xr-x 14 yumiya  staff  448 11 18 08:32 .', '-rw-r--r--  1 yumiya  staff    0 11 11 12:38 .ls_test',
                  '-rw-r--r--  1 yumiya  staff    1 11 15 08:44 000.txt']
  end

  def test_generate_file_stats_digits
    row = Row.new(@file_stats, @options)
    assert_equal row.send(:generate_file_stats_digits), { nlink: 2, size: 3, owner: 6, group: 5 }
  end

  def test_adjust_name_padding
    row = Row.new(@file_stats, @options)
    assert_equal row.send(:adjust_name_padding), ['.       ', '.ls_test', '000.txt ']
  end
end
