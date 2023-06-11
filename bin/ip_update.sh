#!/bin/bash
#
# ./ip_update.sh
#
# shellcheck source=/dev/null

# include file
File_dir="../config/"
source "${File_dir}default.conf"
User_File="${File_dir}user.conf"
if [ -e ${User_File} ]; then
    source "${User_File}"
fi

# タイマーイベントを選択し、実行する
timer_select() {
    if [ ${#MYDNS_ID[@]} != 0 ]; then
        if [ "$IPV4" = on ] || [ "$IPV6" = on ]; then
            ./ddns_timer.sh "update" &  # MyDNSのアップデートタイマーを開始
        fi
        if [  "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
            ./ddns_timer.sh "check" &  # IPv4のDDNSチェックタイマーを開始

        elif [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
            ./ddns_timer.sh "check" &  # IPv6のDDNSチェックタイマーを開始
        fi
    fi
}

# 実行スクリプト
timer_select
# バックグラウンドプロセスを監視して通常終了以外の時、異常終了させる
while true;do
    wait -n
    End_code=$?
    if [ $End_code != 0 ]; then
        ./err_message.sh "process" "ip_update.sh" "endcode=$End_code  プロセスのどれかが異常終了した為、強制終了しました。"
        exit 1
    fi
done
