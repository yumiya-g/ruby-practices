#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

require 'debug'

OPTION_KEY_MAP = [%i[l rows], %i[w words], %i[c bytesize]].freeze
NUMBER_OF_LINES = 8

def main
  parsed_argv = argv

  inputs = if parsed_argv[:filenames].empty?
             parse_file_info(parsed_argv, $stdin.read)
           else
             parse_file_info(parsed_argv)
           end
  couted_file_info = count_file_options(inputs)
  total_values = sum_options_value(couted_file_info)

  output_file_info(couted_file_info, parsed_argv)
  output_total(total_values, parsed_argv) if couted_file_info.count >= 2
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

def parse_file_info(parsed_argv, stdin = nil)
  if parsed_argv[:filenames].empty?
    [[stdin, nil]]
  else
    file_names = parsed_argv[:filenames]
    file_names.map do |name|
      [File.open(name).read, name]
    end
  end
end

def count_file_options(inputs)
  inputs.map do |input|
    formatted_inputs = input.first.split("\n").map { |s| s.split("\s") }
    rows = formatted_inputs.count
    words = formatted_inputs.map(&:count).sum
    bytesize = input.first.bytesize
    filename = input.last

    { rows: rows, words: words, bytesize: bytesize, filename: filename }
  end
end

def sum_options_value(couted_file_info)
  file_values = couted_file_info.map do |info|
    info.except(:filename)
  end

  {}.merge(*file_values) do |_key, current_hash, next_hash|
    current_hash + next_hash
  end
end

def output_file_info(couted_file_info, parsed_argv)
  couted_file_info.map do |info|
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
