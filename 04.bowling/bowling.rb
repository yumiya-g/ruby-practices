#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0] # コマンドライン引数の0番目を取得
scores = score.split(',') # カンマで引数を分割

shots = [] # 各フレームの得点を格納する配列

scores.each do |s| # ストライク（X）を[10, 0]変換して配列に格納
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = [] # フレームごとに得点を分けて、2次元配列にする
shots.each_slice(2) do |shot|
  frames << shot
end

# 10フレームはストライク時に1投目の点数のみ取得して平坦化する
frames_10th = frames[9..11]
frames_10th.each do |f|
  f.pop if f.first == 10
end
p frames_10th.flatten!

# 1~9フレームまでの点数を配列に格納して、10フレーム目の配列を末尾に追加
p frames = frames[0..8]
p frames << frames_10th
