#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_COLUMNS = 3

def main
  all_files = formatted_file_names(fetch_file_names)

  num_of_rows = calc_rows(all_files)

  first_row = all_files[0...num_of_rows]

  after_next_rows = create_after_next_rows(first_row, num_of_rows, all_files)

  file_names = swap_row_to_column(first_row, after_next_rows)

  max_filename_length = count_max_filename(all_files)

  output_file_name(file_names, max_filename_length)
end

def fetch_file_names
  if ARGV.empty?
    Dir.glob('*')
  else
    other_directory_files = []
    ARGV.each do |str|
      other_directory_files = Dir.glob("#{str}/*")
    end
    other_directory_files
  end
end

def formatted_file_names(fetch_file_names)
  fetch_file_names.map do |file_name_str|
    file_name_str.gsub(%r{.*/}, '')
  end
end

def calc_rows(all_files)
  num_of_files = all_files.size
  (num_of_files.to_f / MAX_COLUMNS).ceil
end

def create_after_next_rows(first_row, num_of_rows, all_files)
  after_second_row = []
  remaining_files = all_files - first_row

  remaining_files.each_slice(num_of_rows) { |array| after_second_row << array }
  after_second_row
end

def swap_row_to_column(first_row, after_next_rows)
  first_row.zip(*after_next_rows)
end

def count_max_filename(all_files)
  all_files.map(&:size).max
end

def output_file_name(file_names, max_filename_length)
  file_names.each do |file_name|
    file_name.each do |name|
      print "#{name.ljust(max_filename_length)}\s" unless name.nil?
    end
    puts
  end
end

main
