# Welcome to Sonic Pi

# play_pattern_timed [:c2, :d2, :e2, :d2], [0.5, 0.25, 0.75, 0.5]
use_bpm 90

# 以下の Scrapbox に調べたことを色々まとめているが、全然活かせていない
# https://scrapbox.io/zztkm/%E5%88%9D%E3%82%81%E3%81%A6%E3%81%AE%E4%BD%9C%E6%9B%B2

# Reference
# [Yesterday - Atmosphere 楽譜]: https://musescore.com/user/947631/scores/459706
# https://www.print-gakufu.com/guide/4003/
# Untitled (2012) <Yesterdayをサンプリングした曲> https://soundcloud.com/kandytownlife/unreleased-demo-2012

# 構成
# 最初はピアノメロディだけからスタート
# ちょっとずつ音が増えていく
# 終わりにかけてあとに追加されたものから音が外れていく LIFO（Last In, First Out, 後入れ先出し）
#   スタックみたいだな (https://ja.wikipedia.org/wiki/%E3%82%B9%E3%82%BF%E3%83%83%E3%82%AF)
# ↓のような感じにしたい
# (0). ピアノメロディ
# 1. ピアノメロディ + ドラム
# 2. ドラム
# 3. ドラム + ? (ベース？なんか音を足す)
# 4. ドラム + ? + ピアノメロディ
# 5. ピアノメロディ

# extra
# 5からさらに盛り上げるのもありかもしれない



# NOTE
# この曲は 16 拍が一区切り
# だんだん音が増えていって、最終的にはまたピアノのみになっていく構成
# 完成には遠い、まだ気持ちよさが足りない気がする
# 抽象化できそうな場所はのちのち対応していく
live_loop :main do
  
  live_loop :merodyChannel do
    use_synth :piano
    # 16 * 8 = 128 拍
    2.times do
      merodyIntro
    end

    sleep 16

    5.times do
      merodyIntro
    end
    
    stop
  end

  #live_loop :codeChannel do
  #  use_synth :bass_foundation
  #  # 16 * 4 = 128 拍
  #  sleep 16
  #  4.times do
  #    merodyIntro
  #  end
  #  
  #  stop
  #end
  
  live_loop :drumChannel do
    # 16 + 2 * 24 = 64 拍
    # 8
    48.times do
      drumIntro
    end
    
    stop
  end
  
  stop # ここの stop がないと ZeroTimeLoopError が表示される
end

define :drumIntro do
  #sample :hat_zap, amp: 1
  sleep 0.5
  #sample :hat_zap, amp: 1
  sleep 0.5
  sample :bd_ada
  sleep 1
end

define :merodyIntro do
  with_fx :compressor, amp: 1.5 do
    # total 1拍
    # 1 小節目 4 拍
    play [:e6, :a4, :a3], release: 0.8, amp: 2
    sleep 0.5
    play [:d6, :g4, :g3], release: 0.8, amp: 2
    sleep 0.5
    play [:c6, :e4, :e3], release: 0.5, amp: 2
    sleep 0.5
    play [:c6, :a5, :d4, :d3], release: 1.5, amp: 2
    sleep 1
    play [:g5, :c4, :c3], release: 0.8, amp: 2
    sleep 0.5
    play [:g5, :e5, :a3, :a2], release: 1, amp: 1.5
    sleep 1
    
    # 2 小節目 3 拍
    play [:g5, :e5, :a3, :a2], release: 0.5, amp: 2
    sleep 0.5
    play [:d5, :g3, :g2], release: 0.5, amp: 2
    sleep 0.5
    play [:c5, :e3, :e2], release: 0.5, amp: 2
    sleep 0.5
    play [:a4, :e4, :d4, :d3, :d2], release: 2, amp: 2 # 伸ばすところ
    sleep 1.5
    
    # 1 拍
    play :g4, release: 0.5
    sleep 0.3
    play :a4, release: 0.5
    sleep 0.2
    play :c5, release: 1
    sleep 0.5
    
    # てってってってーのとところ
    # 3 拍
    play [:c5, :a4, :f4, :d3, :d2], release: 0.5, amp: 2
    sleep 0.5
    play [:c5, :a4, :f4, :d3, :d2], release: 1, amp: 2
    sleep 1
    play [:c5, :a4, :f4, :g3, :g2], release: 2, amp: 2
    sleep 1.5
    
    # 1 拍
    play :g4, release: 0.5
    sleep 0.3
    play :a4, release: 0.5
    sleep 0.2
    play :c5, release: 1
    sleep 0.5
    
    # 3 拍
    play [:c5, :a4, :f4, :f3, :f2], release: 0.5, amp: 2
    sleep 0.5
    play [:c5, :a4, :f4, :f3, :f2], release: 1, amp: 2
    sleep 1
    play [:c5, :g4, :e4, :c3, :c2], release: 2, amp: 2
    sleep 1.5
    
    # 1 拍
    play :g5, release: 0.5
    sleep 0.3
    play :a5, release: 0.5
    sleep 0.2
    play :c6, release: 1
    sleep 0.5
  end
end


define :funkyBaseline do
  with_fx :lpf, cutoff: 80 do
    play_pattern_timed [:e2, :d3, :e3, :e2, :d3, :e2, :d3, :e2, :d3, :e3, :c2, :c3, :c2, :c3, :c2, :b1, :b1, :a2, :b2, :g2],
      [0.5, 0.5, 0.5, 0.5, 0.5, 0.25, 0.5, 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5],
      release: 0.0 , sustain: 0.3
  end
end

define :drumline do
  sample :drum_cymbal_closed, amp: 0.7
  sample :bd_fat, amp: 4
  sleep 0.5
  sample :drum_cymbal_closed, amp: 0.7
  sleep 0.25
  sample :bd_fat, amp: 4
  sleep 0.25
  sample :drum_cymbal_closed, amp: 0.7
  # スネアを少しジャストからずらす
  sleep laid_back
  sample :sn_zome, amp: 0.7
  sleep 0.5 - laid_back
  sample :drum_cymbal_closed, amp: 0.7
  sleep 0.5
  sample :drum_cymbal_closed, amp: 0.7
  sleep 0.5
  sample :drum_cymbal_closed, amp: 0.7
  sleep 0.25
  sample :bd_fat, amp: 4
  sleep 0.25
  sample :drum_cymbal_closed, amp: 0.7
  # スネアを少しジャストからずらす
  sleep laid_back
  sample :sn_zome, amp: 0.7
  sleep 0.5 - laid_back
  sample :drum_cymbal_closed, amp: 0.7
  sleep 0.5
end