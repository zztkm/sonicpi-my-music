# Daft Punk風サウンドを作ろう 最終形態: フロア爆発 (不発弾)

use_bpm 123

# --- 指揮者ループ (変更なし) ---
live_loop :control do
  set :bar_count, tick
  sleep 4
end

# --- フィルターとディストーション ---
with_fx :rlpf, cutoff: 50 do |fx_filter|
  # distortionは音を歪ませてパワフルにするエフェクト。ドロップの切り札です。
  with_fx :distortion, distort: 0 do |fx_distort|
    
    # --- 各楽器パート ---
    
    live_loop :kick do
      sync :control
      bar = get(:bar_count)
      # ブレイク(24-27小節)ではキックを止める
      if bar < 24 or bar >= 28 then
        sample :bd_haus, amp: 2.5 # 少し音量を上げる
      end
    end
    
    live_loop :snare do
      sync :control
      bar = get(:bar_count)
      # 24-27小節はブレイク用のフィルイン、それ以外は通常パターン
      if bar >= 4 and bar < 24 then
        sleep 1
        sample :sn_dolf, amp: 1.5
        sleep 1
      elsif bar >= 28 then
        sleep 1
        sample :sn_dolf, amp: 2 # ドロップ後はパワフルに
        sleep 1
      end
    end
    
    # ブレイク用のスネアフィルイン
    live_loop :snare_fill do
      sync :control
      bar = get(:bar_count)
      # 27小節目の最後で高速連打！
      if bar == 27 then
        sleep 3 # 3拍待つ
        with_fx :hpf, cutoff: 90 do # 低音をカットして期待感を煽る
          16.times do
            sample :elec_snare, amp: rrand(0.5, 1)
            sleep 0.0625 # 64分音符で超高速連打
          end
        end
      end
    end
    
    live_loop :hihat do
      sync :control
      bar = get(:bar_count)
      if bar >= 4 and bar < 24 then
        # 通常のハイハット
        4.times do; sleep 0.5; sample :elec_hi_hat, amp: 0.8; sleep 0.5; end
      elsif bar >= 28 then
        # ドロップ後は16分音符で細かく刻む！
        8.times do; sample :elec_hi_hat, amp: 1.2; sleep 0.25; end
      end
    end
    
    live_loop :bassline do
      sync :control
      bar = get(:bar_count)
      # ブレイク中はベースを止める
      if (bar >= 8 and bar < 24) or bar >= 28 then
        use_synth :tb303
        # ドロップ後はレゾナンスを上げてより攻撃的に
        res_val = (bar >= 28) ? 0.9 : 0.7
        16.times do
          play scale(:e2, :minor_pentatonic).choose, release: 0.13, cutoff: rrand(90, 120), res: res_val, amp: 1.5
          sleep 0.25
        end
      end
    end
    
    live_loop :arp do
      sync :control
      bar = get(:bar_count)
      if bar >= 12 then
        # フィルターとディストーションの制御
        if bar < 16 then # 12-15: ビルドアップ
          control fx_filter, cutoff: line(50, 130, steps: 16).look
        elsif bar < 24 then # 16-23: クライマックス1
          control fx_filter, cutoff: 130
        elsif bar < 28 then # 24-27: ブレイク
          control fx_filter, cutoff: 60 # 少しこもらせる
          control fx_distort, distort: 0 # ディストーションはまだ0
        else # 28~: ドロップ(爆発)
          control fx_filter, cutoff: 130
          control fx_distort, distort: 0.5 # ディストーションON!
        end
        
        # ブレイク中はメロディもお休み
        if bar < 24 or bar >= 28 then
          use_synth :fm
          with_fx :reverb, room: 0.7 do
            8.times do; play scale(:e4, :minor_pentatonic, num_octaves: 2).choose, amp: 0.7, release: 0.2; sleep [0.25, 0.25, 0.5].choose; end
          end
        end
      end
    end
    
    live_loop :crash do
      sync :control
      bar = get(:bar_count)
      # 16, 20小節目と、ドロップの頭(28小節)で鳴らす
      if bar == 16 or bar == 20 or bar == 28 then
        sample :drum_cymbal_open, amp: 1.8, finish: 0.5, release: 2
      end
    end
    
    live_loop :crystal do
      sync :control
      bar = get(:bar_count)
      # ブレイク中はクリスタルもお休み
      if (bar >= 16 and bar < 24) or bar >= 28 then
        use_synth :pretty_bell
        with_fx :echo, phase: 0.75, decay: 4 do
          play scale(:e6, :minor_pentatonic).choose, amp: 1, release: 0.5
        end
      end
    end
    
  end
end