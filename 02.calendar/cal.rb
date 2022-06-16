#!/usr/bin/env ruby
require 'date'
require 'optparse'

# コマンドライン引数で「月」と「年」を設定
get_month_year = ARGV.getopts('m:y:')

# 今日の日付を取得
today = Date.today

# -m と -y に引数を指定
if get_month_year["m"] && get_month_year["y"]
  first_day_of_month = Date.new(get_month_year["y"].to_i, get_month_year["m"].to_i, 1)
  last_day_of_month = Date.new(get_month_year["y"].to_i, get_month_year["m"].to_i, -1)
  set_year = get_month_year["y"].to_i
  set_month = get_month_year["m"].to_i
# -m だけに引数を指定
elsif get_month_year["m"]
  first_day_of_month = Date.new(today.year, get_month_year["m"].to_i, 1)
  last_day_of_month = Date.new(today.year, get_month_year["m"].to_i, -1)
  set_year = today.year
  set_month = get_month_year["m"].to_i
# -y だけに引数を指定すると、処理を終了  
elsif get_month_year["y"]
  puts "コマンドライン引数に「#{get_month_year["y"]}」を設定しました"
  return
else
# 引数がなければ、今月の開始日と終了日を取得
  first_day_of_month = Date.new(today.year, today.mon, 1)
  last_day_of_month = Date.new(today.year, today.mon, -1)
  set_year = today.year
  set_month = today.month
end

# カレンダー整形
6.times{ print "\s" }
puts "#{set_month}月\s#{set_year}年"
puts "日 月 火 水 木 金 土"
(first_day_of_month.wday * 3).times{ print "\s" } # 初日の曜日位置調整
(first_day_of_month..last_day_of_month).each do |day|
  # 今日の日付をハイライト
  if (set_month == today.month && set_year == today.year) && day.strftime(format = '%e') == today.day.to_s
    print "\e[7m"
    print day.strftime(format = '%e')
    print "\e[0m"
  else
    print day.strftime(format = '%e')
  end
  
  print "\s"
  puts ("\n") if day.saturday? # 土曜で改行を入れる
end
puts ("\n\n")
