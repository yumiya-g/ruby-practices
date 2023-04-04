#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'

OPTION_KEY_MAP = [%i[l rows], %i[w words], %i[c bytesize]].freeze

NUMBER_OF_LINES = 8

def main
  parsed_argv = argv

  if parsed_argv[:filenames].empty?
    stdin = $stdin.read
    output_stdin(stdin, parsed_argv)
  else
    exit_include_dirname(parsed_argv)

    output_argv(parsed_argv)
  end
end

def argv
  opt = OptionParser.new
  opt.on('-l') { |v| v }
  opt.on('-w') { |v| v }
  opt.on('-c') { |v| v }

  filenames = opt.parse(ARGV)
  options = opt.getopts(ARGV).keys.map(&:to_sym)
  { filenames: filenames, options: options }
end

def output_stdin(stdin, parsed_argv)
  inputs = [parse_file_info(parsed_argv, stdin)]

  if parsed_argv[:options].empty?
    inputs.first.delete(:filename)
    inputs.first.each_value { |input| output_value(input) }
    print "\n"
  else
    output_file_info(inputs, parsed_argv)
  end
end

def exit_include_dirname(commandline_args)
  current_file_lists = `ls -l`.split("\n").map { |input| input.split("\s") }
  commandline_args[:filenames].map do |arg|
    current_file_lists.map do |list|
      if list.first.include?('d') && arg.delete('/') == list.last
        puts "wc: #{arg}: read: Is a directory"
        exit
      end
    end
  end
end

def output_argv(parsed_argv)
  inputs = parse_file_info(parsed_argv)
  output_file_info(inputs, parsed_argv)

  sum_values(inputs, parsed_argv) if inputs.count >= 2
end

def output_file_info(inputs, parsed_argv)
  inputs.map do |input|
    OPTION_KEY_MAP.each do |option, key|
      output_value(input[key]) if parsed_argv[:options].empty? || parsed_argv[:options].include?(option)
    end
    puts "\s#{input[:filename]}"
  end
end

def parse_file_info(parsed_argv, *stdin)
  if parsed_argv[:filenames].empty?
    build_file_info(stdin.first)
  else
    file_names = parsed_argv[:filenames]
    file_names.map do |name|
      file_info = File.open(name).read
      build_file_info(file_info, name)
    end
  end
end

def build_file_info(file_info, *name)
  formatted_inputs = file_info.split("\n").map { |s| s.split("\s") }
  rows = formatted_inputs.count
  words = formatted_inputs.map(&:count).sum
  bytesize = file_info.bytesize

  { rows: rows, words: words, bytesize: bytesize, filename: name.first }
end

def sum_values(inputs, parsed_argv)
  file_values = inputs.map do |input|
    input.except(:filename)
  end

  total_values = {}.merge(*file_values) do |_key, current_hash, next_hash|
    current_hash + next_hash
  end

  output_sum_values(total_values, parsed_argv)
end

def output_sum_values(total_values, parsed_argv)
  OPTION_KEY_MAP.each do |option, key|
    output_value(total_values[key]) if parsed_argv[:options].empty? || parsed_argv[:options].include?(option)
  end
  puts "\stotal"
end

def output_value(int)
  print int.to_s.rjust(NUMBER_OF_LINES)
end

main
