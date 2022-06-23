#!/usr/bin/env ruby
require 'date'
require 'optparse'

# コマンドライン引数で「月」と「年」を設定
get_month_year = ARGV.getopts('m:y:')

# 今日の日付を取得
today = Date.today

# 年・月を設定（引数がなければ、今日の年月）
year = get_month_year["y"] || today.year
month = get_month_year["m"] || today.month
# 毎月の1日目と最終日を設定
first_day_of_month = Date.new(year.to_i, month.to_i, 1)
last_day_of_month = Date.new(year.to_i, month.to_i, -1)

# カレンダー整形
6.times{ print "\s" }
puts "#{month}月\s#{year}年"
puts "日 月 火 水 木 金 土"
print "\s" * (first_day_of_month.wday * 3) # 初日の曜日位置調整
(first_day_of_month..last_day_of_month).each do |day|
  # 今日の日付をハイライト
  if day == today
    print "\e[7m"
    print day.strftime('%e')
    print "\e[0m"
  else
    print day.day.to_s.rjust(2) # rjustメソッドで調整
  end
  print "\s"
  puts if day.saturday?
end
puts "\n" * 2
