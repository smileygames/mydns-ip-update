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

# 引数としてLogin URLをもらう $1=Login URL
multi_domain_update() {
    LOGIN_URL=$1
    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            echo "ERROR : MYDNS_ID[$i] MYDNS_PASS[$i]  <- どちらかに値がないエラー"
            continue
        fi 
        mydns_accsse "${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} $LOGIN_URL"
    done
}

# 引数の中身は @1 = "MYDNS_ID:MYDNS_PASS Login_URL" となる
# 共通関数 mydns-ip-change.shに全く同じ関数がある
mydns_accsse() {
    MYDNS_ACCESS=$1
    timeout 15 curl -m 10 -sSu $MYDNS_ACCESS
    if [ $? != 0 ]; then 
        echo "ERROR : $MYDNS_ACCESS  <- TIME OUT [15sec]"
    fi
}

# 実行スクリプト（タイマー処理）
sleep 3m;mydns_update
while true;do
    sleep $UPDATE_TIME;mydns_update
done
