#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_COLUMNS = 3

def main
  option = options?

  directory_name

  files = fetch_files(option, directory_name)

  all_files = removed_directory_name(files)

  num_of_rows = calc_rows(all_files)

  first_row = all_files[0...num_of_rows]

  after_next_rows = create_after_next_rows(first_row, num_of_rows, all_files)

  file_names = swap_row_to_column(first_row, after_next_rows)

  max_filename_length = count_max_filename(all_files)

  output_file_name(file_names, max_filename_length)
end

def options?
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| v }
  opt.parse(ARGV, into: params)
  params.empty?
end

def directory_name
  opt = OptionParser.new
  opt.on('-a') { |v| v }
  opt.parse!(ARGV)
end

def root_directory_files(option)
  option ? Dir.glob('*') : Dir.glob('*', File::FNM_DOTMATCH)
end

def other_directory_files(option)
  files = []
  directory_name.each do |str|
    files = option ? Dir.glob("#{str}/*") : Dir.glob("#{str}/*", File::FNM_DOTMATCH)
  end
  files
end

def fetch_files(option, directory_name)
  directory_name.empty? ? root_directory_files(option) : other_directory_files(option)
end

def removed_directory_name(files)
  files.map do |file|
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
