#!/bin/bash
#
# mydns ip update
#
# MyDNS

# Include File
File_dir="/usr/local/mydns-ip-update/"
#File_dir="/home/hal/mydns-ip-update/"
source "${File_dir}default.conf"
source "${File_dir}user.conf"

Mode=$1

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
case ${Mode} in
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
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac