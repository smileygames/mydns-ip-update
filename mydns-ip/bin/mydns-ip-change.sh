#!/bin/bash
#
# update dynamic IP address
#
# MyDNS

# Include File ロード
FILE_DIR="/usr/local/mydns-ip/"
source "${FILE_DIR}mydns-ip.conf"
source "${FILE_DIR}bin/mydns-ip-common.sh"

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
            dns_accsse "${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} $LOGIN_URL"
        fi
    done
}

# 実行スクリプト（タイマー処理）
while true;do
  sleep $DDNS_TIME;mydns_change
done
