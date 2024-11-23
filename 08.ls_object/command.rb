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
    { directory_name: directory_name, options: options }
  end

  def fetch_files
    dir_name = directory_name.empty? ? '*' : "#{directory_name.first}/*"
    files = options.include?(:a) ? Dir.glob(dir_name, ::File::FNM_DOTMATCH) : Dir.glob(dir_name)

    files.map do |file|
      Ls::File.new(file, options).generate_file_stats
    end
  end
end
