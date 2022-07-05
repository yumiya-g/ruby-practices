#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0] # コマンドライン引数の0番目を取得
scores = score.split(',') # カンマで引数を分割

shots = [] # 各フレームの得点を格納する配列

scores.each do |s| # ストライク（X）は[10, 0]に変換して、配列に格納
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# 各フレームごとの1投目と2投目を配列にして、2次元配列にする
frames = shots.each_slice(2).to_a

# 第10フレームは最大3投になるので、3投分の点数を平坦化して配列に格納し、0点を除外
frame_10th = frames[9..11].flatten
frame_10th.delete(0)

# 以下の`each`メソッドの処理について
# 第10フレームは、ストライク時に1投目の点数（10点）のみを取得し、2投目（0点）を削除したい
# 実行例「./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8」より、
# 第10フレームの配列：[[10, 0], [1, 8]]
# frame_10th.each do |f|
#   f.pop if f.first == 10 # 第10フレームの配列 => [[10], [1, 8]]
# end
# frame_10th.flatten! # 第10フレームの配列 => [10, 1, 8]としていた

# 1〜9フレームまでの点数を格納した配列に、10フレーム目の配列を追加
all_frames = frames[0..8] << frame_10th

points = 0

all_frames.each.with_index(1) do |frame, i|
  if frame.first == 10 # Strike
    return p points += 10 + frame[1..2].sum if i == 10 # 第10フレームのストライク集計

    points += if frame == [10, 0] && all_frames[i] == [10, 0] # ストライクが連続する場合
                10 + all_frames[i].first + all_frames[i + 1].first
              else
                10 + all_frames[i][0..1].sum
              end
  elsif frame.sum == 10 # Spare
    points += 10 + all_frames[i].first
  else
    points += frame.sum
  end
end
p points
