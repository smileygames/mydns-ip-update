#!/bin/bash
#
# update IP address
#
# MyDNS

# Config File ロード
FILE_DIR="/usr/local/etc/"
source "${FILE_DIR}mydns-ip-update.conf"

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

# 引数としてLogin URLをもらう $1=URL
multi_domain_update() {
    for (( i = 0 ; i < ${#MYDNS_ID[@]} ; i++ )) do
        if [[ $MYDNS_ID[i] = "" ]] || [[ $MYDNS_PASS[i] = "" ]]; then
            echo "MYDNS_ID[$i] MYDNS_PASS[$i] のどれかに値がないエラー"
            continue
        fi 
        curl -sSfu ${MYDNS_ID[i]}:${MYDNS_PASS[i]} $1
        if [ $? != 0 ]; then 
            echo "${MYDNS_ID[i]}:${MYDNS_PASS[i]} $1  <- MyDNSへの通知接続エラー"
        fi
    done
}

# 実行スクリプト（タイマー処理）
sleep 3m;mydns_update
while true;do
    sleep $UPDATE_TIME;mydns_update
done
