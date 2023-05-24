#!/bin/bash
#
# update IP address
#
# MyDNS

# Include File ロード
FILE_DIR="/usr/local/mydns-ip/"
source "${FILE_DIR}mydns-ip.conf"
source "${FILE_DIR}bin/mydns-ip-common.sh"

mydns_update() {
# ipv4用
    if [ "$IPV4" = on ]; then
        multi_domain_update "https://ipv4.mydns.jp/login.html"
    fi
# ipv6用
    if [ "$IPV6" = on ]; then
        multi_domain_update "https://ipv6.mydns.jp/login.html"
    fi
}

# 引数としてLogin URLをもらう $1=Login URL
multi_domain_update() {
    LOGIN_URL=$1
    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            echo "ERROR : MYDNS_ID[$i] MYDNS_PASS[$i]  <- どちらかに値がないエラー"
            continue
        fi 
        dns_accsse "${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} $LOGIN_URL"
    done
}

# 実行スクリプト（タイマー処理）
sleep 3m;mydns_update
while true;do
    sleep $UPDATE_TIME;mydns_update
done
