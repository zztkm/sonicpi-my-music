# Daft Punk風サウンドを作ろう 完成版: ファンキー・ディスコ・エクスプロージョン！(何いってんねん)

use_bpm 123

# --- 指揮者ループ ---
live_loop :control do
  set :bar_count, tick
  sleep 4
end

# --- フィルターとディストーション ---
with_fx :rlpf, cutoff: 50 do |fx_filter|
  with_fx :distortion, distort: 0 do |fx_distort|
    
    # --- 各楽器パート ---
    
    live_loop :kick do
      sync :control
      bar = get(:bar_count)
      if bar < 24 or bar >= 28 then
        sample :bd_haus, amp: 2.5
      end
    end
    
    live_loop :snare_and_clap do # スネアとクラップを同時に鳴らすループ
      sync :control
      bar = get(:bar_count)
      if bar >= 4 and bar < 24 then
        sleep 1; sample :sn_dolf, amp: 1.5; sleep 1
      elsif bar >= 28 then
        # ▼▼▼ ドロップでクラップを追加！ ▼▼▼
        sleep 1
        sample :sn_dolf, amp: 1.5
        sample :perc_snap, amp: 1.2 # 手拍子の音を追加
        sleep 1
      end
    end
    
    live_loop :snare_fill do
      sync :control
      if get(:bar_count) == 27 then
        sleep 3
        with_fx :hpf, cutoff: 90 do
          16.times do; sample :elec_snare, amp: rrand(0.5, 1); sleep 0.0625; end
        end
      end
    end
    
    live_loop :hihat do
      sync :control
      bar = get(:bar_count)
      if bar >= 4 and bar < 24 then
        4.times do; sleep 0.5; sample :elec_hi_hat, amp: 0.8; sleep 0.5; end
      elsif bar >= 28 then
        8.times do; sample :elec_hi_hat, amp: 1.2; sleep 0.25; end
      end
    end
    
    live_loop :bassline do
      sync :control
      bar = get(:bar_count)
      if (bar >= 8 and bar < 24) or bar >= 28 then
        use_synth :tb303
        res_val = (bar >= 28) ? 0.9 : 0.7
        16.times do
          play scale(:e2, :minor_pentatonic).choose, release: 0.13, cutoff: rrand(90, 120), res: res_val, amp: 1.5
          sleep 0.25
        end
      end
    end
    
    # ▼▼▼ 新規追加: ファンキーなカッティングギター！ ▼▼▼
    live_loop :guitar do
      sync :control
      bar = get(:bar_count)
      # 28小節目のドロップから登場
      if bar >= 28 then
        # 16分音符の裏で鳴らすとファンキーになる
        sleep 0.25
        sample :guit_em9, rate: 2, amp: 1.2 # Eマイナー9thのギターサウンド
        sleep 0.25
      end
    end
    
    # ▼▼▼ 新規追加: 高揚感のあるコードパッド！ ▼▼▼
    live_loop :pads do
      sync :control
      bar = get(:bar_count)
      # 28小節目のドロップから登場
      if bar >= 28 then
        use_synth :prophet # 暖かみのあるシンセ
        with_fx :reverb, room: 0.8 do
          play_chord chord(:e3, :m7), release: 4, amp: 1.5 # Eマイナー7thコードを鳴らす
        end
      end
    end
    
    live_loop :arp do
      sync :control
      bar = get(:bar_count)
      if bar >= 12 then
        if bar < 16 then
          control fx_filter, cutoff: line(50, 130, steps: 16).look
        elsif bar < 24 then
          control fx_filter, cutoff: 130
        elsif bar < 28 then
          control fx_filter, cutoff: 60
          control fx_distort, distort: 0
        else
          control fx_filter, cutoff: 130
          control fx_distort, distort: 0.5
        end
        
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
      if bar == 16 or bar == 20 or bar == 28 then
        sample :drum_cymbal_open, amp: 1.8, finish: 0.5, release: 2
      end
    end
    
    live_loop :crystal do
      sync :control
      bar = get(:bar_count)
      if (bar >= 16 and bar < 24) or bar >= 28 then
        use_synth :pretty_bell
        with_fx :echo, phase: 0.75, decay: 4 do
          play scale(:e6, :minor_pentatonic).choose, amp: 1, release: 0.5
        end
      end
    end
    
  end
end