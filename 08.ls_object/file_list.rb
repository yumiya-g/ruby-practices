# frozen_string_literal: true

require 'debug'

require_relative 'file_name'
require_relative 'file_stat'

MAX_COLUMNS = 3

class FileList
  def initialize(files, options = [])
    @files = options.include?(:r) ? files.reverse.compact : files.compact
    display_files(options)
  end

  private

  def display_files(options)
    options.include?(:l) ? FileStat.display(@files) : FileName.display(@files, MAX_COLUMNS)
  end
end
