# frozen_string_literal: true

require 'optparse'
require 'debug'

require_relative 'file'
require_relative 'row'

# コマンドを受け取って、オプションとディレクトリに分ける処理を行なう
class Command
  attr_reader :argv, :options, :directory_name, :file_stats

  def initialize(argv)
    @argv = argv
    @options = parse_command[:options]
    @directory_name = parse_command[:directory_name]
    @file_stats = fetch_files
  end

  def display_files
    if options.include?(:l)
      Row.new(file_stats, options).display_stats
    else
      Row.new(file_stats, options).display_name
    end
  end

  private

  def parse_command
    # OptionParserでコマンドライン引数を[:a,:r.:l]に分ける
    opt = OptionParser.new
    opt.on('-a') { |v| v }
    opt.on('-r') { |v| v }
    opt.on('-l') { |v| v }
    options = opt.getopts(argv).keys.map(&:to_sym)
    directory_name = opt.parse(argv)
    { directory_name: directory_name, options: options }
  end

  # ディレクトリから各ファイル情報を取得する
  def fetch_files
    dir_name = directory_name.empty? ? '*' : "#{directory_name.first}/*"
    files = Dir.glob(dir_name, ::File::FNM_DOTMATCH)
    files.map do |file|
      Ls::File.new(file, options).generate_stats
    end
  end
end
