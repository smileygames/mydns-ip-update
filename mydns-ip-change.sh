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

# 引数としてレコードとLogin URLをもらう $1=レコード $2=URL
# IP_NEWはコールされる前に入れておくこと
multi_domain_change() {
    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MY_DOMAIN[$i]} = "" ]] || [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            echo "ERROR : MY_DOMAIN[$i] MYDNS_ID[$i] MYDNS_PASS[$i]  <- どれかに値がないエラー"
            continue
        fi 
        IP_OLD=$(dig "${MY_DOMAIN[i]}" $1 +short)
        if [[ $IP_NEW != $IP_OLD ]]; then
            MYDNS_ACCESS="${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} $2"
            timeout 1m curl -sSfu $MYDNS_ACCESS; if [ $? != 0 ]; then echo "ERROR : $MYDNS_ACCESS  <- 通知接続エラー"; fi
            if [ $? != 0 ]; then 
                echo "ERROR : $MYDNS_ACCESS  <- TIME OUT [60sec]"
                exit 1
            fi
        fi
    done
}

# 実行スクリプト（タイマー処理）
while true;do
  sleep $DDNS_TIME;mydns_change
done
