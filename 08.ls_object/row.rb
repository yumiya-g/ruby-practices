# frozen_string_literal: true

require 'debug'

MAX_COLUMNS = 3

class Row
  attr_reader :file_stats

  def initialize(file_stats, options = [])
    @file_stats = file_stats.compact # 隠しファイルがnilになった場合、除外している
    @options = options
  end

  def display_file_name
    rows = (file_stats.size.to_f / MAX_COLUMNS).ceil # 商切り上げで列数を出す
    sliced_file_name = file_stats.each_slice(rows).to_a # ファイル名を3つずつ配列にする
    adjusted_names = adjust_padding(sliced_file_name) # ファイル名の文字列を調整する

    adjusted_names.first.zip(*adjusted_names[1..]).map do |name|
      puts name.join("\s")
    end
  end

  def adjust_padding(sliced_file_name)
    max_number_chars = file_stats.max_by(&:bytesize).bytesize
    sliced_file_name.map do |names|
      names.map do |name|
        name.ljust(max_number_chars)
      end
    end
  end
end
