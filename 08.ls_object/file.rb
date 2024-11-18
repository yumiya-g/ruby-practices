# frozen_string_literal: true

# require 'optparse'
require 'debug'

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

# コマンドを受け取って、オプションとディレクトリに分ける処理を行なう
module Ls
  class File
    attr_reader :options, :files, :name, :stats, :date, :permission

    def initialize(file = nil, options = [])
      @options = options
      @name = ::File.basename(file)
      @stats = ::File::Stat.new(file)
      @type = stats.ftype # ファイル or ディレクトリ
      @permission = convert_characters(stats.mode) # パーミッション 8進数に変更する
      @owner = Etc.getpwuid(stats.uid).name # 所有者
      @group = Etc.getgrgid(stats.gid).name # 所属グループ
      @size = stats.size # ファイルサイズ
      @date = generate_date_object # タイムスタンプ
      @symlink = stats.nlink
    end

    # Rowクラスに渡すデータを出力する
    def generate_stats
      # optionに"-l"含む(ファイル情報を含む)
      if options.include?(:l)
        # debugger
      else # "-l"含まない（ファイル名だけ返せばよい）
        # ":a"含む
        if options.include?(:a) # 隠しファイル表示
          name
        elsif !name.start_with?('.') # 隠しファイルを除外
          name
        end
      end
    end

    private

    def convert_characters(permissions)
      chars = permissions.to_s(8)[-3..].chars.map do |p|
        FILE_PERMISSION[p.to_sym]
      end
      FILE_TYPE[@type.to_sym] + chars.join
    end

    def generate_date_object
      {
        year: stats.mtime.year,
        month: stats.mtime.month,
        day: stats.mtime.day,
        hour: stats.mtime.hour,
        min: stats.mtime.min
      }
    end
  end
end
