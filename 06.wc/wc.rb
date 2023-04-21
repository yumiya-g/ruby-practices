#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

require 'debug'

OPTION_KEY_MAP = [%i[l rows], %i[w words], %i[c bytesize]].freeze
NUMBER_OF_LINES = 8

def main
  parsed_argv = argv

  inputs = if parsed_argv[:filenames].empty?
             read_file_contents(parsed_argv, $stdin.read)
           else
             read_file_contents(parsed_argv)
           end
  counted_file_info = count_file_contents(inputs)
  total_values = sum_options_value(counted_file_info)

  output_file_info(counted_file_info, parsed_argv)
  output_total(total_values, parsed_argv) if counted_file_info.count >= 2
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

def read_file_contents(parsed_argv, stdin = nil)
  if parsed_argv[:filenames].empty?
    [[stdin, nil]]
  else
    file_names = parsed_argv[:filenames]
    file_names.map do |name|
      [File.open(name).read, name]
    end
  end
end

def count_file_contents(inputs)
  inputs.map do |input|
    formatted_inputs = input.first.split("\n").map { |s| s.split("\s") }
    rows = formatted_inputs.count
    words = formatted_inputs.map(&:count).sum
    bytesize = input.first.bytesize
    filename = input.last

    { rows: rows, words: words, bytesize: bytesize, filename: filename }
  end
end

def sum_options_value(counted_file_info)
  file_values = counted_file_info.map do |info|
    info.except(:filename)
  end

  {}.merge(*file_values) do |_key, current_hash, next_hash|
    current_hash + next_hash
  end
end

def output_file_info(counted_file_info, parsed_argv)
  counted_file_info.map do |info|
    formatted_output(info, parsed_argv)
    puts "\s#{info[:filename]}"
  end
end

def output_total(total_values, parsed_argv)
  formatted_output(total_values, parsed_argv)
  puts "\stotal"
end

def formatted_output(option_value, parsed_argv)
  OPTION_KEY_MAP.each do |option, key|
    print option_value[key].to_s.rjust(NUMBER_OF_LINES) if parsed_argv[:options].empty? || parsed_argv[:options].include?(option)
  end
end

main
