# sim_egadget
e-Gadgetプログラムのシミュレータです．

## sim_egadget_beginner
体験教室のシミュレータです．`main`のセクションを書き換えてe-Gadgetの動きをシミュレーションしてみよう．
`saveflag=true`とすると，シミュレーション結果の動画を保存できます．
保存したくない場合や，描画が重すぎる場合は`saveflag=false`としてください．

### 実装されているコマンド
`motor(left_power, right_power)`
モーターを動かすためのコマンドです．e-gadgetと同じ仕様にしているので，左右のモーターパワーを入力してください．

`wait(time)`
待機コマンドです．時間の単位は秒です．c-codeの`wait_ms`と混同しないでください．
実質的にはここで動作シミュレーションを行っています．


## sim_egadget_beginner2
センサー１個を用いたサッカーのシミュレータです．`main`のセクションを書き換えてe-Gadgetの動きをシミュレーションしてみよう．
`saveflag=true`とすると，シミュレーション結果の動画を保存できます．
保存したくない場合や，描画が重すぎる場合は`saveflag=false`としてください．

無条件ループを設定するとMATLABプログラムが永遠に終わらないので，適当な時間で終了するよう条件ループにしています．

### 実装されているコマンド
`motor(left_power, right_power)`
モーターを動かすためのコマンドです．e-gadgetと同じ仕様にしているので，左右のモーターパワーを入力してください．

`wait(time)`
待機コマンドです．時間の単位は秒です．c-codeの`wait_ms`と混同しないでください．
実質的にはここで動作シミュレーションを行っています．