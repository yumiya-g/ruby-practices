# frozen_string_literal: true

class LongFormatOutput
  def initialize(files)
    @files = files
  end  

  def display
    puts "total #{@files.sum { |fs| fs.file_stats[:blocks] }}"
    puts output_columns
  end

  private

  def output_columns
    digits = generate_file_stats_digits
    @files.map do |fs|
      [
        fs.file_stats[:permission],
        fs.file_stats[:nlink].to_s.rjust(digits[:nlink]),
        fs.file_stats[:owner].rjust(digits[:owner]),
        fs.file_stats[:group].rjust(digits[:group] + 1),
        fs.file_stats[:size].to_s.rjust(digits[:size] + 1),
        "#{fs.file_stats[:date][:month]} #{fs.file_stats[:date][:day]}",
        "#{fs.file_stats[:date][:hour]}:#{fs.file_stats[:date][:min]} #{fs.file_stats[:name]}"
      ].join("\s")
    end
  end

  def generate_file_stats_digits
    {
      nlink: @files.map { |f| f.file_stats[:nlink].to_s.size }.max,
      size: @files.map { |f| f.file_stats[:size].to_s.size }.max,
      owner: @files.map { |f| f.file_stats[:owner].size }.max,
      group: @files.map { |f| f.file_stats[:group].size }.max
    }
  end
end
