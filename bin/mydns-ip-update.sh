#!/bin/bash
#
# update IP address
#
# MyDNS

# Include File
FILE_DIR="/usr/local/mydns-ip-update/"
source "${FILE_DIR}mydns-ip.conf"
source "${FILE_DIR}bin/mydns-ip-common.sh"

mydns_update() {
    if [ "$IPV4" = on ]; then
        multi_domain_update "https://ipv4.mydns.jp/login.html"
    fi

    if [ "$IPV6" = on ]; then
        multi_domain_update "https://ipv6.mydns.jp/login.html"
    fi
}

multi_domain_update() {
    LOGIN_URL=$1

    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            no_value_err_message "MYDNS_ID[$ARRAY_NUM] or MYDNS_PASS[$ARRAY_NUM]"
            continue
        fi 
        dns_accsse $i $LOGIN_URL
    done
}

# 実行スクリプト（タイマー処理）
sleep 5m;mydns_update
while true;do
    sleep $UPDATE_TIME;mydns_update
done
