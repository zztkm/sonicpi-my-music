# Daft Punk風サウンドを作ろう Step 1: ノリの良いリズム (これは残しておく)

use_bpm 123

live_loop :kick do
  sample :bd_haus, amp: 2
  sleep 1
end

live_loop :snare do
  sleep 1
  sample :sn_dolf, amp: 1.5
  sleep 1
end

live_loop :hihat do
  sleep 0.5
  sample :elec_hi_hat, amp: 0.8
  sleep 0.5
end


# ↓↓↓ ここから下を追記してください ↓↓↓

# --- ステップ2：「うねうね」と「キラキラ」を追加 ---

# 「うねうね」したシンセベース
live_loop :bassline do
  use_synth :tb303   # Daft Punkも使ったと言われるシンセの音
  
  # cutoffは音の明るさ/こもり具合を調整するパラメータです
  # rrand(下限, 上限) で、鳴らすたびにcutoff値がランダムに変わり「うねうね」します
  play scale(:e2, :minor_pentatonic, num_octaves: 2).choose, release: 0.13, cutoff: rrand(70, 110), amp: 1.5
  sleep 0.25
end


# 「キラキラ」したシンセメロディ
live_loop :arp do
  use_synth :fm        # キラキラした電子音が得意なシンセ
  
  # with_fx :reverb で音に響きを加えて、キラキラ感を増します
  with_fx :reverb, room: 0.7, mix: 0.6 do
    play scale(:e4, :minor_pentatonic, num_octaves: 2).choose, amp: 0.7, release: 0.2
    sleep [0.25, 0.25, 0.5].choose # sleep時間をランダムにしてリズムに揺らぎを出します
  end
end