# frozen_string_literal: true

require 'etc'
require_relative 'row'

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
    attr_reader :file_stats, :date, :permission

    def initialize(file = nil, options = [])
      @options = options
      @file_stats = ::File::Stat.new(file)
      @blocks = file_stats.blocks
      @type = file_stats.ftype
      @permission = convert_characters(file_stats.mode)
      @nlink = file_stats.nlink
      @owner = Etc.getpwuid(file_stats.uid).name
      @group = Etc.getgrgid(file_stats.gid).name
      @size = file_stats.size
      @date = generate_date_object
      @name = ::File.basename(file)
    end

    def generate_file_stats
      {
        blocks: @blocks,
        permission: @permission,
        nlink: @nlink,
        owner: @owner,
        group: @group,
        size: @size,
        date: @date,
        name: @name
      }
    end

    private

    def convert_characters(permission)
      chars = permission.to_s(8)[-3..].chars.map do |p|
        FILE_PERMISSION[p.to_sym]
      end
      FILE_TYPE[@type.to_sym] + chars.join
    end

    def generate_date_object
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
