#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0] # コマンドライン引数の0番目を取得
scores = score.split(',')

shots = [] # スコアの数値を配列にして格納

scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = [] # スコアの配列を、フレームごとに分けた2次元配列作る

shots.each_slice(2) do |shot|
  p shot
  if shot[0] == 10 # Strike
    # 次の配列の合計値を加算する
  elsif shot.sum == 10 # Spare
    # 次の配列の1投目のスコアに10点加算する
  else
    # 2回投げて9点以下
    # frames << shot.sum
    frames << shot
  end
end

p frames
