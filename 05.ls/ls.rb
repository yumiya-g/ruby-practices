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
  filenames_with_path = fetch_files(parse_argv)

  all_files = remove_path(filenames_with_path)

  if parse_argv[:options] != [:l]
    num_of_rows = calc_rows(all_files)

    first_row = all_files[0...num_of_rows]

    after_next_rows = create_after_next_rows(first_row, num_of_rows, all_files)

    file_names = swap_row_to_column(first_row, after_next_rows)

    max_filename_length = count_max_filename(all_files)

    output_file_name(file_names, max_filename_length)
  else
    extract_file_info(filenames_with_path)
  end
end

def parse_argv
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| v }
  opt.on('-r') { |v| v }
  opt.on('-l') { |v| v }
  directory_name = opt.parse(ARGV, into: params)
  options = params.keys
  { directory_name: directory_name, options: options }
end

def fetch_files(argv)
  dir_name = argv[:directory_name].empty? ? '*' : "#{argv[:directory_name].first}/*"

  files = if argv[:options] == [:a]
            Dir.glob(dir_name, File::FNM_DOTMATCH)
          else
            Dir.glob(dir_name)
          end
  argv[:options] == [:r] ? files.reverse : files
end

def remove_path(filenames_with_path)
  filenames_with_path.map do |file|
    File.basename(file)
  end
end

def extract_file_info(files)
  file_stats = files.map do |file|
    File::Stat.new(file)
  end

  digit = count_digit(file_stats)
  puts "total #{calc_blocksize(file_stats)}"
  puts generate_file_info_list(file_stats, digit, files)
end

def calc_blocksize(file_stats)
  fs_total = file_stats.map(&:blocks)
  puts fs_total.sum
end

def count_digit(file_stats)
  nlink_digit = file_stats.map { |fs| fs.nlink.to_s }.max.size
  filesize_digit = file_stats.map { |fs| fs.size.to_i }.max.to_s.size

  { nlink: nlink_digit, filesize: filesize_digit }
end

def generate_file_info_list(file_stats, digit, files)
  file_stats.map.with_index do |fs, i|
    list = extract_filetype_permission(fs) + extract_link(fs, digit)
    list_add_user_group = list + extract_user_name_group(fs)
    list_add_bytesize = list_add_user_group + extract_bytesize(fs, digit)
    list_add_timestamp = list_add_bytesize + extract_timestamp(fs)
    list_add_timestamp.join + File.basename(files[i])
  end
end

def extract_filetype_permission(file_stats)
  filetype_code = FILE_TYPE[file_stats.ftype.to_sym]

  permission_numbers = file_stats.mode.to_s(8).slice(-3..-1).split('')
  permission_code = permission_numbers.map do |number|
    FILE_PERMISSION[number.to_sym]
  end
  permission_code.unshift(filetype_code).push("\s\s")
end

def extract_link(file_stats, digit)
  file_stats.nlink.to_s.rjust(digit[:nlink]).split('')
end

def extract_user_name_group(file_stats)
  user_id = file_stats.uid
  user_name = Etc.getpwuid(user_id).name
  group_id = file_stats.gid
  user_group = Etc.getgrgid(group_id).name
  ["\s#{user_name}\s\s#{user_group}"]
end

def extract_bytesize(file_stats, digit)
  ["\s\s#{file_stats.size.to_s.rjust(digit[:filesize])}"]
end

def extract_timestamp(file_stats)
  date = file_stats.mtime
  ["\s#{date.mon.to_s.rjust(2)}\s#{date.day.to_s.rjust(2)}\s#{date.strftime('%R')}\s"]
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

def output_file_name(file_names, max_filename_length)
  file_names.each do |file_name|
    file_name.each do |name|
      print "#{convert_multibyte_filename(name, max_filename_length)}\t" unless name.nil?
    end
    puts
  end
end

main
