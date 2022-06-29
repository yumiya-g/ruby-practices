#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0] # コマンドライン引数の0番目を取得
scores = score.split(',') # カンマで引数を分割

shots = [] # 各フレームの得点を格納する配列

scores.each do |s| # ストライク（X）を[10, 0]に変換して配列に格納
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = [] # フレームごとに1投目と2投目を分けて、2次元配列にする
shots.each_slice(2) do |shot|
  frames << shot
end

# 10フレームは、ストライク時に1投目の点数を取得して2投目（0点）は削除
# 最大3投分の配列が入った配列を平坦化
frame_10th = frames[9..11]
frame_10th.each do |f|
  f.pop if f.first == 10
end
frame_10th.flatten!

# 1〜9フレームまでの点数を格納した配列に、10フレーム目の配列を追加
frames = frames[0..8] << frame_10th

points = 0

frames.each.with_index(1) do |frame, i|
  if frame.first == 10 # Strike
    return p points += 10 + frame[1..2].sum if i == 10 # 第10フレームのストライク集計

    points += if frame == [10, 0] && frames[i] == [10, 0] # ストライクが連続する場合
                10 + frames[i].first + frames[i + 1].first
              else
                10 + frames[i][0..1].sum
              end
  elsif frame.sum == 10 # Spare
    points += 10 + frames[i].first
  else
    points += frame.sum
  end
end
p points
