# frozen_string_literal: true

class DirectoryContent
  def initialize(files, max_columns)
    @files = files
    @max_columns = max_columns
    display
  end

  private

  def display
    rows = (@files.size.to_f / @max_columns).ceil
    adjusted_names = adjust_name_padding.each_slice(rows).to_a
    adjusted_names.first.zip(*adjusted_names[1..]).map do |name|
      puts name.join("\s")
    end
  end

  def adjust_name_padding
    max_number_chars = @files.map { |fs| fs.file_stats[:name].size }.max
    @files.map do |fs|
      fs.file_stats[:name].to_s.ljust(max_number_chars)
    end
  end
end
