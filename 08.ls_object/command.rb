# frozen_string_literal: true

require 'optparse'
require_relative 'file'
require_relative 'file_list'

class Command
  attr_reader :argv, :options, :directory_name

  def initialize(argv)
    @argv = argv
    @options = parse_command[:options]
    @directory_name = parse_command[:directory_name]
    @files = fetch_files
  end

  def display_files
    FileList.new(@files, options)
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
    directory_path = [directory_name.empty? ? '*' : "#{directory_name.first}/*"]
    directory_path << ::File::FNM_DOTMATCH if options.include?(:a)
    file_names = Dir.glob(*directory_path)

    file_names.map do |file_name|
      Ls::File.new(file_name)
    end
  end
end
