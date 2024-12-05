# frozen_string_literal: true

require_relative 'multi_column_output'
require_relative 'long_format_output'

MAX_COLUMNS = 3

class FileList
  def initialize(files, options = [])
    @files = options.include?(:r) ? files.reverse.compact : files.compact
    display_files(options)
  end

  private

  def display_files(options)
    options.include?(:l) ? LongFormatOutput.new(@files).display : MultiColumnOutput.new(@files, MAX_COLUMNS).display
  end
end
