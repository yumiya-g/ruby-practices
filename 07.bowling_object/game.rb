#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'
require 'debug'

# 渡されたスコアを定数に代入する
marks = ARGV[0]

# 全投球を格納する配列を定義
all_shots = marks.split(',').map { |s| s }

class Game
  # attr_reader :all_frames, :frame, :all_shots

  # ARGVで渡されたFrameクラスに渡してスコアを配列にする
  # 配列を作る
  def initialize(all_shots)
    @all_shots = all_shots
    # 全フレームを格納する空配列を定義
    @all_frames = []
    # 各フレームを格納する空配列を定義
    @frame = []
  end
  
  # スコアを配列に整形
  def all_frame_scores
    @all_shots.each do |shot|
      # shotを配列に格納
      @frame << shot

      if @all_frames.size < 10 # 9フレーム目まで
        #２投目が格納済み、またはストライク
        if @frame.size >=2 || shot == 'X'
          @all_frames << @frame.dup
          @frame.clear
        end
      else # 10フレームは3投目も加える
        @all_frames.last << shot
      end
    end
    score_per_frames(@all_frames)
  end


  # Frameクラスに配列を渡す
  def score_per_frames(all_frames)
    @scores = []
    all_frames.each do |frame|
      frame = Frame.new(*frame)
      @scores << frame.create_scores_per_frame
    end
    calc_points(@scores) #10フレーム3投目が格納されてない
  end

  def calc_points(scores)
    point_sum = 0 
    scores.size.times do |frame_num|
      frame, next_frame, after_next_frame = scores[frame_num, 3]
      next_frame ||= []
      after_next_frame ||= []

      point = 0
      if one_to_nine_frame?(frame_num)# 9フレームまで
        if strike?(frame) # Strike:次のフレームを足す
            point += frame.sum + next_frame[0..1].sum
            # point += after_next_frame.first if next_frame.count == 1
            point += after_next_frame.first if next_strike?(next_frame)
        elsif spare?(frame)# Spare:次のフレームを足す
          point += frame.sum + next_frame.first
        else # 10未満
          point += frame[0..1].sum
        end
      else # 10フレーム
        point += frame.sum
      end
      point_sum += point
    end
    point_sum
  end

  def strike?(frame)
    frame.first == 10
  end

  def next_strike?(frame)
    frame.count == 1
  end

  def spare?(frame)
    frame[0..1].sum == 10
  end

  def one_to_nine_frame?(frame_num)
    frame_num < 9
  end
end

 frames = Game.new(all_shots)
 p scores = frames.all_frame_scores
