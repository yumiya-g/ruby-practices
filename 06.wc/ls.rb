#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'
require 'debug'

MAX_COLUMNS = 3

FILE_TYPE = {
  'file': '-',
  'directory': 'd',
  'link': 'l'
}.freeze

FILE_PERMISSION = {
  '0': '---',
  '1': '--x',
  '2': '-w-',
  '3': '-wx',
  '4': 'r--',
  '5': 'r-x',
  '6': 'rw-',
  '7': 'rwx'
}.freeze

def main
  dirname_options = parse_argv
  filenames_with_path = fetch_files(dirname_options)
  all_files = remove_path(filenames_with_path)

  if dirname_options[:options].include?(:l)
    output_file_info(filenames_with_path)
  else
    output_file_name(all_files)
  end
end

def parse_argv
  opt = OptionParser.new
  opt.on('-a') { |v| v }
  opt.on('-r') { |v| v }
  opt.on('-l') { |v| v }
  directory_name = opt.parse(ARGV)
  options = opt.getopts(ARGV).keys.map(&:to_sym)
  { directory_name: directory_name, options: options }
end

def fetch_files(dirname_options)
  dir_name = dirname_options[:directory_name].empty? ? '*' : "#{dirname_options[:directory_name].first}/*"
  files = if dirname_options[:options].include?(:a)
            Dir.glob(dir_name, File::FNM_DOTMATCH)
          else
            Dir.glob(dir_name)
          end
  dirname_options[:options].include?(:r) ? files.reverse : files
end

def remove_path(filenames_with_path)
  filenames_with_path.map do |file|
    File.basename(file)
  end
end

def output_file_name(all_files)
  num_of_rows = calc_rows(all_files)

  first_row = all_files[0...num_of_rows]

  after_next_rows = create_after_next_rows(first_row, num_of_rows, all_files)

  file_names = swap_row_to_column(first_row, after_next_rows)

  max_filename_length = count_max_filename(all_files)

  generate_file_name(file_names, max_filename_length)
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

def convert_multibyte_filename(name, max_filename_length)
  file_name_to_bytesize = name.each_char.map { |c| c.bytesize == 1 ? 1 : 2 }.sum
  padding_size = max_filename_length - file_name_to_bytesize
  name + ' ' * padding_size
end

def generate_file_name(file_names, max_filename_length)
  file_names.each do |file_name|
    file_name.each do |name|
      print "#{convert_multibyte_filename(name, max_filename_length)}\t" unless name.nil?
    end
    puts
  end
end

def output_file_info(files)
  file_stats = files.map do |file|
    { fs: File::Stat.new(file), filename: File.basename(file) }
  end

  digits = count_digit(file_stats)
  puts "total #{calc_blocksize(file_stats)}"
  puts generate_file_info_list(file_stats, digits)
end

def count_digit(file_stats)
  nlink_digit = file_stats.map { |file_stat| file_stat[:fs].nlink }.max.to_s.size
  filesize_digit = file_stats.map { |file_stat| file_stat[:fs].size.to_i }.max.to_s.size
  user_name_digit = file_stats.map { |file_stat| Etc.getpwuid(file_stat[:fs].uid).name.size }.max
  user_group_digit = file_stats.map { |file_stat| Etc.getgrgid(file_stat[:fs].gid).name.size }.max
  { nlink: nlink_digit, filesize: filesize_digit, username: user_name_digit, usergroup: user_group_digit }
end

def calc_blocksize(file_stats)
  file_stats.sum { |file_stat| file_stat[:fs].blocks }
end

def generate_file_info_list(file_stats, digits)
  file_stats.map do |file_stat|
    file_info = extract_filetype_permission(file_stat)
    file_info += extract_link(file_stat, digits)
    file_info += extract_user_name_group(file_stat, digits)
    file_info += extract_bytesize(file_stat, digits)
    file_info += extract_timestamp(file_stat)
    file_info_and_name = file_info + file_stat[:filename].split
    file_info_and_name.join
  end
end

def extract_filetype_permission(file_stat)
  filetype_code = FILE_TYPE[file_stat[:fs].ftype.to_sym]

  permission_numbers = file_stat[:fs].mode.to_s(8).slice(-3..-1).split('')
  permission_code = permission_numbers.map do |number|
    FILE_PERMISSION[number.to_sym]
  end
  permission_code.unshift(filetype_code).push("\s\s")
end

def extract_link(file_stat, digits)
  file_stat[:fs].nlink.to_s.rjust(digits[:nlink]).split('')
end

def extract_user_name_group(file_stat, digits)
  user_id = file_stat[:fs].uid
  user_name = Etc.getpwuid(user_id).name.ljust(digits[:username])
  group_id = file_stat[:fs].gid
  user_group = Etc.getgrgid(group_id).name.ljust(digits[:usergroup])
  ["\s#{user_name}\s\s#{user_group}"]
end

def extract_bytesize(file_stat, digits)
  ["\s\s#{file_stat[:fs].size.to_s.rjust(digits[:filesize])}"]
end

def extract_timestamp(file_stat)
  date = file_stat[:fs].mtime
  ["\s#{date.mon.to_s.rjust(2)}\s#{date.day.to_s.rjust(2)}\s#{date.strftime('%R')}\s"]
end

main
