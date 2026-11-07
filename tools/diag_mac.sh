#!/bin/bash
# diag_mac.sh  -  Home Assistant の VM を動かせるかを診断する、読み取り専用のスクリプト（macOS 用）
#
# 方針:
#   - 何も変更しない（設定変更、ファイル書き込み、sudo、外部への送信はしない）。
#   - シリアル番号、UUID、ホスト名、ユーザー名、MAC アドレス、IP アドレス、SSID は出力しない。
#   - 結果は画面に出るだけ。保存したいときは、実行時にリダイレクトする。
#       bash diag_mac.sh > ~/Desktop/diag_mac.txt
#   - 動作は macOS 標準のコマンドだけを使う。bash 3.2（macOS 標準）で動くように書いてある。
#
# 注意: このスクリプトの作者の環境は Linux のため、macOS 上での実行は未確認（構文チェックのみ）。
#       コマンドが失敗した項目は「取得できませんでした」と出る。その場合は、その項目を教えてほしい。

# 取得できないコマンドでも止まらないようにする（set -e は使わない）
run() {
  "$@" 2>/dev/null || echo "(取得できませんでした: $1)"
}

section() {
  echo
  echo "=== $1 ==="
}

echo "診断スクリプト: macOS 用（読み取り専用）"
echo "実行日時(UTC): $(date -u '+%Y-%m-%d %H:%M')"

section "1. OS"
run sw_vers

section "2. ハードウェア"
echo "アーキテクチャ: $(uname -m)"
echo "CPU: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo '(取得できませんでした)')"
echo "論理コア数: $(sysctl -n hw.ncpu 2>/dev/null || echo '(取得できませんでした)')"
mem_bytes=$(sysctl -n hw.memsize 2>/dev/null)
if [ -n "$mem_bytes" ]; then
  echo "RAM: $((mem_bytes / 1024 / 1024 / 1024)) GB"
else
  echo "RAM: (取得できませんでした)"
fi
# シリアル番号と UUID を含む項目は取らない（Model Name / Model Identifier / Chip / Memory のみ）
system_profiler SPHardwareDataType 2>/dev/null \
  | grep -E 'Model Name|Model Identifier|Chip|Memory:' \
  || echo "(system_profiler から取得できませんでした)"

section "3. 仮想化の支援（1 なら Hypervisor が使える）"
echo "kern.hv_support: $(sysctl -n kern.hv_support 2>/dev/null || echo '(取得できませんでした)')"

section "4. ストレージの空き容量"
if [ -d /System/Volumes/Data ]; then
  run df -h /System/Volumes/Data
else
  run df -h /
fi

section "5. 電源とスリープ（常時稼働の可否に関わる）"
echo "-- 電源の状態（バッテリー ID は伏せる）--"
batt=$(pmset -g batt 2>/dev/null)
if [ -n "$batt" ]; then
  printf '%s\n' "$batt" | sed -E 's/\(id=[0-9]+\)//'
else
  echo "(取得できませんでした: pmset)"
fi
echo "-- 電源ごとのスリープ設定 --"
pmset -g custom 2>/dev/null \
  | grep -E 'Power:|sleep|womp|powernap|lowpowermode|standby|hibernatemode|autopoweroff' \
  || echo "(取得できませんでした: pmset)"
echo "-- 稼働時間 --"
run uptime

section "6. ネットワーク（既定の経路の種類だけ。アドレスは出さない）"
iface=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')
if [ -n "$iface" ]; then
  # 'Hardware Port: Wi-Fi' のような名前だけを出す（MAC アドレスの行は出さない）
  port=$(networksetup -listallhardwareports 2>/dev/null \
    | awk -v d="$iface" '/^Hardware Port:/{p=$0} $0=="Device: " d {print p}')
  if [ -n "$port" ]; then
    echo "既定の経路: $port"
  else
    echo "既定の経路: (種類を取得できませんでした)"
  fi
else
  echo "既定の経路: (取得できませんでした)"
fi
echo "接続中の VPN の数: $(scutil --nc list 2>/dev/null | grep -c 'Connected')"
echo "-- ファイアウォール --"
run /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

section "7. mDNS で Google Cast 端末（Nest Hub など）が見えるか（5 秒間、受信するだけ）"
if command -v dns-sd >/dev/null 2>&1; then
  out=$( ( dns-sd -B _googlecast._tcp local. & pid=$!; sleep 5; kill "$pid" 2>/dev/null; wait "$pid" 2>/dev/null ) 2>/dev/null )
  count=$(printf '%s\n' "$out" | grep -c ' Add ')
  echo "見つかった Cast 端末の数: $count"
  # 端末の識別子らしい長い 16 進数は <id> に置き換えて出す
  printf '%s\n' "$out" | grep ' Add ' | sed -E 's/[0-9a-fA-F]{12,}/<id>/g'
  if [ "$count" = "0" ]; then
    echo "(0 件: mDNS が通っていないか、取りこぼしの可能性。結果の判断は Claude に任せてほしい)"
  fi
else
  echo "(dns-sd が見つかりませんでした)"
fi

section "8. 仮想化ソフトなどの有無（名前だけ）"
ls /Applications 2>/dev/null | grep -iE 'virtualbox|utm|parallels|vmware|docker|orbstack' || echo "(該当なし)"
if command -v VBoxManage >/dev/null 2>&1; then
  echo "VBoxManage: $(VBoxManage --version 2>/dev/null)"
else
  echo "VBoxManage: (未インストール)"
fi
if command -v brew >/dev/null 2>&1; then
  echo "Homebrew: あり"
else
  echo "Homebrew: なし"
fi

echo
echo "=== 以上 ==="
echo "このスクリプトは何も変更していません。"
