# frozen_string_literal: true

require 'optparse'
require_relative 'file'
require_relative 'row'

class Command
  attr_reader :argv, :options, :directory_name, :file_stats

  def initialize(argv)
    @argv = argv
    @options = parse_command[:options]
    @directory_name = parse_command[:directory_name]
    @file_stats = fetch_files
  end

  def display_files
    Row.new(file_stats, options)
  end

  private

  def parse_command
    opt = OptionParser.new
    opt.on('-a') { |v| v }
    opt.on('-r') { |v| v }
    opt.on('-l') { |v| v }
    options = opt.getopts(argv).keys.map(&:to_sym)
    directory_name = opt.parse(argv)
    { directory_name:, options: }
  end

  def fetch_files
    directory = [directory_name.empty? ? '*' : "#{directory_name.first}/*"]
    directory << ::File::FNM_DOTMATCH if options.include?(:a)
    files =  Dir.glob(*directory)

    files.map do |file|
      Ls::File.new(file, options).generate_file_stats
    end
  end
end
