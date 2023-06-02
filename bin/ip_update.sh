#!/bin/bash
#
# ./ip_update.sh
#
# MyDNS

# include file
File_dir="/usr/local/mydns-ip-update/"
source "${File_dir}config/default.conf"
User_File="${File_dir}config/user.conf"
if [ -e ${User_File} ]; then
    source "${User_File}"
fi

timer_select() {
    if [ "$IPV4" = on ] || [ "$IPV6" = on ]; then
        if [  "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
            ./ddns_timer.sh "check" &

        elif [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
            ./ddns_timer.sh "check" &
        fi
        ./ddns_timer.sh "update" &

        while true;do
            wait -n
            End_code=$?
            if [ $End_code != 0 ]; then
                ./err_message.sh "process" ${FUNCNAME[0]} "endcode=$End_code  プロセスのどれかが異常終了した為、強制終了しました。"
                exit 1
            fi
        done
    fi
}

# 実行スクリプト
timer_select
