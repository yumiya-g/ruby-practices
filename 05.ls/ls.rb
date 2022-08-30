#!/usr/bin/env ruby
# frozen_string_literal: true

FILES_ARR = Dir.glob('*')

max_columns = 3

def calc_rows(max_columns)
  counted_all_files = FILES_ARR.size

  if (counted_all_files % max_columns).zero?
    counted_all_files / max_columns
  else
    counted_all_files / max_columns + 1
  end
end

def after_second_rows(first_row_array, counted_rows)
  array_after_second_row = []
  remaining_arrays = FILES_ARR - first_row_array

  remaining_arrays.each_slice(counted_rows) { |array| array_after_second_row << array }
  array_after_second_row
end

def swap_row_to_column(first_row_array, after_next_rows_array)
  first_row_array.zip(*after_next_rows_array) do |array|
    count_files_name = FILES_ARR.map(&:length)

    array.each.with_index(1) do |file_name, idx|
      print "#{file_name.ljust(count_files_name.max)}\s" unless file_name.nil?
      print "\n" if idx == array.size
    end
  end
end

counted_rows = calc_rows(max_columns)

first_row_array = (0...counted_rows).map { |i| FILES_ARR[i] }

after_next_rows_array = after_second_rows(first_row_array, counted_rows)

swap_row_to_column(first_row_array, after_next_rows_array)
