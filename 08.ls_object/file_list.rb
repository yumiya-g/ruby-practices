# frozen_string_literal: true

require_relative 'directory_content'
require_relative 'directory_content_long_format'

MAX_COLUMNS = 3

class FileList
  def initialize(files, options = [])
    @files = options.include?(:r) ? files.reverse.compact : files.compact
    display_files(options)
  end

  private

  def display_files(options)
    options.include?(:l) ? DirectoryContentLongFormat.new(@files) : DirectoryContent.new(@files, MAX_COLUMNS)
  end
end
