#!/bin/bash
#
# ./mydns_ip_update.sh
#
# MyDNS

#File_dir="/home/hal/update/mydns-ip-update/"
File_dir="/usr/local/mydns-ip-update/"
source "${File_dir}config/default.conf"
User_File="${File_dir}config/user.conf"

if [ -e ${User_File} ]; then
    source "${User_File}"
fi

mydns_ip_update() {
    if [ "$IPV4" = on ] || [ "$IPV6" = on ]; then
        if [  "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
            trap "kill 1" EXIT
            ./ipv_check.sh "check" "ipv4_ddns" &
        elif [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
            trap "kill 1" EXIT
            ./ipv_check.sh "check" "ipv6_ddns" &
        fi
        trap "kill 1" EXIT
        ./ipv_check.sh "update" &

       	wait -n
        ./err_message.sh "process" ${FUNCNAME[0]} "error endcode=$?  プロセスのどれかが異常終了した為、強制終了しました。"
        exit 1
    fi
}

# 実行スクリプト
mydns_ip_update

