#!/bin/bash
#
# update dynamic IP address
#
# MyDNS

# Config File ロード
FILE_DIR="/home/hal/update/"
source "${FILE_DIR}mydns-ip-update.conf"

mydns_change() {
# ipv4
    if [ "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
        IP_NEW=$(curl -s ifconfig.io -4)
        if [ $IP_NEW != "" ]; then
            multi_domain_ipv4
        fi
    fi
# ipv6
    if [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
        IP6_NEW=$(curl -s ifconfig.io -6)
        if [ $IP6_NEW != "" ]; then
            multi_domain_ipv6
        fi
    fi
}

multi_domain_ipv4() {
    for (( i = 0 ; i < ${#MYDNS_IP[@]} ; i++ )) do
        echo "dig ${MY_DOMAIN[i]}"
        IP_OLD=$(dig "${MY_DOMAIN[i]}" A +short)
        echo "NEW = $IP_NEW"
        echo "OLD = $IP_OLD"
        if [[ $IP_NEW != $IP_OLD ]]; then
            echo "ipv4 ${MYDNS_IP[i]}:${MYDNS_PASS[i]}"
#            curl -s -u ${MYDNS_IP[i]}:${MYDNS_PASS[i]} https://ipv4.mydns.jp/login.html
        fi
    done
}

multi_domain_ipv6() {
    for (( i = 0 ; i < ${#MYDNS_IP[@]} ; i++ )) do
        echo "dig ${MY_DOMAIN[i]}"
        IP6_OLD=$(dig "${MY_DOMAIN[i]}" AAAA +short)
        echo "NEW = $IP6_NEW"
        echo "OLD = $IP6_OLD"
        if [[ $IP6_NEW != $IP6_OLD ]]; then
            echo "ivv6 ${MYDNS_IP[i]}:${MYDNS_PASS[i]}"
#            curl -s -u ${MYDNS_IP[i]}:${MYDNS_PASS[i]} https://ipv6.mydns.jp/login.html
        fi
    done
}

# 実行スクリプト（タイマー処理）
while true;do
  sleep $DDNS_TIME;mydns_change
done
