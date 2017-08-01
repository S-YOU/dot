#!/bin/bash
cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
cat > /home/ec2-user/.screenrc <<'SCREENRC_END'
escape ^T^T

#term xterm

# Use blue text instead of underline
#attrcolor b ".I"

# 256色対応に加えて、F1～F4が効くようにk1～k4も書いておく。
# hs: ハードステータスがあるか
# is: xtermの初期化文字列（端末エミュレータのウィンドウサイズが変わらないようにしておく）
termcapinfo xterm* 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm:k1=\E[11~:k2=\E[12~:k3=\E[13~:k4=\E[14~:hs@:is=\E[r\E[m\E[2J\E[H\E[?7h\E[?1;4;6l'

# erase/insert/scroll/clear 操作でクリアされるすべての文字は、現在の背景色で表示されることになる
defbce "on"

#defencoding utf-8
defencoding utf8
encoding utf8 utf8
defscrollback 2000
ignorecase on
startup_message off
vbell off
altscreen on
#cjkwidth on
#multiuser on


# Pageup, Pagedownでウィンドウ切り替え
bindkey "^[[5~" prev
bindkey "^[[6~" next

setenv BUFFERFILE "$HOME/.yank"
bufferfile "$BUFFERFILE"

bind ^v eval readbuf "paste ."

# %-w   前のウィンドウ
# %{ }  カラー指定 r赤 g緑 b青 y黄 cシアン mマジェンダ
# %n    ウィンドウ番号
# %t    ウィンドウ名
# %{-}  カラーリセット
# %+w   後のウィンドウ
# %=    パディング
# %l    システム負荷
#
# %? A  %?    条件Aが真ならAを表示
# %? B %: C %?    条件Bが真ならBを、偽ならCを表示
hardstatus alwayslastline "[%H] %-w%{.b}%n %t%{-}%+w %= %` %l"
caption splitonly "%?%F%{.b}%?%n %t"
SCREENRC_END
