#!/bin/sh
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
            IP_OLD=$(dig $MY_DOMAIN A +short)

            if [[ $IP_NEW != $IP_OLD ]]; then
                curl -s -u $MYDNS_IP:$MYDNS_PASS https://ipv4.mydns.jp/login.html
            fi
        fi
    fi

# ipv6
    if [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
        IP6_NEW=$(curl -s ifconfig.io -6)

        if [ $IP6_NEW != "" ]; then
            IP6_OLD=$(dig $MY_DOMAIN AAAA +short)

            if [[ $IP6_NEW != $IP6_OLD ]]; then
                curl -s -u $MYDNS_IP:$MYDNS_PASS https://ipv6.mydns.jp/login.html
            fi
        fi
    fi
}

# 実行スクリプト（タイマー処理）
while true;do
  sleep $DDNS_TIME;mydns_change
done
