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

# 第10フレームは最大3投になるので、3投分の点数を平坦化して配列に格納
# `delete`メソッドで「0」点を除外
frame_10th = frames[9..11].flatten
frame_10th.delete(0)

# 以下、`each`メソッド内の処理について
#   - 第10フレームは、ストライク時に1投目の点数（10点）のみを取得し、2投目（0点）を削除したい
#   - 実行例「./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8」
# frame_10th.each do |f|
#   f.pop if f.first == 10 # `pop`メソッドで、第10フレームの配列 [[10, 0], [1, 8]] -> [[10], [1, 8]]に整形
# end
# frame_10th.flatten! # 第10フレームの配列 => [10, 1, 8] を生成

# 1〜9フレームまでの点数を格納した配列に、10フレーム目の配列を追加
frame_1st_to_9th = frames[0..8]
all_frames = frame_1st_to_9th << frame_10th

# 点数の初期値を0に設定
points = 0

all_frames.each.with_index(1) do |frame, i| # 次の投球を取得するため、with_indexメソッドで変数iの初期値を「1」にする
  if frame.first == 10 # Strike
    points += frame.sum if i == 10 # 第10フレーム1投目でストライクが出た時、第10フレームの合計を加算
    break if all_frames[i].nil? # 第10フレームの処理が終了したら処理を終了

    points += if all_frames[i].first == 10 # 次のフレームの1投目が10点（ストライクが連続）
                if i < 9 # 第1〜8フレームまで
                  10 + all_frames[i].first + all_frames[i + 1].first # 次のフレームと、次の次のフレームの1投目を合計
                elsif i == 9 # 第9フレーム
                  frame.sum + all_frames[i][0..1].sum # 第9フレームと第10フレームの1〜2投目を合計
                end
              else
                10 + all_frames[i][0..1].sum
              end
  elsif frame.sum == 10 # Spare
    points += 10 + all_frames[i].first
  else
    points += frame.sum
  end
end
puts points
