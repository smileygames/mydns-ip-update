#!/bin/bash
#
# update dynamic IP address
#
# MyDNS

# Config File ロード
FILE_DIR="/usr/local/etc/"
source "${FILE_DIR}mydns-ip-update.conf"

mydns_change() {
# ipv4
    if [ "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
        IP_NEW=$(curl -s ifconfig.io -4)
        if [[ $IP_NEW != "" ]]; then
            multi_domain_change "A" "https://ipv4.mydns.jp/login.html"
        fi
    fi
# ipv6
    if [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
        IP_NEW=$(curl -s ifconfig.io -6)
        if [[ $IP_NEW != "" ]]; then
            multi_domain_change "AAAA" "https://ipv6.mydns.jp/login.html"
        fi
    fi
}

# IP_NEWはコールされる前に入れておくこと
multi_domain_change() {
    DNS_RECORD=$1
    LOGIN_URL=$2
    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MY_DOMAIN[$i]} = "" ]] || [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            echo "ERROR : MY_DOMAIN[$i] MYDNS_ID[$i] MYDNS_PASS[$i]  <- どれかに値がないエラー"
            continue
        fi 
        IP_OLD=$(dig "${MY_DOMAIN[i]}" $DNS_RECORD +short)
        if [[ $IP_NEW != $IP_OLD ]]; then
            mydns_accsse "${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} $LOGIN_URL"
        fi
    done
}

# 引数の中身は @1 = "MYDNS_ID:MYDNS_PASS Login_URL" となる
# 共通関数 mydns-ip-update.shに全く同じ関数がある
mydns_accsse() {
    MYDNS_ACCESS=$1
    timeout 15 curl -m 10 -sSu $MYDNS_ACCESS
    if [ $? != 0 ]; then 
        echo "ERROR : $MYDNS_ACCESS  <- TIME OUT [15sec]"
    fi
}

# 実行スクリプト（タイマー処理）
while true;do
  sleep $DDNS_TIME;mydns_change
done
