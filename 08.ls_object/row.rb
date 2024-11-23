# frozen_string_literal: true

MAX_COLUMNS = 3

class Row
  attr_reader :file_stats

  def initialize(file_stats, options = [])
    @options = options
    @file_stats = @options.include?(:r) ? file_stats.reverse.compact : file_stats.compact
    options.include?(:l) ? display_stats : display_name
  end

  private

  def display_stats
    puts "total #{file_stats.sum { |fs| fs[:blocks] }}"
    puts output_columns
  end

  def output_columns
    digits = generate_file_stats_digits
    file_stats.map do |fs|
      [
        fs[:permission],
        fs[:nlink].to_s.rjust(digits[:nlink]),
        fs[:owner].to_s.rjust(digits[:owner]),
        fs[:group].to_s.rjust(digits[:group] + 1),
        fs[:size].to_s.rjust(digits[:size] + 1),
        "#{fs[:date][:month]} #{fs[:date][:day]}",
        "#{fs[:date][:hour]}:#{fs[:date][:min]} #{fs[:name]}"
      ].join("\s")
    end
  end

  def display_name
    rows = (file_stats.size.to_f / MAX_COLUMNS).ceil
    adjusted_names = adjust_name_padding.each_slice(rows).to_a
    adjusted_names.first.zip(*adjusted_names[1..]).map do |name|
      puts name.join("\s")
    end
  end

  def generate_file_stats_digits
    {
      nlink: file_stats.max_by { |fs| fs[:nlink] }[:nlink].to_s.size,
      size: file_stats.max_by { |fs| fs[:size] }[:size].to_s.size,
      owner: file_stats.max_by { |fs| fs[:owner] }[:owner].to_s.size,
      group: file_stats.max_by { |fs| fs[:group] }[:group].to_s.size
    }
  end

  def adjust_name_padding
    max_number_chars = file_stats.max_by { |fs| fs[:name].size }[:name].size
    file_stats.map do |fs|
      fs[:name].to_s.ljust(max_number_chars)
    end
  end
end
