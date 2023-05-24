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
    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            echo "ERROR : MYDNS_ID[$i] MYDNS_PASS[$i]  <- どちらかに値がないエラー"
            continue
        fi 
        MYDNS_ACCESS="${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} $1"
        mydns_accsse
    done
}

# MYDNS_ACCESS が事前に必要、中身は ID:PASS URL となる
# mydns-ip-change.shでも全く同じ関数がある共通化の仕方は考え中
mydns_accsse() {
    timeout 1m curl -sSfu $MYDNS_ACCESS; if [ $? != 0 ]; then echo "ERROR : $MYDNS_ACCESS  <- 通知接続エラー"; fi
    if [ $? != 0 ]; then 
        echo "ERROR : $MYDNS_ACCESS  <- TIME OUT [60sec]"
        exit 1
    fi
}


# 実行スクリプト（タイマー処理）
sleep 3m;mydns_update
while true;do
    sleep $UPDATE_TIME;mydns_update
done
