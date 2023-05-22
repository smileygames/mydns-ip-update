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
        if [ $IP_NEW != "" ]; then
            multi_domain "https://ipv4.mydns.jp/login.html"
        fi
    fi
# ipv6
    if [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
        IP_NEW=$(curl -s ifconfig.io -6)
        if [ $IP_NEW != "" ]; then
            multi_domain "https://ipv6.mydns.jp/login.html"
        fi
    fi
}

# 引数としてLogin URLをもらう [$1]
multi_domain() {
    for (( i = 0 ; i < ${#MYDNS_IP[@]} ; i++ )) do
        IP_OLD=$(dig "${MY_DOMAIN[i]}" A +short)
        if [[ $IP_NEW != $IP_OLD ]]; then
            curl -s -u ${MYDNS_IP[i]}:${MYDNS_PASS[i]} $1
        fi
    done
}

# 実行スクリプト（タイマー処理）
while true;do
  sleep $DDNS_TIME;mydns_change
done
