#!/bin/bash
#
# ./ipv_check.sh
#
# MyDNS

#File_dir="/usr/local/mydns-ip-update/"
#source "${File_dir}config/default.conf"
#User_File="${File_dir}config/user.conf"

#if [ -e ${User_File} ]; then
#    source "${User_File}"
#fi

Mode=$1

ip_update() {
    if [ "$IPV4" = on ]; then
        . ./multi_domain/ip_set.sh "update" "$MYDNS_IPV4_URL"
    fi
    if [ "$IPV6" = on ]; then
        . ./multi_domain/ip_set.sh "update" "$MYDNS_IPV6_URL"
    fi
}

ip_check() {
    if [ "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
        . ./multi_domain/ip_set.sh "check" "$MYDNS_IPV4_URL" "4" "A" 
    fi
    if [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
        . ./multi_domain/ip_set.sh "check" "$MYDNS_IPV6_URL" "6" "AAAA"
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