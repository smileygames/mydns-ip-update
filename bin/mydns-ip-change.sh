#!/bin/bash
#
# update dynamic IP address
#
# MyDNS

# Include File
FILE_DIR="/usr/local/mydns-ip/"
source "${FILE_DIR}mydns-ip.conf"
source "${FILE_DIR}bin/mydns-ip-common.sh"

mydns_change() {
# ipv4
    if [ "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
        SERVER_IPV4=$(curl -s ifconfig.io -4)
        if [[ $SERVER_IPV4 != "" ]]; then
            multi_domain_change $SERVER_IPV4 "A" "https://ipv4.mydns.jp/login.html"
        fi
    fi
# ipv6
    if [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
        SERVER_IPV6=$(curl -s ifconfig.io -6)
        if [[ $SERVER_IPV6 != "" ]]; then
            multi_domain_change $SERVER_IPV6 "AAAA" "https://ipv6.mydns.jp/login.html"
        fi
    fi
}

multi_domain_change() {
    IP_NEW=$1
    DNS_RECORD=$2
    LOGIN_URL=$3

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
