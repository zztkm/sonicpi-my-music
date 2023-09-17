=begin
hellowold
version 1.1.0


以下の Scrapbox に調べたことを色々まとめているが、全然活かせていない
https://scrapbox.io/zztkm/%E5%88%9D%E3%82%81%E3%81%A6%E3%81%AE%E4%BD%9C%E6%9B%B2

Reference
[Yesterday - Atmosphere 楽譜]: https://musescore.com/user/947631/scores/459706
https://www.print-gakufu.com/guide/4003/
Untitled (2012) <Yesterdayをサンプリングした曲> https://soundcloud.com/kandytownlife/unreleased-demo-2012

構成
最初はピアノメロディだけからスタート
ちょっとずつ音が増えていく
終わりにかけてあとに追加されたものから音が外れていく LIFO（Last In, First Out, 後入れ先出し）
  スタックみたいだな (https://ja.wikipedia.org/wiki/%E3%82%B9%E3%82%BF%E3%83%83%E3%82%AF)
↓のような感じにしたい
(0). ピアノメロディ
1. ピアノメロディ + ドラム
2. ドラム
3. ドラム + ? (ベース？なんか音を足す)
4. ドラム + ? + ピアノメロディ
5. ピアノメロディ

extra
5からさらに盛り上げるのもありかもしれない


## NOTE
- この曲は 16 拍が一区切り
- だんだん音が増えていって、最終的にはまたピアノのみになっていく構成
- 完成には遠い、まだ気持ちよさが足りない気がする
- 抽象化できそうな場所はのちのち対応していく

=end

use_bpm 90

live_loop :main do
  
  live_loop :melodyChannel do
    use_synth :fm
    # 16 * 8 = 128 拍
    3.times do
      melodyLine
    end

    sleep 16 # = 1

    4.times do
      melodyLine
    end

    # 16 * 8 = 128 拍
    7.times do
      melodyLine
    end
    1.times do
      melodyMain
    end
    stop
  end

  live_loop :baselineChannel do
    sleep 128 # 前半は休憩
    use_synth :organ_tonewheel
    # 16 * 8 = 128 拍
    8.times do
      baseline
    end
  end

  live_loop :nazoloopChannel do
    sleep 128 # 前半は休憩
    28.times do
      with_fx :compressor, amp: 1.5 do
        sample :loop_breakbeat, beat_stretch: 4
        sleep 4
      end
    end
    stop
  end

  live_loop :synthChannel do
    sleep 56

    use_synth :piano
    14.times do
      wahSynth
    end

    sleep 56

    use_synth :piano
    14.times do
      wahSynth
    end
    
    stop
  end
  
  live_loop :drumChannel do
    sleep 16
    # 32
    16.times do
      drumIntro
    end

    # 64
    8.times do
      mainDrumLine
    end

    sleep 16

    # 112
    14.times do
      with_fx :compressor, amp: 1.5  do
        mainDrumLine
      end
    end
    
    stop
  end
  
  stop # ここの stop がないと ZeroTimeLoopError が表示される
end

# 4 拍
define :wahSynth do
  with_fx :ixi_techno, mix: 1, phase: 2 do
    play_pattern_timed [:e3, :g3, :b2, :d3, :d3], [0.5, 1, 0.5, 1.75, 0.25],
      attack: 0.0, sustain: 0.05, release: 0.1, width: 0, amp: 1.0
  end
end

define :drumIntro do
  with_fx :lpf, cutoff: 68 + tick * 2 do
    sample :bd_fat, amp: 2
    sleep 1
    sample :bd_fat, amp: 2
    sample :sn_zome, amp: 0.7
    sleep 1
  end
end

# 8 拍
define :mainDrumLine do
  4.times do
    drumline
  end
end

# 2 拍
define :drumline do
  sample :bd_fat, amp: 3
  sleep 0.5
  sample :hat_snap, amp: 0.7
  sleep 0.5
  sample :bd_fat, amp: 3
  sample :sn_zome, amp: 0.7
  sleep 0.5
  sample :hat_snap, amp: 0.7
  sleep 0.5
end

define :drumline2 do
  sample :bd_fat, amp: 3
  sleep 0.5
  sample :drum_cymbal_closed, amp: 0.4
  sleep 0.5
  sample :bd_fat, amp: 3
  sample :sn_zome, amp: 0.7
  sleep 0.5
  sample :drum_cymbal_closed, amp: 0.4
  sleep 0.5
end

define :simpleDrumline do
  sample :bd_fat, amp: 3
  sleep 0.5
  sleep 0.5
  sample :bd_fat, amp: 3
  sample :sn_zome, amp: 0.7
  sleep 0.5
  sleep 0.5
end

define :melodyLine do
  with_fx :compressor, amp: 1.5 do
    1.times do
      melodyMain
    end
    1.times do
      melodyContinue
    end
  end
end

define :melodyMain do
  with_fx :compressor, amp: 1.0 do
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
    play [:a4, :e4, :d4, :d3, :d2], release: 3, amp: 2 # 伸ばすところ
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
  end
end

define :melodyContinue do
  # 1 拍
  play :g5, release: 0.5
  sleep 0.3
  play :a5, release: 0.5
  sleep 0.2
  play :c6, release: 1
  sleep 0.5
end

define :melodySub do
  with_fx :compressor, amp: 1.0 do
    # total 1拍
    # 1 小節目 4 拍
    play [:g6, :c5, :c4], release: 0.8, amp: 2
    sleep 0.5
    play [:f6, :b4, :b3], release: 0.8, amp: 2
    sleep 0.5
    play [:e6, :g4, :g3], release: 0.5, amp: 2
    sleep 0.5
    play [:e6, :c6, :f4, :f3], release: 0.5, amp: 2
    sleep 1
    play [:b5, :e4, :e3], release: 0.8, amp: 2
    sleep 0.5
    play [:b5, :g5, :c4, :c3], release: 1, amp: 1.5
    sleep 1
    
    # 2 小節目 3 拍
    play [:b5, :g5, :c4, :c3], release: 0.5, amp: 2
    sleep 0.5
    play [:f5, :b3, :b2], release: 0.5, amp: 2
    sleep 0.5
    play [:e5, :g3, :g2], release: 0.5, amp: 2
    sleep 0.5
    play [:c5, :g4, :f4, :f3, :f2], release: 1, amp: 2 # 伸ばすところ
    sleep 1.5
    
    # 1 拍
    play :b4, release: 0.5
    sleep 0.3
    play :c5, release: 0.5
    sleep 0.2
    play :e5, release: 1
    sleep 0.5
    
    # てってってってーのとところ
    # 3 拍
    play [:e5, :c5, :a4, :f3, :f2], release: 0.5, amp: 2
    sleep 0.5
    play [:e5, :c5, :a4, :f3, :f2], release: 1, amp: 2
    sleep 1
    play [:e5, :c5, :a4, :b3, :b2], release: 1, amp: 2
    sleep 1.5
    
    # 1 拍
    play :b4, release: 0.5
    sleep 0.3
    play :c5, release: 0.5
    sleep 0.2
    play :e5, release: 1
    sleep 0.5
    
    # 3 拍
    play [:e5, :c5, :a4, :a3, :a2], release: 0.5, amp: 2
    sleep 0.5
    play [:e5, :c5, :a4, :a3, :a2], release: 1, amp: 2
    sleep 1
    play [:e5, :b4, :g4, :e3, :e2], release: 1.6, amp: 2
    sleep 1.5
  end
end

define :melodyContinueSub do
  # 1 拍
  play :b5, release: 0.5
  sleep 0.3
  play :c6, release: 0.5
  sleep 0.2
  play :e6, release: 1
  sleep 0.5
end

define :baseline do
  with_fx :compressor, amp: 1.0 do
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
    play [:a4, :e4, :d4, :d3, :d2], release: 3, amp: 2 # 伸ばすところ
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
    sleep 2.5
  end
end