#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_COLUMNS = 3

def main
  filenames_with_path = fetch_files(convert_commandline_args)

  all_files = removed_path(filenames_with_path)

  num_of_rows = calc_rows(all_files)

  first_row = all_files[0...num_of_rows]

  after_next_rows = create_after_next_rows(first_row, num_of_rows, all_files)

  file_names = swap_row_to_column(first_row, after_next_rows)

  max_filename_length = count_max_filename(all_files)

  output_file_name(file_names, max_filename_length)
end

def convert_commandline_args
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| v }
  directory_name = opt.parse(ARGV, into: params)
  options = params.keys
  { directory_name: directory_name, options: options }
end

def show_current_directory_files(convert_commandline_args)
  convert_commandline_args[:options].empty? ? Dir.glob('*') : Dir.glob('*', File::FNM_DOTMATCH)
end

def show_other_directory_files(convert_commandline_args)
  files = []
  convert_commandline_args[:directory_name].each do |str|
    files = convert_commandline_args[:options].empty? ? Dir.glob("#{str}/*") : Dir.glob("#{str}/*", File::FNM_DOTMATCH)
  end
  files
end

def fetch_files(convert_commandline_args)
  if convert_commandline_args[:directory_name].empty?
    show_current_directory_files(convert_commandline_args)
  else
    show_other_directory_files(convert_commandline_args)
  end
end

def removed_path(filenames_with_path)
  filenames_with_path.map do |file|
    file.gsub(%r{.*/}, '')
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
