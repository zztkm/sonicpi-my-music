# Daft Punk風サウンドを作ろう Step 1: ノリの良いリズム

# 曲の速さを決めます (BPM = Beats Per Minute)
# Daft Punkの曲はだいたい110〜125くらいが多いです
use_bpm 123

# live_loop は特定のコードを繰り返し再生し続ける命令です

# 「ドン、ドン、ドン、ドン」という力強いキックドラム
live_loop :kick do
  # :bd_haus はハウスミュージックでよく使われる太いキックの音です
  sample :bd_haus, amp: 2
  sleep 1 # 1拍待つ
end

# 「パンッ、パンッ」と鳴るスネアドラム
# 2拍目と4拍目に鳴らします
live_loop :snare do
  sleep 1 # 1拍目はお休み
  sample :sn_dolf, amp: 1.5 # :sn_dolf は存在感のあるスネア
  sleep 1 # 3拍目はお休み
end

# 「チッ、チッ、チッ、チッ」と細かく刻むハイハット
live_loop :hihat do
  sleep 0.5 # 0.5拍（8分音符）で刻みます
  sample :elec_hi_hat, amp: 0.8
  sleep 0.5
end