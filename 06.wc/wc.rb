#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

OPTION_KEY_MAP = [%i[l rows], %i[w words], %i[c bytesize]].freeze
NUMBER_OF_LINES = 8

def main
  parsed_argv = argv

  if parsed_argv[:filenames].empty?
    output_stdin($stdin.read, parsed_argv)
  else
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
    inputs.map { |input| output_value(input, parsed_argv) }
    print "\n"
  else
    output_file_info(inputs, parsed_argv)
  end
end

def output_argv(parsed_argv)
  inputs = parse_file_info(parsed_argv)
  output_file_info(inputs, parsed_argv)

  sum_values(inputs, parsed_argv) if inputs.count >= 2
end

def output_file_info(inputs, parsed_argv)
  inputs.map do |input|
    output_value(input, parsed_argv)
    puts "\s#{input[:filename]}"
  end
end

def parse_file_info(parsed_argv, *stdin)
  if parsed_argv[:filenames].empty?
    build_file_info(stdin.first)
  else
    file_names = parsed_argv[:filenames]
    file_names.map do |name|
      file_code = File.open(name).read
      build_file_info(file_code, name)
    end
  end
end

def build_file_info(file_code, *name)
  formatted_inputs = file_code.split("\n").map { |s| s.split("\s") }
  rows = formatted_inputs.count
  words = formatted_inputs.map(&:count).sum
  bytesize = file_code.bytesize

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
  output_value(total_values, parsed_argv)
  puts "\stotal"
end

def output_value(values, parsed_argv)
  OPTION_KEY_MAP.each do |option, key|
    print values[key].to_s.rjust(NUMBER_OF_LINES) if parsed_argv[:options].empty? || parsed_argv[:options].include?(option)
  end
end

main
