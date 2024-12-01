# frozen_string_literal: true

require 'etc'

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

module Ls
  class File
    attr_reader :file_stats

    def initialize(file_name = nil)
      @file_name = file_name
      @file_stats = generate_file_stats(::File::Stat.new(file_name))
    end

    private

    def generate_file_stats(file_stats)
      {
        blocks: file_stats.blocks,
        type: file_stats.ftype,
        permission: convert_characters(file_stats),
        nlink: file_stats.nlink,
        owner: Etc.getpwuid(file_stats.uid).name,
        group: Etc.getgrgid(file_stats.gid).name,
        size: file_stats.size,
        date: generate_date_object(file_stats),
        name: ::File.basename(@file_name)
      }
    end

    def convert_characters(file_stats)
      chars = file_stats.mode.to_s(8)[-3..].chars.map do |fs|
        FILE_PERMISSION[fs.to_sym]
      end
      FILE_TYPE[file_stats.ftype.to_sym] + chars.join
    end

    def generate_date_object(file_stats)
      {
        year: file_stats.mtime.year.to_s,
        month: file_stats.mtime.month.to_s.rjust(2, '0'),
        day: file_stats.mtime.day.to_s.rjust(2, '0'),
        hour: file_stats.mtime.hour.to_s.rjust(2, '0'),
        min: file_stats.mtime.min.to_s.rjust(2, '0')
      }
    end
  end
end
