#!/bin/bash
#
# mydns ip update
#
# MyDNS

# Include File
#FILE_DIR="/usr/local/mydns-ip-update/"
FILE_DIR="/home/hal/mydns-ip-update/"
source "${FILE_DIR}mydns-ip.conf"

MODE=$1

ip_update() {
    if [ "$IPV4" = on ]; then
        ./multi_domain_ip.sh "update" "$MYDNS_IPV4_URL"
    fi

    if [ "$IPV6" = on ]; then
        ./multi_domain_ip.sh "update" "$MYDNS_IPV6_URL"
    fi
}

ip_check() {
    if [ "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
        ./multi_domain_ip.sh "check" "$MYDNS_IPV4_URL" "4" "A" 
    fi

    if [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
        ./multi_domain_ip.sh "check" "$MYDNS_IPV6_URL" "6" "AAAA"
    fi
}

# 実行スクリプト
case ${MODE} in
   "update")
#        sleep 5m;ip_update
        sleep 5;ip_update
        while true;do
            sleep $UPDATE_TIME;ip_update
        done
        ;;
   "check") 
        while true;do
            sleep $DDNS_TIME;ip_check
        done
        ;;
    * )
        echo "${MODE} <- 引数エラーです"
    ;; 
esac
