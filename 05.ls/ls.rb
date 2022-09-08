#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_COLUMNS = 3

all_files = Dir.glob('*', base: 'test_files')

def main(all_files)
  counted_rows = calc_rows(all_files)

  first_row = (0...counted_rows).map { |i| all_files[i] }

  after_next_rows = create_after_second_rows(first_row, counted_rows, all_files)

  file_names_list = swap_row_to_column(first_row, after_next_rows)

  output_file_name(file_names_list, all_files)
end

def calc_rows(all_files)
  num_of_files = all_files.size
  (num_of_files.to_f / MAX_COLUMNS).ceil
end

def create_after_second_rows(first_row, counted_rows, all_files)
  after_second_row = []
  remaining_files = all_files - first_row

  remaining_files.each_slice(counted_rows) { |array| after_second_row << array }
  after_second_row
end

def swap_row_to_column(first_row, after_next_rows)
  first_row.zip(*after_next_rows)
end

def output_file_name(file_names_list, all_files)
  max_filename_length = all_files.map(&:length).max
  file_names_list.each do |file_names|
    file_names.each do |file_name|
      print "#{file_name.ljust(max_filename_length)}\s" unless file_name.nil?
    end
    print "\n"
  end
end

main(all_files)
