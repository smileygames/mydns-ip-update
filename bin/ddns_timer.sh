#!/bin/bash
#
# ./ddns_timer.sh
#
# shellcheck source=/dev/null

# include file
File_dir="../config/"
source "${File_dir}default.conf"
User_File="${File_dir}user.conf"
if [ -e ${User_File} ]; then
    source "${User_File}"
fi

Mode=$1

# IPv4とIPv6でアクセスURLを変える
ip_update() {
    if [ "$IPV4" = on ]; then
        . ./ddns_timer/multi_domain.sh "update" "$MYDNS_IPV4_URL"
    fi
    if [ "$IPV6" = on ]; then
        . ./ddns_timer/multi_domain.sh "update" "$MYDNS_IPV6_URL"
    fi
}

# 動的アドレスモードの場合、チェック用にIPvバージョン情報とレコード情報も追加
ip_check() {
    if [ "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
        . ./ddns_timer/multi_domain.sh "check" "$MYDNS_IPV4_URL" "4" "A" 
    fi
    if [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
        . ./ddns_timer/multi_domain.sh "check" "$MYDNS_IPV6_URL" "6" "AAAA"
    fi
}

# 実行スクリプト
# タイマー処理
case ${Mode} in
   "update")
        sleep 5m;ip_update  # 起動から少し待って最初の処理を行う
        while true;do
            sleep "$UPDATE_TIME";ip_update
        done
        ;;
   "check") 
        while true;do
            sleep "$DDNS_TIME";ip_check
        done
        ;;
    * )
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac
